import 'package:cloud_firestore/cloud_firestore.dart';

class FeedConsumption {
  final String id;
  final String userId;
  final DateTime date;
  final String batchId;
  final int birds;
  final String birdType;
  final String feedType;
  final double amountFed;
  final double perBirdPerDay;
  final double? fcr;
  final DateTime createdAt;

  FeedConsumption({
    required this.id,
    required this.userId,
    required this.date,
    required this.batchId,
    required this.birds,
    required this.birdType,
    required this.feedType,
    required this.amountFed,
    required this.perBirdPerDay,
    this.fcr,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'date': Timestamp.fromDate(date),
    'batchId': batchId,
    'birds': birds,
    'birdType': birdType,
    'feedType': feedType,
    'amountFed': amountFed,
    'perBirdPerDay': perBirdPerDay,
    'fcr': fcr,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory FeedConsumption.fromMap(String id, Map<String, dynamic> map) => FeedConsumption(
    id: id,
    userId: map['userId'] as String,
    date: (map['date'] as Timestamp).toDate(),
    batchId: map['batchId'] as String,
    birds: map['birds'] as int,
    birdType: map['birdType'] as String,
    feedType: map['feedType'] as String,
    amountFed: (map['amountFed'] as num).toDouble(),
    perBirdPerDay: (map['perBirdPerDay'] as num).toDouble(),
    fcr: (map['fcr'] as num?)?.toDouble(),
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );
}
