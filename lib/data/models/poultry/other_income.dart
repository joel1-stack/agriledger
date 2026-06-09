import 'package:cloud_firestore/cloud_firestore.dart';

class OtherIncome {
  final String id;
  final String userId;
  final DateTime date;
  final String category;
  final String description;
  final double quantity;
  final double unitPrice;
  final double total;
  final DateTime createdAt;

  OtherIncome({
    required this.id,
    required this.userId,
    required this.date,
    required this.category,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'date': Timestamp.fromDate(date),
    'category': category,
    'description': description,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'total': total,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory OtherIncome.fromMap(String id, Map<String, dynamic> map) => OtherIncome(
    id: id,
    userId: map['userId'] as String,
    date: (map['date'] as Timestamp).toDate(),
    category: map['category'] as String,
    description: map['description'] as String,
    quantity: (map['quantity'] as num).toDouble(),
    unitPrice: (map['unitPrice'] as num).toDouble(),
    total: (map['total'] as num).toDouble(),
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );
}
