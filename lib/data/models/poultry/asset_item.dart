import 'package:cloud_firestore/cloud_firestore.dart';

class AssetItem {
  final String id;
  final String userId;
  final String assetName;
  final DateTime datePurchased;
  final double purchaseCost;
  final int usefulLifeYears;
  final double annualDepreciation;
  final double currentBookValue;
  final String condition;
  final DateTime createdAt;
  final DateTime lastUpdated;

  AssetItem({
    required this.id,
    required this.userId,
    required this.assetName,
    required this.datePurchased,
    required this.purchaseCost,
    required this.usefulLifeYears,
    required this.annualDepreciation,
    required this.currentBookValue,
    required this.condition,
    required this.createdAt,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'assetName': assetName,
    'datePurchased': Timestamp.fromDate(datePurchased),
    'purchaseCost': purchaseCost,
    'usefulLifeYears': usefulLifeYears,
    'annualDepreciation': annualDepreciation,
    'currentBookValue': currentBookValue,
    'condition': condition,
    'createdAt': Timestamp.fromDate(createdAt),
    'lastUpdated': Timestamp.fromDate(lastUpdated),
  };

  factory AssetItem.fromMap(String id, Map<String, dynamic> map) => AssetItem(
    id: id,
    userId: map['userId'] as String,
    assetName: map['assetName'] as String,
    datePurchased: (map['datePurchased'] as Timestamp).toDate(),
    purchaseCost: (map['purchaseCost'] as num).toDouble(),
    usefulLifeYears: map['usefulLifeYears'] as int,
    annualDepreciation: (map['annualDepreciation'] as num).toDouble(),
    currentBookValue: (map['currentBookValue'] as num).toDouble(),
    condition: map['condition'] as String,
    createdAt: (map['createdAt'] as Timestamp).toDate(),
    lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
  );
}
