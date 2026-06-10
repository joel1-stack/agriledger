import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/daily_record_model.dart';

/// Unified Repository for all operational records across all modules
/// Handles CRUD operations on daily_records collection
class CompleteRecordsRepository {
  final FirebaseFirestore _db;

  CompleteRecordsRepository({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  // ────────────────────────────────────────────────────────────────────────
  // CREATE Operations
  // ────────────────────────────────────────────────────────────────────────

  /// Add new record to daily_records
  Future<String> addRecord(DailyRecord record) async {
    final docRef = await _db.collection('daily_records').add(record.toMap());
    return docRef.id;
  }

  // ────────────────────────────────────────────────────────────────────────
  // READ Operations
  // ────────────────────────────────────────────────────────────────────────

  /// Get single record by ID
  Future<DailyRecord?> getRecord(String recordId) async {
    final doc = await _db.collection('daily_records').doc(recordId).get();
    if (!doc.exists) return null;
    return DailyRecord.fromMap(doc.id, doc.data() ?? {});
  }

  /// Stream pending records (for manager approval queue)
  Stream<List<DailyRecord>> streamPendingRecords({String? module}) {
    Query query = _db
        .collection('daily_records')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true);

    if (module != null && module.isNotEmpty) {
      query = query.where('module', isEqualTo: module);
    }

    return query.snapshots().map(
      (snap) => snap.docs
          .map(
            (d) => DailyRecord.fromMap(d.id, d.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  /// Stream records by module
  Stream<List<DailyRecord>> streamByModule(
    String module, {
    String? subType,
    String? sheetType,
  }) {
    Query query = _db
        .collection('daily_records')
        .where('module', isEqualTo: module)
        .orderBy('date', descending: true);

    if (subType != null && subType.isNotEmpty) {
      query = query.where('subType', isEqualTo: subType);
    }
    if (sheetType != null && sheetType.isNotEmpty) {
      query = query.where('sheetType', isEqualTo: sheetType);
    }

    return query.snapshots().map(
      (snap) => snap.docs
          .map(
            (d) => DailyRecord.fromMap(d.id, d.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  /// Stream records by unit
  Stream<List<DailyRecord>> streamByUnit(String unitId) {
    return _db
        .collection('daily_records')
        .where('unitId', isEqualTo: unitId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) =>
                    DailyRecord.fromMap(d.id, d.data()!),
              )
              .toList(),
        );
  }

  /// Stream worker's records
  Stream<List<DailyRecord>> streamWorkerRecords(String workerId) {
    return _db
        .collection('daily_records')
        .where('recordedBy', isEqualTo: workerId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) =>
                    DailyRecord.fromMap(d.id, d.data()!),
              )
              .toList(),
        );
  }

  /// Get records with complex filters
  Future<List<DailyRecord>> getRecords({
    String? module,
    String? subType,
    String? sheetType,
    String? unitId,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 100,
  }) async {
    Query query = _db
        .collection('daily_records')
        .orderBy('date', descending: true);

    if (module != null && module.isNotEmpty) {
      query = query.where('module', isEqualTo: module);
    }
    if (subType != null && subType.isNotEmpty) {
      query = query.where('subType', isEqualTo: subType);
    }
    if (sheetType != null && sheetType.isNotEmpty) {
      query = query.where('sheetType', isEqualTo: sheetType);
    }
    if (unitId != null && unitId.isNotEmpty) {
      query = query.where('unitId', isEqualTo: unitId);
    }
    if (status != null && status.isNotEmpty) {
      query = query.where('status', isEqualTo: status);
    }

    query = query.limit(limit);
    final snap = await query.get();

    return snap.docs
        .map((d) => DailyRecord.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  // ────────────────────────────────────────────────────────────────────────
  // UPDATE Operations
  // ────────────────────────────────────────────────────────────────────────

  /// Update record (worker editing own record)
  Future<void> updateRecord(
    String recordId,
    Map<String, dynamic> updates,
  ) async {
    updates['updatedAt'] = Timestamp.now();
    await _db.collection('daily_records').doc(recordId).update(updates);
  }

  /// Approve record (manager action)
  Future<void> approveRecord(String recordId, String managerId) async {
    await _db.collection('daily_records').doc(recordId).update({
      'status': 'approved',
      'approvedBy': managerId,
      'updatedAt': Timestamp.now(),
    });
  }

  /// Reject record (manager action)
  Future<void> rejectRecord(
    String recordId,
    String managerId,
    String reason,
  ) async {
    await _db.collection('daily_records').doc(recordId).update({
      'status': 'rejected',
      'approvedBy': managerId,
      'rejectionReason': reason,
      'updatedAt': Timestamp.now(),
    });
  }

  // ────────────────────────────────────────────────────────────────────────
  // DELETE Operations
  // ────────────────────────────────────────────────────────────────────────

  /// Delete record (manager/super admin only)
  Future<void> deleteRecord(String recordId) async {
    await _db.collection('daily_records').doc(recordId).delete();
  }

  // ────────────────────────────────────────────────────────────────────────
  // ANALYTICS Operations
  // ────────────────────────────────────────────────────────────────────────

  /// Get count of pending records by module
  Future<Map<String, int>> getPendingCountByModule() async {
    final modules = [
      'poultry',
      'dairy',
      'crops',
      'livestock',
      'inventory',
      'cashbook',
      'property',
      'transport',
    ];
    final counts = <String, int>{};

    for (final module in modules) {
      final snap = await _db
          .collection('daily_records')
          .where('module', isEqualTo: module)
          .where('status', isEqualTo: 'pending')
          .count()
          .get();
      final int c = snap.count ?? 0;
      counts[module] = c;
    }

    return counts;
  }

  /// Get total records by module and status
  Future<Map<String, dynamic>> getModuleStats(String module) async {
    final pc = await _db
        .collection('daily_records')
        .where('module', isEqualTo: module)
        .where('status', isEqualTo: 'pending')
        .count()
        .get();
    final int pending = pc.count ?? 0;

    final ac = await _db
        .collection('daily_records')
        .where('module', isEqualTo: module)
        .where('status', isEqualTo: 'approved')
        .count()
        .get();
    final int approved = ac.count ?? 0;

    final rc = await _db
        .collection('daily_records')
        .where('module', isEqualTo: module)
        .where('status', isEqualTo: 'rejected')
        .count()
        .get();
    final int rejected = rc.count ?? 0;

    return <String, dynamic>{
      'pending': pending,
      'approved': approved,
      'rejected': rejected,
      'total': pending + approved + rejected,
    };
  }
}
