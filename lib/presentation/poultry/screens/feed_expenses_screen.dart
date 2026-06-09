import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/poultry_constants.dart';
import '../../../state/poultry/poultry_provider.dart';

class FeedExpensesScreen extends StatelessWidget {
  const FeedExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);
    final expenses = provider.feedExpenses;
    final totalLayerFeed = expenses
        .where((e) => e.birdType == BirdType.layer)
        .fold(0.0, (s, e) => s + e.totalCost);

    return Scaffold(
      appBar: AppBar(title: const Text('\u{1F33E} Feed Expenses')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.primaryGreen.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryTile('Total Feed Cost',
                    'KSh ${provider.totalFeedCost.toStringAsFixed(0)}'),
                _summaryTile('Layer Feed Cost',
                    'KSh ${totalLayerFeed.toStringAsFixed(0)}'),
              ],
            ),
          ),
          Expanded(
            child: expenses.isEmpty
                ? const Center(child: Text('No feed expenses recorded'))
                : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (_, i) {
                      final e = expenses[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${e.date.toLocal().toString().substring(0, 10)}  |  Batch: ${e.batchId}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${e.feedType}  |  ${e.birdType}  |  ${e.supplier}',
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Qty: ${e.qtyKg.toStringAsFixed(1)} kg  |  '
                                'Total: KSh ${e.totalCost.toStringAsFixed(0)}  |  '
                                'Unit: KSh ${e.unitCost.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 13),
                              ),
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

  Widget _summaryTile(String title, String value) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark)),
      ],
    );
  }
}
