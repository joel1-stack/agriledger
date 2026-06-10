import 'package:cloud_firestore/cloud_firestore.dart';

class DailyRecord {
  final String id;
  final String module;
  final String subType;
  final String sheetType;
  final String unitId;
  final DateTime date; // changed to DateTime
  final Map<String, dynamic> data;
  final String recordedBy;
  final String? recordedByName;
  final String? approvedBy;
  final String status;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  DailyRecord({
    required this.id,
    required this.module,
    required this.subType,
    required this.sheetType,
    required this.unitId,
    required this.date,
    required this.data,
    required this.recordedBy,
    this.recordedByName,
    this.approvedBy,
    this.status = 'pending',
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'module': module,
    'subType': subType,
    'sheetType': sheetType,
    'unitId': unitId,
    'date': Timestamp.fromDate(date),
    'data': data,
    'recordedBy': recordedBy,
    'recordedByName': recordedByName,
    'approvedBy': approvedBy,
    'status': status,
    'rejectionReason': rejectionReason,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory DailyRecord.fromMap(String id, Map<String, dynamic> m) => DailyRecord(
    id: id,
    module: m['module'] ?? 'poultry',
    subType: m['subType'] ?? '',
    sheetType: m['sheetType'] ?? '',
    unitId: m['unitId'] ?? '',
    date: _parseDateTime(m['date']),
    data: Map<String, dynamic>.from(m['data'] ?? {}),
    recordedBy: m['recordedBy'] ?? '',
    recordedByName: m['recordedByName'],
    approvedBy: m['approvedBy'],
    status: m['status'] ?? 'pending',
    rejectionReason: m['rejectionReason'],
    createdAt: _parseDateTime(m['createdAt']),
    updatedAt: _parseDateTime(m['updatedAt']),
  );

  Map<String, dynamic> toFlatMap() => {
    'id': id,
    'module': module,
    'subType': subType,
    'sheetType': sheetType,
    'unitId': unitId,
    'date': date.toIso8601String(),
    'recordedBy': recordedBy,
    'recordedByName': recordedByName,
    'approvedBy': approvedBy,
    'status': status,
    'rejectionReason': rejectionReason,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    ...data,
  };

  bool get isPending => status == 'pending';
  bool get isRejected => status == 'rejected';

  static DateTime _parseDateTime(dynamic dt) {
    if (dt == null) return DateTime.now();
    if (dt is DateTime) return dt;
    if (dt is Timestamp) return dt.toDate();
    if (dt is String) return DateTime.tryParse(dt) ?? DateTime.now();
    return DateTime.now();
  }
}
