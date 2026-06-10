import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daily_record_model.dart';

class DailyRecordRepository {
  final FirebaseFirestore _db;

  DailyRecordRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _records => _db.collection('daily_records');

  Stream<List<DailyRecord>> streamRecords({String? module, String? sheetType, String? unitId, String? recordedBy, String? status}) {
    Query query = _records.orderBy('date', descending: true);
    if (module != null) query = query.where('module', isEqualTo: module);
    if (sheetType != null) query = query.where('sheetType', isEqualTo: sheetType);
    if (unitId != null) query = query.where('unitId', isEqualTo: unitId);
    if (recordedBy != null) query = query.where('recordedBy', isEqualTo: recordedBy);
    if (status != null) query = query.where('status', isEqualTo: status);
    return query.snapshots().map((snap) => snap.docs.map((d) => DailyRecord.fromMap(d.id, d.data() as Map<String, dynamic>)).toList());
  }

  Stream<List<DailyRecord>> streamPending(String? module) {
    Query query = _records.where('status', isEqualTo: 'pending').orderBy('createdAt', descending: true);
    if (module != null) query = query.where('module', isEqualTo: module);
    return query.snapshots().map((snap) => snap.docs.map((d) => DailyRecord.fromMap(d.id, d.data() as Map<String, dynamic>)).toList());
  }

  Future<void> addRecord(DailyRecord record) async {
    final ref = _records.doc(record.id);
    final firestoreData = record.toMap();
    firestoreData['createdAt'] = FieldValue.serverTimestamp();
    firestoreData['updatedAt'] = FieldValue.serverTimestamp();
    await ref.set(firestoreData);
  }

  Future<void> addRecordFromMap(Map<String, dynamic> data) async {
    final ref = _records.doc();
    data['id'] = ref.id;
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await ref.set(data);
  }

  Future<void> updateRecordStatus(String id, String status, {String? rejectionReason, String? approvedBy}) async {
    final update = <String, dynamic>{
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (rejectionReason != null) update['rejectionReason'] = rejectionReason;
    if (approvedBy != null) update['approvedBy'] = approvedBy;
    await _records.doc(id).update(update);
  }

  Future<void> deleteRecord(String id) async {
    await _records.doc(id).delete();
  }

  Future<List<DailyRecord>> getAllRecords() async {
    final snap = await _records.orderBy('date', descending: true).get();
    return snap.docs.map((d) => DailyRecord.fromMap(d.id, d.data() as Map<String, dynamic>)).toList();
  }
}
