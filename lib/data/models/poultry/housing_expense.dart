import 'package:cloud_firestore/cloud_firestore.dart';

class HousingExpense {
  final String id;
  final String userId;
  final DateTime date;
  final String birdType;
  final String category;
  final String description;
  final String? referenceNo;
  final double amount;
  final double? cumulative;
  final DateTime createdAt;

  HousingExpense({
    required this.id,
    required this.userId,
    required this.date,
    required this.birdType,
    required this.category,
    required this.description,
    this.referenceNo,
    required this.amount,
    this.cumulative,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'date': Timestamp.fromDate(date),
    'birdType': birdType,
    'category': category,
    'description': description,
    'referenceNo': referenceNo,
    'amount': amount,
    'cumulative': cumulative,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory HousingExpense.fromMap(String id, Map<String, dynamic> map) => HousingExpense(
    id: id,
    userId: map['userId'] as String,
    date: (map['date'] as Timestamp).toDate(),
    birdType: map['birdType'] as String,
    category: map['category'] as String,
    description: map['description'] as String,
    referenceNo: map['referenceNo'] as String?,
    amount: (map['amount'] as num).toDouble(),
    cumulative: (map['cumulative'] as num?)?.toDouble(),
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );
}
