import 'package:cloud_firestore/cloud_firestore.dart';

class FeedExpense {
  final String id;
  final String userId;
  final DateTime date;
  final String batchId;
  final String feedType;
  final String birdType;
  final String supplier;
  final double qtyKg;
  final double totalCost;
  final double unitCost;
  final DateTime createdAt;

  FeedExpense({
    required this.id,
    required this.userId,
    required this.date,
    required this.batchId,
    required this.feedType,
    required this.birdType,
    required this.supplier,
    required this.qtyKg,
    required this.totalCost,
    required this.unitCost,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'date': Timestamp.fromDate(date),
    'batchId': batchId,
    'feedType': feedType,
    'birdType': birdType,
    'supplier': supplier,
    'qtyKg': qtyKg,
    'totalCost': totalCost,
    'unitCost': unitCost,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory FeedExpense.fromMap(String id, Map<String, dynamic> map) => FeedExpense(
    id: id,
    userId: map['userId'] as String,
    date: (map['date'] as Timestamp).toDate(),
    batchId: map['batchId'] as String,
    feedType: map['feedType'] as String,
    birdType: map['birdType'] as String,
    supplier: map['supplier'] as String,
    qtyKg: (map['qtyKg'] as num).toDouble(),
    totalCost: (map['totalCost'] as num).toDouble(),
    unitCost: (map['unitCost'] as num).toDouble(),
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );
}
