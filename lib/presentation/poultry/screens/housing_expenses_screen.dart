import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/poultry_constants.dart';
import '../../../state/poultry/poultry_provider.dart';

import '../widgets/poultry_drawer.dart';
class HousingExpensesScreen extends StatelessWidget {
  const HousingExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);
    final records = provider.housing;

    return Scaffold(
      appBar: AppBar(title: const Text('\u{1F3E0} Housing & Equipment')),
      drawer: const PoultryDrawer(),
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
            child: Center(
              child: Column(
                children: [
                  const Text('Total Housing Cost',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textLight)),
                  const SizedBox(height: 4),
                  Text(
                    'KSh ${provider.totalHousingCost.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: records.isEmpty
                ? const Center(child: Text('No housing expenses'))
                : ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (_, i) {
                      final r = records[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${r.date.toLocal().toString().substring(0, 10)}  |  ${r.birdType}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${r.category}  |  ${r.description}  |  '
                                'Ref: ${r.referenceNo ?? "N/A"}',
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Amount: KSh ${r.amount.toStringAsFixed(0)}  |  '
                                'Cumulative: KSh ${r.cumulative?.toStringAsFixed(0) ?? "N/A"}',
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
}

