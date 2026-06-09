import 'package:cloud_firestore/cloud_firestore.dart';

class FlockBatch {
  final String id;
  final String userId;
  final String batchId;
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
    userId: map['userId'] as String,
    batchId: map['batchId'] as String,
    breed: map['breed'] as String,
    datePlaced: (map['datePlaced'] as Timestamp).toDate(),
    birdType: map['birdType'] as String,
    birdsAtStart: map['birdsAtStart'] as int,
    source: map['source'] as String,
    costPerBird: (map['costPerBird'] as num).toDouble(),
    totalCost: (map['totalCost'] as num).toDouble(),
    prodStartDate: map['prodStartDate'] != null ? (map['prodStartDate'] as Timestamp).toDate() : null,
    endDate: map['endDate'] != null ? (map['endDate'] as Timestamp).toDate() : null,
    birdsSold: map['birdsSold'] as int?,
    notes: map['notes'] as String?,
    status: map['status'] as String,
    createdAt: (map['createdAt'] as Timestamp).toDate(),
    lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
  );
}
