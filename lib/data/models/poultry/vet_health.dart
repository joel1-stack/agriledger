import 'package:cloud_firestore/cloud_firestore.dart';

class VetHealth {
  final String id;
  final String userId;
  final DateTime date;
  final String batchId;
  final String birdType;
  final String treatment;
  final String vetSupplier;
  final double cost;
  final double? cumulative;
  final DateTime createdAt;

  VetHealth({
    required this.id,
    required this.userId,
    required this.date,
    required this.batchId,
    required this.birdType,
    required this.treatment,
    required this.vetSupplier,
    required this.cost,
    this.cumulative,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'date': Timestamp.fromDate(date),
    'batchId': batchId,
    'birdType': birdType,
    'treatment': treatment,
    'vetSupplier': vetSupplier,
    'cost': cost,
    'cumulative': cumulative,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory VetHealth.fromMap(String id, Map<String, dynamic> map) => VetHealth(
    id: id,
    userId: map['userId'] as String,
    date: (map['date'] as Timestamp).toDate(),
    batchId: map['batchId'] as String,
    birdType: map['birdType'] as String,
    treatment: map['treatment'] as String,
    vetSupplier: map['vetSupplier'] as String,
    cost: (map['cost'] as num).toDouble(),
    cumulative: (map['cumulative'] as num?)?.toDouble(),
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );
}
