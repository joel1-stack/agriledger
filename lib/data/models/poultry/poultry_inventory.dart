import 'package:cloud_firestore/cloud_firestore.dart';

class PoultryInventory {
  final String id;
  final String userId;
  final String itemName;
  final String unit;
  final double openingStock;
  final double purchased;
  final double used;
  final double closingStock;
  final double reorderLevel;
  final String status;
  final DateTime createdAt;
  final DateTime lastUpdated;

  bool get needsReorder => closingStock <= reorderLevel;

  PoultryInventory({
    required this.id,
    required this.userId,
    required this.itemName,
    required this.unit,
    required this.openingStock,
    required this.purchased,
    required this.used,
    required this.closingStock,
    required this.reorderLevel,
    required this.status,
    required this.createdAt,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'itemName': itemName,
    'unit': unit,
    'openingStock': openingStock,
    'purchased': purchased,
    'used': used,
    'closingStock': closingStock,
    'reorderLevel': reorderLevel,
    'status': status,
    'createdAt': Timestamp.fromDate(createdAt),
    'lastUpdated': Timestamp.fromDate(lastUpdated),
  };

  factory PoultryInventory.fromMap(String id, Map<String, dynamic> map) => PoultryInventory(
    id: id,
    userId: map['userId'] as String,
    itemName: map['itemName'] as String,
    unit: map['unit'] as String,
    openingStock: (map['openingStock'] as num).toDouble(),
    purchased: (map['purchased'] as num).toDouble(),
    used: (map['used'] as num).toDouble(),
    closingStock: (map['closingStock'] as num).toDouble(),
    reorderLevel: (map['reorderLevel'] as num).toDouble(),
    status: map['status'] as String,
    createdAt: (map['createdAt'] as Timestamp).toDate(),
    lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
  );
}
