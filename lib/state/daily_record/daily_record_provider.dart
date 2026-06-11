import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/daily_record_model.dart';
import '../../data/repositories/daily_record_repository.dart';

class DailyRecordProvider extends ChangeNotifier {
  final DailyRecordRepository _repo;

  DailyRecordProvider({DailyRecordRepository? repo})
      : _repo = repo ?? DailyRecordRepository() {
    loadAll();
  }

  List<DailyRecord> _records = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _recordsSub;

  List<DailyRecord> get records => _records;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<DailyRecord> recordsByModule(String module) =>
      _records.where((r) => r.module == module).toList();

  List<DailyRecord> get pendingRecords =>
      _records.where((r) => r.status == 'pending').toList();

  List<DailyRecord> pendingByModule(String module) =>
      _records.where((r) => r.module == module && r.status == 'pending').toList();

  int pendingCount(String module) =>
      _records.where((r) => r.module == module && r.status == 'pending').length;

  int get totalPending => _records.where((r) => r.status == 'pending').length;

  Map<String, int> get pendingByModuleMap {
    final map = <String, int>{};
    for (final r in _records.where((r) => r.status == 'pending')) {
      map[r.module] = (map[r.module] ?? 0) + 1;
    }
    return map;
  }

  void loadAll() {
    _isLoading = true;
    notifyListeners();
    _recordsSub?.cancel();
    _recordsSub = _repo.streamRecords().listen(
      (records) {
        _records = records;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void loadByModule(String module) {
    _isLoading = true;
    notifyListeners();
    _recordsSub?.cancel();
    _recordsSub = _repo.streamRecords(module: module).listen(
      (records) {
        _records = records;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> addRecord(Map<String, dynamic> data) async {
    try {
      await _repo.addRecordFromMap(data);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateRecordStatus(String id, String status, {String? rejectionReason, String? approvedBy}) async {
    try {
      await _repo.updateRecordStatus(id, status, rejectionReason: rejectionReason, approvedBy: approvedBy);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteRecord(String id) async {
    try {
      await _repo.deleteRecord(id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _recordsSub?.cancel();
    super.dispose();
  }
}
