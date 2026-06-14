# AgriLedger — Farm Business Accounting

A Flutter-based farm management system with 10 modules across Operations, Finance, and Assets, supporting three user roles with offline-first sync, PDF reporting, and real-time Firestore backend.

---

## User Roles

### 1. Super Admin
Full system access:
- Manage users (add/edit roles, max 2 super admins enforced)
- Approve/reject any record (no KES 15,000 threshold)
- Delete any record, edit any record anytime
- View Reports & Analytics (charts, PDF export, print, share)
- Access Settings (farm name, currency, feed costs, alerts)
- Access all 10 module sheets, notifications, approval queue

### 2. View Admin
View and approve records:
- Approve/reject pending records (limited to KES 15,000 max; higher values require Super Admin)
- View all module sheets (read-only for records, can add)
- Export PDF reports
- Cannot manage users, delete records, or access Settings

### 3. General User (Worker)
Record farm data:
- Add records to any module sheet
- View own records in history
- Edit own records within 24h while status is "pending"
- Cannot approve/reject or delete records

---

## The 10 Modules

| Module | Sub-types | Sheets |
|---|---|---|
| **Poultry** | layers, broilers, kienyeji | feed, mortality, eggs, weight, vet, sales |
| **Dairy** | cows | milk, feed, vet, breeding, sales |
| **Crops** | maize, beans, vegetables | planting, fertilizer, pest_control, harvest, sales |
| **Livestock** | goats, sheep, pigs | feed, health, breeding, weight, sales |
| **Cashbook** | income, expense | daily_entries, bank_reconciliation |
| **Inventory** | general | stock_card, movements, reorder |
| **Journal** | general_ledger, adjustments | debits, credits, balances |
| **Property** | rental, commercial | rent, maintenance, expenses |
| **Transport** | trucks, boda, tractor | trips, fuel, maintenance, expenses |
| **Contracts** | projects | milestones, payments, progress |

---

## Navigation

### Bottom Nav (MainShell)
| Tab | Admin | Worker |
|---|---|---|
| Home | DashboardScreen (video header, quick stats, module grid) | WorkerDashboard (own stats, quick actions) |
| Modules | ModuleSelectorScreen (10-module grid) | ModuleSelectorScreen |
| Approvals | ApprovalQueueScreen (approve/reject with filters) | WorkerDashboard (history) |
| Profile | ProfileScreen (info, change password, sign out) | ProfileScreen |

### Drawer (PoultryDrawer)
- **Dashboard** — return to main shell
- **Operations** — Poultry, Dairy, Crops, Livestock
- **Finance** — Cashbook, Inventory, Journal
- **Assets** — Property, Transport, Contracts
- **Management** (admin) — Approvals, Users (super admin only)
- **Reports** (super admin) — Reports, Settings
- **Worker** (general) — My Dashboard, My History

### Routes
| Route | Screen | Access |
|---|---|---|
| `/` | SplashScreen | Public |
| `/login` | LoginScreen | Public |
| `/register` | RegisterScreen | Public |
| `/dashboard` | MainShell (4-tab bottom nav) | Authenticated |
| `/admin/dashboard` | AdminDashboard | Admin/SuperAdmin |
| `/admin/users` | UserManagementScreen | SuperAdmin |
| `/admin/reports` | ReportsScreen | SuperAdmin |
| `/manager/approvals` | ApprovalQueueScreen | Admin/SuperAdmin |
| `/worker/dashboard` | WorkerDashboard | General |
| `/worker/history` | HistoryScreen | General |
| `/notifications` | NotificationScreen | All |
| `/profile` | ProfileScreen | All |
| `/settings` | SettingsScreen | SuperAdmin |
| `/sheets` | SheetScreen (dynamic per module/sub-type) | All |
| `/modules` | ModuleSelectorScreen | All |

---

## Auto-Calculation (Add Record Form)

The add record form automatically computes derived fields:

| Pattern | Example | Formula |
|---|---|---|
| Qty × Price = Total | Feed, Sales, Labour | `qty * price` |
| Litres × Price/L = Total | Fuel | `litres * price_per_litre` |
| Morning + Evening = Total | Milk | `morning + evening` |
| Income − Expenses = Profit | Trips | `income - expenses` |
| Total Debit − Total Credit = Difference | Balances | `total_debit - total_credit` |
| Bank Balance − Book Balance = Difference | Bank Rec | `bank - book` |
| In − Out = Balance | Stock Card | `in - out` |
| Total ÷ 30 = Trays | Eggs | `total / 30` |
| (Total ÷ Flock) × 100 = % Prod | Eggs | `(total / flock) * 100` |
| Unit Cost × Balance = Total Value | Inventory | `unit_cost * balance` |

---

## Architecture

### Stack
- **Framework:** Flutter (Dart)
- **Backend:** Firebase Auth + Cloud Firestore
- **State Management:** Provider (ChangeNotifier)
- **Offline:** SQLite via sqflite (sync queue), Firestore persistence enabled
- **Charts:** fl_chart (bar, line, pie)
- **PDF:** pdf + printing packages
- **Connectivity:** connectivity_plus

### Data Flow
```
User fills form → AddRecordSheet → DailyRecordProvider
                                     ↓
                              DailyRecordRepository
                                     ↓
                          ┌──────────┴──────────┐
                          ↓                      ↓
                     Firestore               SQLite queue
                  (real-time sync)         (offline fallback)
                          ↓                      ↓
                  DailyRecordProvider ←── SyncService
                  (ChangeNotifier)       (auto-syncs when online)
                          ↓
                    All widgets via Provider
```

### Key Files
| File | Purpose |
|---|---|
| `lib/main.dart` | App entry, routes, Firebase init |
| `lib/core/constants/module_config.dart` | Module & sheet column definitions |
| `lib/data/models/user_model.dart` | User roles & permissions |
| `lib/data/models/daily_record_model.dart` | Record model with flatMap |
| `lib/state/auth/auth_provider.dart` | Auth state & user provider |
| `lib/state/daily_record/daily_record_provider.dart` | Records CRUD & stream |
| `lib/presentation/shell/main_shell.dart` | Bottom nav shell |
| `lib/presentation/poultry/widgets/poultry_drawer.dart` | Side drawer navigation |
| `lib/presentation/sheets/sheet_screen.dart` | Dynamic module sheet view |
| `lib/presentation/poultry/screens/add_record_sheet.dart` | Add record form with auto-calc |
| `lib/presentation/admin/reports_screen.dart` | Analytics dashboard with charts |
| `lib/presentation/approvals/approval_queue_screen.dart` | Approve/reject records |
| `lib/services/sync_service.dart` | Offline sync to Firestore |

### Firebase Collections
- `users/{uid}` — user profiles with role, name, email
- `daily_records/{id}` — all farm records with module, sheet, status, data

---

## Building

```bash
# Debug APK
flutter build apk --debug

# Release APK (minified, split by architecture)
flutter build apk --release --split-per-abi

# Outputs in build/app/outputs/flutter-apk/
#   app-armeabi-v7a-release.apk   (~28 MB)
#   app-arm64-v8a-release.apk      (~30 MB)
#   app-x86_64-release.apk         (~31 MB)
```
