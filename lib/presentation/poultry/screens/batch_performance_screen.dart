import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/poultry_constants.dart';
import '../../../state/poultry/poultry_provider.dart';

class BatchPerformanceScreen extends StatelessWidget {
  const BatchPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);
    final performances = provider.batchPerformances;

    final bestBatch = performances.isEmpty
        ? null
        : performances.reduce((a, b) => a.netProfit > b.netProfit ? a : b);

    return Scaffold(
      appBar: AppBar(title: const Text('\u{1F4C8} Batch Performance')),
      body: Column(
        children: [
          if (bestBatch != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: AppColors.lightGreen,
              child: Text(
                'Best Batch (P&L): ${bestBatch.batchId} - KES ${bestBatch.netProfit.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.darkGreen,
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: performances.length,
              itemBuilder: (context, index) {
                final p = performances[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text('Batch: ${p.batchId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text('${p.birdType}', style: const TextStyle(color: AppColors.textLight)),
                        ]),
                        const Divider(),
                        _row('Started', '${p.started}', 'Sold/Surv.', '${p.soldSurvived}'),
                        _row('Deaths', '${p.deaths}', 'Mort.%', '${p.mortalityPercent.toStringAsFixed(1)}%'),
                        _row('Feed (kg)', '${p.feedKg.toStringAsFixed(1)}', 'FCR', '${p.fcr.toStringAsFixed(2)}'),
                        _row('Total Income', 'KES ${p.totalIncome.toStringAsFixed(2)}', 'Total Costs', 'KES ${p.totalCosts.toStringAsFixed(2)}'),
                        const Divider(),
                        Row(children: [
                          const Text('Net Profit: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            'KES ${p.netProfit.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: p.netProfit >= 0 ? AppColors.primaryGreen : AppColors.accentRed,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String l1, String v1, String l2, String v2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        SizedBox(width: 80, child: Text(l1, style: const TextStyle(fontSize: 12, color: AppColors.textLight))),
        SizedBox(width: 80, child: Text(v1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        SizedBox(width: 80, child: Text(l2, style: const TextStyle(fontSize: 12, color: AppColors.textLight))),
        Text(v2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
