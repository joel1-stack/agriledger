const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

// ═════════════════════════════════════════════════════════════════════════════
// Trigger 1: Worker submits record → Notify Manager + Create in-app notification
// ═════════════════════════════════════════════════════════════════════════════
exports.onDailyRecordCreate = functions.firestore
  .document('daily_records/{docId}')
  .onCreate(async (snap, context) => {
    const data = snap.data();

    try {
      // Get unit to find manager
      const unitDoc = await db.collection('units').doc(data.unitId).get();
      if (!unitDoc.exists) {
        console.log(`Unit ${data.unitId} not found`);
        return;
      }

      const managerId = unitDoc.data().managerId;
      if (!managerId) {
        console.log(`No manager assigned to unit ${data.unitId}`);
        return;
      }

      const managerDoc = await db.collection('users').doc(managerId).get();
      if (!managerDoc.exists) {
        console.log(`Manager ${managerId} not found`);
        return;
      }

      const fcmToken = managerDoc.data().fcmToken;
      const moduleName = data.module.toUpperCase();
      const sheetName = data.sheetType.toUpperCase();
      const unitName = unitDoc.data().name || data.unitId;

      // Send FCM notification
      if (fcmToken) {
        try {
          const message = {
            token: fcmToken,
            notification: {
              title: `New ${moduleName} Record`,
              body: `${sheetName} for ${unitName}`,
            },
            data: {
              click_action: 'OPEN_APPROVAL_QUEUE',
              record_id: context.params.docId,
              module: data.module,
              unit_id: data.unitId,
            },
          };

          await messaging.send(message);
          console.log(`FCM sent to manager ${managerId}`);
        } catch (error) {
          console.error('Error sending FCM:', error);
        }
      }

      // Create in-app notification
      await db.collection('notifications').add({
        userId: managerId,
        title: `New ${moduleName} Record`,
        body: `${sheetName} for ${unitName}`,
        type: 'approval',
        module: data.module,
        read: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        data: {
          record_id: context.params.docId,
          sheet_type: data.sheetType,
          unit_id: data.unitId,
        },
      });

      console.log(`Record created notification sent to manager ${managerId}`);
    } catch (error) {
      console.error('Error in onDailyRecordCreate:', error);
    }
  });

// ═════════════════════════════════════════════════════════════════════════════
// Trigger 2: Manager approves/rejects → Notify Worker + Create Audit Log
// ═════════════════════════════════════════════════════════════════════════════
exports.onDailyRecordUpdate = functions.firestore
  .document('daily_records/{docId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    // Only trigger if status changed
    if (before.status === after.status) {
      return;
    }

    try {
      const workerId = after.recordedBy;
      const workerDoc = await db.collection('users').doc(workerId).get();
      if (!workerDoc.exists) {
        console.log(`Worker ${workerId} not found`);
        return;
      }

      const fcmToken = workerDoc.data().fcmToken;
      const isApproved = after.status === 'approved';
      const moduleName = after.module.toUpperCase();
      const sheetName = after.sheetType.toUpperCase();

      // Send FCM to worker
      if (fcmToken) {
        try {
          const message = {
            token: fcmToken,
            notification: {
              title: `${moduleName} Record ${isApproved ? 'Approved ✅' : 'Rejected ❌'}`,
              body: isApproved
                ? `Your ${sheetName} entry was approved`
                : `Reason: ${after.rejectionReason || 'No reason given'}`,
            },
            data: {
              click_action: isApproved ? 'OPEN_MY_HISTORY' : 'OPEN_EDIT_RECORD',
              record_id: context.params.docId,
              module: after.module,
              status: after.status,
            },
          };

          await messaging.send(message);
          console.log(`FCM sent to worker ${workerId}`);
        } catch (error) {
          console.error('Error sending FCM to worker:', error);
        }
      }

      // Create in-app notification for worker
      await db.collection('notifications').add({
        userId: workerId,
        title: `${moduleName} ${isApproved ? 'Approved' : 'Rejected'}`,
        body: isApproved
          ? `${sheetName} for ${after.unitId} approved`
          : `${sheetName} rejected: ${after.rejectionReason}`,
        type: isApproved ? 'approval' : 'rejection',
        module: after.module,
        read: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        data: {
          record_id: context.params.docId,
        },
      });

      // Write audit log
      await db.collection('audit_logs').add({
        module: after.module,
        action: isApproved ? 'APPROVED' : 'REJECTED',
        docId: context.params.docId,
        collection: 'daily_records',
        sheetType: after.sheetType,
        subType: after.subType,
        unitId: after.unitId,
        performedBy: after.approvedBy,
        performerRole: 'manager',
        previousStatus: before.status,
        newStatus: after.status,
        rejectionReason: after.rejectionReason || null,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log(`Approval processed for record ${context.params.docId}`);
    } catch (error) {
      console.error('Error in onDailyRecordUpdate:', error);
    }
  });

// ═════════════════════════════════════════════════════════════════════════════
// Trigger 3: Record deleted → Audit Log + Notify SuperAdmin
// ═════════════════════════════════════════════════════════════════════════════
exports.onDailyRecordDelete = functions.firestore
  .document('daily_records/{docId}')
  .onDelete(async (snap, context) => {
    const data = snap.data();

    try {
      // Write audit log
      await db.collection('audit_logs').add({
        module: data.module,
        action: 'DELETED',
        docId: context.params.docId,
        collection: 'daily_records',
        sheetType: data.sheetType,
        subType: data.subType,
        unitId: data.unitId,
        performedBy: 'system',
        performerRole: 'admin',
        previousData: data,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Notify all SuperAdmins
      const admins = await db
        .collection('users')
        .where('role', '==', 'superAdmin')
        .get();

      for (const adminDoc of admins.docs) {
        const token = adminDoc.data().fcmToken;
        if (token) {
          try {
            await messaging.send({
              token: token,
              notification: {
                title: `${data.module.toUpperCase()} Record Deleted`,
                body: `${data.sheetType} record for ${data.unitId} was deleted`,
              },
              data: {
                click_action: 'OPEN_AUDIT_LOGS',
                module: data.module,
              },
            });
          } catch (e) {
            console.error(`Error notifying admin:`, e);
          }
        }
      }

      console.log(`Record deletion logged for ${context.params.docId}`);
    } catch (error) {
      console.error('Error in onDailyRecordDelete:', error);
    }
  });

// ═════════════════════════════════════════════════════════════════════════════
// Trigger 4: Stock movement created → Notify for low stock
// ═════════════════════════════════════════════════════════════════════════════
exports.onStockMovement = functions.firestore
  .document('stock_movements/{movementId}')
  .onCreate(async (snap, context) => {
    const data = snap.data();

    try {
      if (data.type === 'out') {
        // Check if stock is below reorder level
        const itemDoc = await db.collection('inventory').doc(data.inventoryItemId).get();
        if (itemDoc.exists) {
          const item = itemDoc.data();
          const newBalance = (item.quantity || 0) - (data.quantity || 0);

          if (newBalance <= (item.reorderLevel || 10)) {
            // Notify managers
            const managers = await db
              .collection('users')
              .where('role', 'in', ['viewAdmin', 'superAdmin'])
              .get();

            for (const mgr of managers.docs) {
              const token = mgr.data().fcmToken;
              if (token) {
                await messaging.send({
                  token: token,
                  notification: {
                    title: 'Low Stock Alert',
                    body: `${item.name} is below reorder level (${newBalance} left)`,
                  },
                });
              }
            }
          }
        }
      }
    } catch (error) {
      console.error('Error in onStockMovement:', error);
    }
  });

console.log('Cloud Functions initialized for Agri-Ledger');

