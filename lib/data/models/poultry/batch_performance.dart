class BatchPerformance {
  final String batchId;
  final String birdType;
  final int started;
  final int soldSurvived;
  final int deaths;
  final double mortalityPercent;
  final double feedKg;
  final double fcr;
  final double totalIncome;
  final double totalCosts;
  final double netProfit;

  BatchPerformance({
    required this.batchId,
    required this.birdType,
    required this.started,
    required this.soldSurvived,
    required this.deaths,
    required this.mortalityPercent,
    required this.feedKg,
    required this.fcr,
    required this.totalIncome,
    required this.totalCosts,
    required this.netProfit,
  });
}
