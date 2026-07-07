import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daily_record_model.dart';

class DailyRecordRepository {
  final FirebaseFirestore _db;

  DailyRecordRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _records => _db.collection('daily_records');

  // Legacy collection names that need to be migrated to daily_records
  static const List<String> _legacyCollections = [
    'poultryLayers',
    'feed_expenses',
    'vet_health',
    'crops',
    'dairy',
    'livestock',
    'poultry_sales',
    'transactions',
    'egg_production',
    'flock_batches',
  ];

  // Map legacy collection names to module/sheetType
  static Map<String, Map<String, String>> _legacyCollectionMap = {
    'poultryLayers': {'module': 'poultry', 'sheetType': 'flock_register'},
    'feed_expenses': {'module': 'poultry', 'sheetType': 'feed'},
    'vet_health': {'module': 'poultry', 'sheetType': 'vet'},
    'crops': {'module': 'crops', 'sheetType': 'general'},
    'dairy': {'module': 'dairy', 'sheetType': 'general'},
    'livestock': {'module': 'livestock', 'sheetType': 'general'},
    'poultry_sales': {'module': 'poultry', 'sheetType': 'sales'},
    'transactions': {'module': 'cashbook', 'sheetType': 'daily_entries'},
    'egg_production': {'module': 'poultry', 'sheetType': 'eggs'},
    'flock_batches': {'module': 'poultry', 'sheetType': 'batch'},
  };

  // Convert legacy document to DailyRecord
  DailyRecord _fromLegacyDoc(String id, Map<String, dynamic> data, String collectionName) {
    final mapping = _legacyCollectionMap[collectionName] ?? {'module': 'unknown', 'sheetType': collectionName};
    final recordData = Map<String, dynamic>.from(data);
    recordData.remove('id');
    
    // Parse date - handle both String and Timestamp, or use today if missing
    DateTime parsedDate = DateTime.now();
    if (recordData.containsKey('date')) {
      if (recordData['date'] is String) {
        final dateStr = recordData['date'] as String;
        parsedDate = DateTime.tryParse(dateStr) ?? DateTime.now();
      } else if (recordData['date'] is Timestamp) {
        parsedDate = (recordData['date'] as Timestamp).toDate();
      }
    }
    
    // Handle approval field mapping to status
    String finalStatus = recordData['status'] as String? ?? 'pending';
    if (recordData.containsKey('approval') && finalStatus == 'pending') {
      finalStatus = recordData['approval'] as String? ?? 'pending';
    }
    
    return DailyRecord(
      id: id,
      module: mapping['module'] ?? 'unknown',
      subType: '',
      sheetType: mapping['sheetType'] ?? collectionName,
      date: parsedDate,
      data: recordData,
      status: finalStatus,
      recordedBy: recordData['recordedBy'] as String? ?? recordData['userId'] as String? ?? '',
      recordedByName: recordData['recordedByName'] as String? ?? '',
      unitId: '',
      approvedBy: recordData['approvedBy'] as String? ?? '',
      rejectionReason: recordData['rejectionReason'] as String? ?? '',
      createdAt: recordData['createdAt'] as dynamic,
      updatedAt: recordData['updatedAt'] as dynamic,
    );
  }

  // Get legacy records as a stream
  Stream<List<DailyRecord>> _streamLegacyRecords({String? module, String? sheetType, String? recordedBy, String? status}) async* {
    final allLegacyRecords = await Future.wait(_legacyCollections.map((collection) async {
      final colRef = _db.collection(collection);
      Query query = colRef;
      
      // Try ordering by date if it exists, otherwise no ordering
      try {
        query = query.orderBy('date', descending: true);
      } catch (e) {
        // date field might not exist in this collection
      }
      
      // Filter by module if specified
      if (module != null) {
        final mapping = _legacyCollectionMap[collection];
        if (mapping != null && mapping['module'] != module) {
          return <DailyRecord>[];
        }
      }
      
      // Filter by sheetType if specified
      if (sheetType != null) {
        final mapping = _legacyCollectionMap[collection];
        if (mapping != null && mapping['sheetType'] != sheetType) {
          return <DailyRecord>[];
        }
      }
      
      if (recordedBy != null) {
        try {
          query = query.where('recordedBy', isEqualTo: recordedBy);
        } catch (e) {
          // recordedBy might not exist, try userId
          try {
            query = query.where('userId', isEqualTo: recordedBy);
          } catch (e) {
            // Neither field exists
          }
        }
      }
      if (status != null) {
        try {
          query = query.where('status', isEqualTo: status);
        } catch (e) {
          // status field might not exist
        }
      }
      
      final snap = await query.get();
      return snap.docs.map((d) => _fromLegacyDoc(d.id, d.data() as Map<String, dynamic>, collection)).toList();
    }));
    
    yield allLegacyRecords.expand((x) => x).toList();
  }

  // Stream records from both daily_records and legacy collections
  Stream<List<DailyRecord>> streamRecords({String? module, String? sheetType, String? unitId, String? recordedBy, String? status}) {
    Query query = _records.orderBy('date', descending: true);
    if (module != null) query = query.where('module', isEqualTo: module);
    if (sheetType != null) query = query.where('sheetType', isEqualTo: sheetType);
    if (unitId != null) query = query.where('unitId', isEqualTo: unitId);
    if (recordedBy != null) query = query.where('recordedBy', isEqualTo: recordedBy);
    if (status != null) query = query.where('status', isEqualTo: status);
    
    final mainStream = query.snapshots().map((snap) => 
      snap.docs.map((d) => DailyRecord.fromMap(d.id, d.data() as Map<String, dynamic>)).toList()
    );
    
    final legacyStream = _streamLegacyRecords(
      module: module,
      sheetType: sheetType,
      recordedBy: recordedBy,
      status: status,
    );
    
    // Combine both streams using async*
    return Stream.fromFuture(Future.wait([
      mainStream.first,
      legacyStream.first,
    ])).asyncMap((results) {
      final mainRecords = results[0] as List<DailyRecord>;
      final legacyRecords = results[1] as List<DailyRecord>;
      return [...mainRecords, ...legacyRecords];
    });
  }

  Stream<List<DailyRecord>> streamPending(String? module) {
    Query query = _records.where('status', isEqualTo: 'pending').orderBy('createdAt', descending: true);
    if (module != null) query = query.where('module', isEqualTo: module);
    final mainStream = query.snapshots().map((snap) => 
      snap.docs.map((d) => DailyRecord.fromMap(d.id, d.data() as Map<String, dynamic>)).toList()
    );
    
    final legacyStream = _streamLegacyRecords(
      module: module,
      status: 'pending',
    );
    
    return Stream.fromFuture(Future.wait([
      mainStream.first,
      legacyStream.first,
    ])).asyncMap((results) {
      final mainRecords = results[0] as List<DailyRecord>;
      final legacyRecords = results[1] as List<DailyRecord>;
      return [...mainRecords, ...legacyRecords];
    });
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
    final mainRecords = snap.docs.map((d) => DailyRecord.fromMap(d.id, d.data() as Map<String, dynamic>)).toList();

    final legacyRecords = await Future.wait(_legacyCollections.map((collection) async {
      final colSnap = await _db.collection(collection).orderBy('date', descending: true).get();
      return colSnap.docs.map((d) => _fromLegacyDoc(d.id, d.data() as Map<String, dynamic>, collection)).toList();
    }));

    return [...mainRecords, ...legacyRecords.expand((x) => x)];
  }
}
