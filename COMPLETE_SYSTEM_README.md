# Complete Agri-Ledger Unified Approval System

## 🏗️ Architecture Overview

This is a **complete role-based approval workflow** system for managing 9 different business modules with unified daily record entry and manager approval queue.

### ✅ What's Implemented

- ✅ **10 Complete Modules**: Poultry, Dairy, Crops, Livestock, Inventory, Cashbook, Property, Transport, Contracts, Reports
- ✅ **Unified Daily Records**: Single collection for all operational data with approval workflow
- ✅ **Role-Based Access**: 3 role levels (general/worker, viewAdmin/manager, superAdmin/owner)
- ✅ **Manager Approval Queue**: Single unified queue for all modules
- ✅ **Audit Trail**: Immutable logs of all approvals and changes
- ✅ **Notifications**: FCM push + in-app notifications for approvals/rejections
- ✅ **Excel-Like UI**: Dynamic spreadsheet views per module/sheet
- ✅ **Cloud Functions**: Automatic notifications and audit logging
- ✅ **Security Rules**: Comprehensive Firestore rules with approval logic

---

## 📁 Files Generated

### Core Files
```
lib/
├── core/constants/complete_module_config.dart    ← ALL module definitions (Poultry, Dairy, Crops, etc.)
├── data/models/daily_record_model.dart           ← Universal record model (already updated)
├── data/repositories/complete_records_repository.dart  ← CRUD layer
├── services/complete_records_service.dart        ← Business logic
└── presentation/screens/manager/complete_manager_dashboard.dart  ← Manager UI

functions/
└── index_complete.js                             ← Cloud Functions (4 triggers)

firestore_rules_complete.txt                      ← Complete security rules (copy to firestore.rules)
```

---

## 🚀 Deployment Instructions

### Step 1: Update Firestore Rules

```bash
# Copy firestore_rules_complete.txt content to firestore.rules
cp firestore_rules_complete.txt firestore.rules

# Deploy rules
firebase deploy --only firestore:rules
```

### Step 2: Update Firestore Indexes

Add these indexes to `firestore.indexes.json`:

```json
{
  "indexes": [
    {
      "collectionGroup": "daily_records",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "daily_records",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "module", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "daily_records",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "module", "order": "ASCENDING" },
        { "fieldPath": "sheetType", "order": "ASCENDING" },
        { "fieldPath": "date", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "daily_records",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "unitId", "order": "ASCENDING" },
        { "fieldPath": "date", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "daily_records",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "recordedBy", "order": "ASCENDING" },
        { "fieldPath": "date", "order": "DESCENDING" }
      ]
    }
  ]
}
```

Deploy indexes:
```bash
firebase deploy --only firestore:indexes
```

### Step 3: Deploy Cloud Functions

```bash
cd functions

# Update index.js: Copy content from index_complete.js
cp ../index_complete.js index.js

# Install dependencies (if not already done)
npm install

# Deploy functions
firebase deploy --only functions
```

### Step 4: Update Flutter App

```bash
# Get new dependencies
flutter pub get

# Run app
flutter run
```

---

## 📊 Module Configuration

All modules and sheets are defined in `complete_module_config.dart`:

### Available Modules

| Module | Sub-Types | Sheets | Role |
|--------|-----------|--------|------|
| **Poultry** | Layers, Broilers, Kienyeji | Feed, Mortality, Eggs, Weight, Vet, Sales | Worker/Manager |
| **Dairy** | Cows | Milk, Feed, Vet, Breeding, Sales | Worker/Manager |
| **Crops** | Maize, Beans, Vegetables | Planting, Fertilizer, Pest, Harvest, Sales | Worker/Manager |
| **Livestock** | Goats, Sheep, Pigs | Feed, Health, Breeding, Weight, Sales | Worker/Manager |
| **Inventory** | General | Stock Card, Reorder | Manager |
| **Cashbook** | General | Journal, Bank Reconciliation | Manager |
| **Property** | Rental, Commercial | Rent, Maintenance, Expenses | Manager |
| **Transport** | Trucks, Boda, Tractor | Trips, Fuel, Maintenance | Manager/Worker |
| **Contracts** | Projects | Milestones, Payments, Progress | Manager |
| **Reports** | All Modules | Analytics, P&L, Balance Sheet | Super Admin |

---

## 🔐 Role Permissions

### Worker (general)
- ✅ Submit daily records
- ✅ Edit own records (24h window, pending only)
- ✅ View own history
- ✅ Receive approval/rejection notifications
- ❌ Approve/reject records
- ❌ View other workers' records
- ❌ Access financials

### Manager (viewAdmin)
- ✅ Review pending records (all modules)
- ✅ Approve/reject records
- ✅ Edit any record (with audit trail)
- ✅ Delete records
- ✅ Manage units/flocks
- ✅ View operational reports
- ✅ Access inventory & stock
- ❌ Access financial journal
- ❌ Create journal entries
- ❌ Manage users

### Super Admin (superAdmin)
- ✅ Full access to all data (read-only for daily records)
- ✅ View audit logs
- ✅ Create/manage users
- ✅ Create journal entries
- ✅ Access financial P&L
- ✅ Export reports
- ❌ Edit daily records (data integrity protection)
- ❌ Delete users

---

## 📱 UI Flow

### Worker App
1. **Home** → List of assigned units
2. **Add Record** → Select Module → Sub-Type → Sheet → Fill form → Submit
3. **History** → View own records + status
4. **Notifications** → Approval/rejection updates

### Manager App
1. **Approval Queue** → Tab by module → Pending records → Approve/Reject
2. **Units** → Manage flocks, cows, plots, etc.
3. **Sheets** → Excel-like views per module
4. **Reports** → Operational summaries

### Super Admin App
1. **Dashboard** → Stats per module
2. **Reports** → Financial, operational, audit
3. **Users** → Create/edit roles
4. **Settings** → Farm config, module access

---

## 🔔 Notifications

### FCM Push Notifications (if configured)
- Worker submits → Manager gets push: "New [Module] Record"
- Manager approves → Worker gets push: "✅ Record Approved"
- Manager rejects → Worker gets push: "❌ Record Rejected: [Reason]"
- Low stock → Manager gets push: "⚠️ Low Stock Alert"

### In-App Notifications (Firestore)
- Stored in `notifications` collection
- Accessible in app even without FCM
- Read/unread status tracking

---

## 🗄️ Firestore Collections

```
users/                          ← Existing, enhanced with moduleAccess
business_units/                 ← NEW: Farm/company profile
units/                          ← NEW: All physical units
daily_records/                  ← NEW: Unified for ALL modules
inventory/                      ← Existing, enhanced
stock_movements/                ← NEW: Inventory tracking
transactions/                   ← Existing: Cashbook entries
journal_entries/                ← NEW: Double-entry accounting
chart_of_accounts/              ← NEW: Account structure
audit_logs/                     ← NEW: Immutable audit trail
notifications/                  ← NEW: User notifications
```

---

## 🔄 Workflow Example: Poultry Feed Entry

```
1. WORKER (Farm)
   - Opens app → "Add Record"
   - Select: Module=Poultry, SubType=Layers, Sheet=Feed
   - Fill: Qty=50kg, FeedType=Grower, Cost/kg=3200
   - Submit → Saved as "pending"

2. CLOUD FUNCTION (Automatic)
   - Record created trigger fires
   - Reads unit → finds managerId
   - Sends FCM to manager
   - Creates in-app notification

3. MANAGER (Office)
   - Receives push notification
   - Opens app → "Approval Queue"
   - Sees new Poultry/Feed record
   - Reviews data → Clicks "Approve"

4. CLOUD FUNCTION (Automatic)
   - Status updated to "approved"
   - Sends FCM to worker
   - Creates in-app notification
   - Writes audit log

5. WORKER (Farm)
   - Receives notification: "✅ Record Approved"
   - Can view in history with ✅ badge

6. SUPER ADMIN (Analytics)
   - Views dashboard → "Poultry: 50kg Feed cost 160,000"
   - Can view all approvals in audit logs
   - Cannot edit the record (read-only integrity)
```

---

## 📊 Adding New Modules

To add a new module (e.g., "Fishery"):

1. **Update `complete_module_config.dart`**:
```dart
'fishery': {
  'name': 'Fishery',
  'icon': '🐟',
  'color': 0xFF06B6D4,
  'subTypes': ['tilapia', 'catfish'],
  'sheets': {
    'tilapia': {
      'feed': [
        {'key': 'date', 'label': 'Date', 'type': 'date', ...},
        // ... columns
      ],
      'growth': [...],
      'sales': [...],
    },
    // ...
  },
},
```

2. **Create units** in Firestore:
```
units/{unitId}
├── module: "fishery"
├── subType: "tilapia"
├── name: "Tank A"
├── assignedWorkers: ["uid_worker_1"]
└── managerId: "uid_manager"
```

3. **Create sample records** and test!

---

## ⚠️ Critical Rules

1. **Super Admin cannot edit daily records** - This prevents data tampering. All changes must go through manager approval workflow for audit compliance.

2. **Workers can only edit within 24h** - After this window closes, only managers can modify records.

3. **All changes are audited** - Every approval, rejection, edit, and delete is logged to `audit_logs` collection.

4. **Manager approval is required** - Worker records stay "pending" until manager approves. This ensures accountability.

5. **Role-based UI** - Buttons and screens are completely hidden for unauthorized roles (not just disabled).

---

## 🧪 Testing Checklist

- [ ] Worker logs in → Sees only assigned units
- [ ] Worker submits feed record → Status shows "pending"
- [ ] Manager logs in → Sees pending record in approval queue
- [ ] Manager approves → Worker gets notification, status = "approved"
- [ ] Manager rejects → Worker gets notification with reason
- [ ] Worker can edit within 24h → Re-submits → Back to pending
- [ ] Worker cannot edit after 24h → "Edit" button hidden
- [ ] Super Admin views dashboard → Sees all module stats (read-only)
- [ ] Super Admin tries to edit record → Security rules deny
- [ ] Audit log shows all actions → Immutable records
- [ ] Low stock alert triggers → Manager gets notification

---

## 🐛 Troubleshooting

### "Insufficient permissions" error when approving
- Check Firestore rules are deployed
- Verify manager has `viewAdmin` role
- Check `approvedBy` field is being set

### Worker cannot see assigned units
- Verify `units/{unitId}.assignedWorkers` contains worker's UID
- Check `moduleAccess` array on user document

### Notifications not received
- Verify FCM token is saved in `users/{uid}.fcmToken`
- Check Cloud Functions are deployed
- Test in Firebase console → Messaging

### Records not appearing in approval queue
- Check `status` field is exactly "pending"
- Verify indexes are created in Firestore
- Check date filters in queries

---

## 📞 Support

For issues or questions:
1. Check Firestore rules and indexes are deployed
2. Verify all files are in correct directories
3. Check Cloud Functions logs: `firebase functions:log`
4. Validate data structure matches models

---

**Your complete unified approval system is ready! 🎉**

All modules are now operating under one consistent workflow with manager approval, audit trails, and role-based access.

