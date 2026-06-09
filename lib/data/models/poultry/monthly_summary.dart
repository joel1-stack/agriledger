import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlySummary {
  final String id;
  final String userId;
  final String month;
  final double eggIncome;
  final double birdSales;
  final double otherIncome;
  final double totalIncome;
  final double feedCost;
  final double vetCost;
  final double labour;
  final double housing;
  final double overheads;
  final double totalExpenses;
  final double netPL;
  final double marginPercent;
  final DateTime createdAt;

  MonthlySummary({
    required this.id,
    required this.userId,
    required this.month,
    required this.eggIncome,
    required this.birdSales,
    required this.otherIncome,
    required this.totalIncome,
    required this.feedCost,
    required this.vetCost,
    required this.labour,
    required this.housing,
    required this.overheads,
    required this.totalExpenses,
    required this.netPL,
    required this.marginPercent,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'month': month,
    'eggIncome': eggIncome,
    'birdSales': birdSales,
    'otherIncome': otherIncome,
    'totalIncome': totalIncome,
    'feedCost': feedCost,
    'vetCost': vetCost,
    'labour': labour,
    'housing': housing,
    'overheads': overheads,
    'totalExpenses': totalExpenses,
    'netPL': netPL,
    'marginPercent': marginPercent,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory MonthlySummary.fromMap(String id, Map<String, dynamic> map) => MonthlySummary(
    id: id,
    userId: map['userId'] as String,
    month: map['month'] as String,
    eggIncome: (map['eggIncome'] as num).toDouble(),
    birdSales: (map['birdSales'] as num).toDouble(),
    otherIncome: (map['otherIncome'] as num).toDouble(),
    totalIncome: (map['totalIncome'] as num).toDouble(),
    feedCost: (map['feedCost'] as num).toDouble(),
    vetCost: (map['vetCost'] as num).toDouble(),
    labour: (map['labour'] as num).toDouble(),
    housing: (map['housing'] as num).toDouble(),
    overheads: (map['overheads'] as num).toDouble(),
    totalExpenses: (map['totalExpenses'] as num).toDouble(),
    netPL: (map['netPL'] as num).toDouble(),
    marginPercent: (map['marginPercent'] as num).toDouble(),
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );
}
