import 'package:cloud_firestore/cloud_firestore.dart';

class PoultrySale {
  final String id;
  final String userId;
  final DateTime date;
  final String batchId;
  final String saleType;
  final String birdType;
  final double quantity;
  final double unitPrice;
  final String buyer;
  final double totalRevenue;
  final String paymentStatus;
  final DateTime? dateReceived;
  final DateTime createdAt;

  PoultrySale({
    required this.id,
    required this.userId,
    required this.date,
    required this.batchId,
    required this.saleType,
    required this.birdType,
    required this.quantity,
    required this.unitPrice,
    required this.buyer,
    required this.totalRevenue,
    required this.paymentStatus,
    this.dateReceived,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'date': Timestamp.fromDate(date),
    'batchId': batchId,
    'saleType': saleType,
    'birdType': birdType,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'buyer': buyer,
    'totalRevenue': totalRevenue,
    'paymentStatus': paymentStatus,
    'dateReceived': dateReceived != null ? Timestamp.fromDate(dateReceived!) : null,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory PoultrySale.fromMap(String id, Map<String, dynamic> map) => PoultrySale(
    id: id,
    userId: map['userId'] as String,
    date: (map['date'] as Timestamp).toDate(),
    batchId: map['batchId'] as String,
    saleType: map['saleType'] as String,
    birdType: map['birdType'] as String,
    quantity: (map['quantity'] as num).toDouble(),
    unitPrice: (map['unitPrice'] as num).toDouble(),
    buyer: map['buyer'] as String,
    totalRevenue: (map['totalRevenue'] as num).toDouble(),
    paymentStatus: map['paymentStatus'] as String,
    dateReceived: map['dateReceived'] != null ? (map['dateReceived'] as Timestamp).toDate() : null,
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );
}
