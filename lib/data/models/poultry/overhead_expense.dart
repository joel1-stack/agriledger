import 'package:cloud_firestore/cloud_firestore.dart';

class OverheadExpense {
  final String id;
  final String userId;
  final DateTime date;
  final String category;
  final String description;
  final String? referenceNo;
  final double amount;
  final double? cumulative;
  final DateTime createdAt;

  OverheadExpense({
    required this.id,
    required this.userId,
    required this.date,
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
    'category': category,
    'description': description,
    'referenceNo': referenceNo,
    'amount': amount,
    'cumulative': cumulative,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory OverheadExpense.fromMap(String id, Map<String, dynamic> map) => OverheadExpense(
    id: id,
    userId: map['userId'] as String,
    date: (map['date'] as Timestamp).toDate(),
    category: map['category'] as String,
    description: map['description'] as String,
    referenceNo: map['referenceNo'] as String?,
    amount: (map['amount'] as num).toDouble(),
    cumulative: (map['cumulative'] as num?)?.toDouble(),
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );
}
