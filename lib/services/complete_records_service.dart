mport '../data/models/daily_record_model.dart';
import '../data/repositories/complete_records_repository.dart';

/// Service Layer for Complete Records Management
/// Orchestrates business logic for all modules
class CompleteRecordsService {
  final CompleteRecordsRepository _repository;

  CompleteRecordsService({CompleteRecordsRepository? repository})
    : _repository = repository ?? CompleteRecordsRepository();

  // ────────────────────────────────────────────────────────────────────────
  // SUBMIT (Worker Action)
  // ────────────────────────────────────────────────────────────────────────

  /// Worker submits a record
  Future<String> submitRecord({
    required String module,
    required String subType,
    required String sheetType,
    required String unitId,
    required Map<String, dynamic> data,
    required String workerId,
    String? recordedByName,
  }) async {
    final now = DateTime.now();
    final record = DailyRecord(
      id: '',
      module: module,
      subType: subType,
      sheetType: sheetType,
      unitId: unitId,
      date: now,
      data: data,
      recordedBy: workerId,
      recordedByName: recordedByName,
      status: 'pending',
      createdAt: now,
      updatedAt: now,
    );

    return await _repository.addRecord(record);
  }

  // ────────────────────────────────────────────────────────────────────────
  // APPROVAL (Manager Actions)
  // ────────────────────────────────────────────────────────────────────────

  /// Manager approves a record
  Future<void> approveRecord(String recordId, String managerId) async {
    await _repository.approveRecord(recordId, managerId);
  }

  /// Manager rejects a record with reason
  Future<void> rejectRecord(
    String recordId,
    String managerId,
    String reason,
  ) async {
    await _repository.rejectRecord(recordId, managerId, reason);
  }

  // ────────────────────────────────────────────────────────────────────────
  // EDIT (Worker Action - 24h window)
  // ────────────────────────────────────────────────────────────────────────

  /// Worker edits their own pending record (within 24h)
  Future<void> editRecord(String recordId, Map<String, dynamic> updates) async {
    // Remove sensitive fields
    updates.remove('status');
    updates.remove('approvedBy');
    updates.remove('rejectionReason');
    updates.remove('recordedBy');
    updates.remove('createdAt');

    await _repository.updateRecord(recordId, updates);
  }

  // ────────────────────────────────────────────────────────────────────────
  // FETCH (Read Operations)
  // ────────────────────────────────────────────────────────────────────────

  /// Get pending records for manager approval
  Stream<List<DailyRecord>> getPendingRecords({String? module}) {
    return _repository.streamPendingRecords(module: module);
  }

  /// Get all records for a module
  Stream<List<DailyRecord>> getModuleRecords(
    String module, {
    String? subType,
    String? sheetType,
  }) {
    return _repository.streamByModule(
      module,
      subType: subType,
      sheetType: sheetType,
    );
  }

  /// Get records for a specific unit
  Stream<List<DailyRecord>> getUnitRecords(String unitId) {
    return _repository.streamByUnit(unitId);
  }

  /// Get worker's all records
  Stream<List<DailyRecord>> getWorkerRecords(String workerId) {
    return _repository.streamWorkerRecords(workerId);
  }

  /// Get single record
  Future<DailyRecord?> getRecord(String recordId) {
    return _repository.getRecord(recordId);
  }

  /// Get records with filters
  Future<List<DailyRecord>> getFilteredRecords({
    String? module,
    String? subType,
    String? sheetType,
    String? unitId,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 100,
  }) {
    return _repository.getRecords(
      module: module,
      subType: subType,
      sheetType: sheetType,
      unitId: unitId,
      status: status,
      fromDate: fromDate,
      toDate: toDate,
      limit: limit,
    );
  }

  // ────────────────────────────────────────────────────────────────────────
  // ANALYTICS
  // ────────────────────────────────────────────────────────────────────────

  /// Get pending count per module (for manager dashboard badges)
  Future<Map<String, int>> getPendingCountByModule() {
    return _repository.getPendingCountByModule();
  }

  /// Get full stats for a module
  Future<Map<String, dynamic>> getModuleStats(String module) {
    return _repository.getModuleStats(module);
  }

  // ────────────────────────────────────────────────────────────────────────
  // DELETE (Admin Action)
  // ────────────────────────────────────────────────────────────────────────

  /// Delete a record (admin/super-admin only)
  Future<void> deleteRecord(String recordId) {
    return _repository.deleteRecord(recordId);
  }
}
