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
  final String status;
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
    this.status = 'pending',
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
    'status': status,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory EggProduction.fromMap(String id, Map<String, dynamic> map) => EggProduction(
    id: id,
    userId: map['userId'] as String? ?? '',
    date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    batchId: map['batchId'] as String? ?? '',
    flockSize: (map['flockSize'] as num?)?.toInt() ?? 0,
    birdType: map['birdType'] as String? ?? '',
    morningEggs: (map['morningEggs'] as num?)?.toInt() ?? 0,
    afternoonEggs: (map['afternoonEggs'] as num?)?.toInt() ?? 0,
    totalEggs: (map['totalEggs'] as num?)?.toInt() ?? 0,
    saleableEggs: (map['saleableEggs'] as num?)?.toInt() ?? 0,
    henDayPercent: (map['henDayPercent'] as num?)?.toDouble() ?? 0,
    trays: (map['trays'] as num?)?.toDouble() ?? 0,
    broken: (map['broken'] as num?)?.toInt() ?? 0,
    notes: map['notes'] as String?,
    status: map['status'] as String? ?? 'pending',
    createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}
