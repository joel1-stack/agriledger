import 'package:cloud_firestore/cloud_firestore.dart';

class MortalityRecord {
  final String id;
  final String userId;
  final DateTime date;
  final String batchId;
  final String birdType;
  final int birdsAtStart;
  final int deaths;
  final String causeOfDeath;
  final int cumulativeDeaths;
  final double mortalityRate;
  final String actionTaken;
  final DateTime createdAt;

  MortalityRecord({
    required this.id,
    required this.userId,
    required this.date,
    required this.batchId,
    required this.birdType,
    required this.birdsAtStart,
    required this.deaths,
    required this.causeOfDeath,
    required this.cumulativeDeaths,
    required this.mortalityRate,
    required this.actionTaken,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'date': Timestamp.fromDate(date),
    'batchId': batchId,
    'birdType': birdType,
    'birdsAtStart': birdsAtStart,
    'deaths': deaths,
    'causeOfDeath': causeOfDeath,
    'cumulativeDeaths': cumulativeDeaths,
    'mortalityRate': mortalityRate,
    'actionTaken': actionTaken,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory MortalityRecord.fromMap(String id, Map<String, dynamic> map) => MortalityRecord(
    id: id,
    userId: map['userId'] as String,
    date: (map['date'] as Timestamp).toDate(),
    batchId: map['batchId'] as String,
    birdType: map['birdType'] as String,
    birdsAtStart: map['birdsAtStart'] as int,
    deaths: map['deaths'] as int,
    causeOfDeath: map['causeOfDeath'] as String,
    cumulativeDeaths: map['cumulativeDeaths'] as int,
    mortalityRate: (map['mortalityRate'] as num).toDouble(),
    actionTaken: map['actionTaken'] as String,
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );
}
