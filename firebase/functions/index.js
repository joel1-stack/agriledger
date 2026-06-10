const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

// Trigger 1: Worker submits record -> Notify Manager
exports.onDailyRecordCreate = functions.firestore
  .document('daily_records/{docId}')
  .onCreate(async (snap, context) => {
    const data = snap.data();
    if (!data) return;
    const unitId = data.unitId;
    if (!unitId) return;

    const unitDoc = await db.collection('units').doc(unitId).get();
    if (!unitDoc.exists) return;

    const managerId = unitDoc.data().managerId;
    if (!managerId) return;

    const managerDoc = await db.collection('users').doc(managerId).get();
    if (!managerDoc.exists) return;

    const fcmToken = managerDoc.data().fcmToken;
    const moduleName = (data.module || '').toUpperCase();
    const sheetName = (data.sheetType || '').toUpperCase();

    // send FCM only if token exists (do not return early)
    if (fcmToken) {
      const message = {
        token: fcmToken,
        notification: {
          title: `New ${moduleName} Record Pending`,
          body: `${data.recordedByName || 'Worker'} submitted ${sheetName} for ${unitId}`,
        },
        data: {
          click_action: 'OPEN_APPROVAL_QUEUE',
          record_id: context.params.docId,
          module: data.module || '',
          unit_id: unitId,
        },
      };
      try {
        await messaging.send(message);
      } catch (e) {
        console.error('FCM send error:', e);
      }
    }

    // In-app notification (always create)
    await db.collection('notifications').add({
      userId: managerId,
      title: `New ${moduleName} Record`,
      body: `${sheetName} — ${data.subType || ''} — ${unitId}`,
      type: 'approval',
      module: data.module || '',
      read: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    }).catch(e => console.error('Notification write error:', e));
  });

// Trigger 2: Manager approves/rejects -> Notify Worker
exports.onDailyRecordUpdate = functions.firestore
  .document('daily_records/{docId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    if (before.status === after.status) return;

    const workerId = after.recordedBy;
    const workerDoc = await db.collection('users').doc(workerId).get();
    if (!workerDoc.exists) return;

    const fcmToken = workerDoc.data().fcmToken;
    const isApproved = after.status === 'approved';
    const moduleName = (after.module || '').toUpperCase();

    if (fcmToken) {
      const message = {
        token: fcmToken,
        notification: {
          title: `${moduleName} Record ${isApproved ? 'Approved' : 'Rejected'}`,
          body: isApproved
            ? `Your ${after.sheetType} entry was approved`
            : `Reason: ${after.rejectionReason || 'No reason given'}`,
        },
        data: {
          click_action: isApproved ? 'OPEN_MY_HISTORY' : 'OPEN_EDIT_RECORD',
          record_id: context.params.docId,
          module: after.module,
          status: after.status,
        },
      };
      try {
        await messaging.send(message);
      } catch (e) {
        console.error('FCM send error:', e);
      }
    }

    // In-app notification
    await db.collection('notifications').add({
      userId: workerId,
      title: `${moduleName} ${isApproved ? 'Approved' : 'Rejected'}`,
      body: isApproved
        ? `${after.sheetType} for ${after.subType || ''} approved`
        : `${after.sheetType} rejected: ${after.rejectionReason}`,
      type: isApproved ? 'approval' : 'rejection',
      module: after.module,
      read: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Audit log
    await db.collection('audit_logs').add({
      module: after.module,
      action: isApproved ? 'APPROVED' : 'REJECTED',
      docId: context.params.docId,
      collection: 'daily_records',
      sheetType: after.sheetType,
      subType: after.subType,
      performedBy: after.approvedBy,
      performerRole: 'manager',
      previousStatus: before.status,
      newStatus: after.status,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });
  });

// Trigger 3: Manager edits -> Audit log
exports.onDailyRecordEdit = functions.firestore
  .document('daily_records/{docId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    if (before.status !== after.status) return;

    const editor = after.updatedBy || after.approvedBy;
    if (!editor) return;

    const editorDoc = await db.collection('users').doc(editor).get();
    if (!editorDoc.exists || editorDoc.data().role === 'general') return;

    await db.collection('audit_logs').add({
      module: after.module,
      action: 'EDITED',
      docId: context.params.docId,
      collection: 'daily_records',
      sheetType: after.sheetType,
      subType: after.subType,
      performedBy: editor,
      performerRole: editorDoc.data().role,
      previousData: before.data,
      newData: after.data,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });
  });

// Trigger 4: Manager deletes -> Audit log + notify SuperAdmin
exports.onDailyRecordDelete = functions.firestore
  .document('daily_records/{docId}')
  .onDelete(async (snap, context) => {
    const data = snap.data();
    if (!data) return;

    await db.collection('audit_logs').add({
      module: data.module || '',
      action: 'DELETED',
      docId: context.params.docId,
      collection: 'daily_records',
      sheetType: data.sheetType || '',
      subType: data.subType || '',
      performedBy: data.deletedBy || 'unknown',
      performerRole: 'manager',
      previousData: data || {},
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    }).catch(e => console.error('Audit write error:', e));

    // Notify SuperAdmins (role key = 'superAdmin')
    const admins = await db.collection('users').where('role', '==', 'superAdmin').get();
    for (const admin of admins.docs) {
      const token = admin.data().fcmToken;
      if (token) {
        try {
          await messaging.send({
            token: token,
            notification: {
              title: `${(data.module || '').toUpperCase()} Record Deleted`,
              body: `Manager deleted ${data.sheetType || ''} record for ${data.unitId || ''}`,
            },
          });
        } catch (e) {
          console.error('FCM send error:', e);
        }
      }
    }
  });
