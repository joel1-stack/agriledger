import 'package:cloud_firestore/cloud_firestore.dart';

class FlockBatch {
  final String id;
  final String userId;
  final String batchId;
  final String name;
  final String breed;
  final DateTime datePlaced;
  final String birdType;
  final int birdsAtStart;
  final String source;
  final double costPerBird;
  final double totalCost;
  final DateTime? prodStartDate;
  final DateTime? endDate;
  final int? birdsSold;
  final String? notes;
  final String status;
  final DateTime createdAt;
  final DateTime lastUpdated;

  int get activeBirds => birdsAtStart - (birdsSold ?? 0);

  FlockBatch({
    required this.id,
    required this.userId,
    required this.batchId,
    this.name = '',
    required this.breed,
    required this.datePlaced,
    required this.birdType,
    required this.birdsAtStart,
    required this.source,
    required this.costPerBird,
    required this.totalCost,
    this.prodStartDate,
    this.endDate,
    this.birdsSold,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'batchId': batchId,
    'name': name,
    'breed': breed,
    'datePlaced': Timestamp.fromDate(datePlaced),
    'birdType': birdType,
    'birdsAtStart': birdsAtStart,
    'source': source,
    'costPerBird': costPerBird,
    'totalCost': totalCost,
    'prodStartDate': prodStartDate != null ? Timestamp.fromDate(prodStartDate!) : null,
    'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
    'birdsSold': birdsSold,
    'notes': notes,
    'status': status,
    'createdAt': Timestamp.fromDate(createdAt),
    'lastUpdated': Timestamp.fromDate(lastUpdated),
  };

  factory FlockBatch.fromMap(String id, Map<String, dynamic> map) => FlockBatch(
    id: id,
    userId: map['userId'] as String? ?? map['recordedBy'] as String? ?? '',
    batchId: map['batchId'] as String? ?? id,
    name: map['name'] as String? ?? '',
    breed: map['breed'] as String? ?? '',
    datePlaced: (map['datePlaced'] as Timestamp?)?.toDate() ?? (map['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    birdType: map['birdType'] as String? ?? '',
    birdsAtStart: (map['birdsAtStart'] as num? ?? map['flockSize'] as num? ?? 0).toInt(),
    source: map['source'] as String? ?? '',
    costPerBird: (map['costPerBird'] as num?)?.toDouble() ?? 0,
    totalCost: (map['totalCost'] as num?)?.toDouble() ?? 0,
    prodStartDate: (map['prodStartDate'] as Timestamp?)?.toDate(),
    endDate: (map['endDate'] as Timestamp?)?.toDate(),
    birdsSold: (map['birdsSold'] as num?)?.toInt(),
    notes: map['notes'] as String?,
    status: map['status'] as String? ?? 'Active',
    createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    lastUpdated: (map['lastUpdated'] as Timestamp?)?.toDate() ?? (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}
