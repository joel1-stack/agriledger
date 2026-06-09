import 'package:cloud_firestore/cloud_firestore.dart';

class LabourRecord {
  final String id;
  final String userId;
  final String month;
  final String employeeName;
  final String role;
  final int daysWorked;
  final double dailyRate;
  final double grossPay;
  final double deductions;
  final double netPay;
  final DateTime createdAt;

  LabourRecord({
    required this.id,
    required this.userId,
    required this.month,
    required this.employeeName,
    required this.role,
    required this.daysWorked,
    required this.dailyRate,
    required this.grossPay,
    this.deductions = 0,
    required this.netPay,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'month': month,
    'employeeName': employeeName,
    'role': role,
    'daysWorked': daysWorked,
    'dailyRate': dailyRate,
    'grossPay': grossPay,
    'deductions': deductions,
    'netPay': netPay,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory LabourRecord.fromMap(String id, Map<String, dynamic> map) => LabourRecord(
    id: id,
    userId: map['userId'] as String,
    month: map['month'] as String,
    employeeName: map['employeeName'] as String,
    role: map['role'] as String,
    daysWorked: map['daysWorked'] as int,
    dailyRate: (map['dailyRate'] as num).toDouble(),
    grossPay: (map['grossPay'] as num).toDouble(),
    deductions: (map['deductions'] as num?)?.toDouble() ?? 0,
    netPay: (map['netPay'] as num).toDouble(),
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );
}
