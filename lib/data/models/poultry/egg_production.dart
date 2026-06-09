import 'package:cloud_firestore/cloud_firestore.dart';

class EggProduction {
  final String id;
  final String userId;
  final DateTime date;
  final String batchId;
  final int flockSize;
  final String birdType;
  final int morningEggs;
  final int afternoonEggs;
  final int totalEggs;
  final int saleableEggs;
  final double henDayPercent;
  final double trays;
  final int broken;
  final String? notes;
  final DateTime createdAt;

  EggProduction({
    required this.id,
    required this.userId,
    required this.date,
    required this.batchId,
    required this.flockSize,
    required this.birdType,
    required this.morningEggs,
    required this.afternoonEggs,
    required this.totalEggs,
    required this.saleableEggs,
    required this.henDayPercent,
    required this.trays,
    this.broken = 0,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'date': Timestamp.fromDate(date),
    'batchId': batchId,
    'flockSize': flockSize,
    'birdType': birdType,
    'morningEggs': morningEggs,
    'afternoonEggs': afternoonEggs,
    'totalEggs': totalEggs,
    'saleableEggs': saleableEggs,
    'henDayPercent': henDayPercent,
    'trays': trays,
    'broken': broken,
    'notes': notes,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory EggProduction.fromMap(String id, Map<String, dynamic> map) => EggProduction(
    id: id,
    userId: map['userId'] as String,
    date: (map['date'] as Timestamp).toDate(),
    batchId: map['batchId'] as String,
    flockSize: map['flockSize'] as int,
    birdType: map['birdType'] as String,
    morningEggs: map['morningEggs'] as int,
    afternoonEggs: map['afternoonEggs'] as int,
    totalEggs: map['totalEggs'] as int,
    saleableEggs: map['saleableEggs'] as int,
    henDayPercent: (map['henDayPercent'] as num).toDouble(),
    trays: (map['trays'] as num).toDouble(),
    broken: map['broken'] as int? ?? 0,
    notes: map['notes'] as String?,
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );
}
