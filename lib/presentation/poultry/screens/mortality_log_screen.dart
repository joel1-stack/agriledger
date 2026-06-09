import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/poultry_constants.dart';
import '../../../state/poultry/poultry_provider.dart';

import '../widgets/poultry_drawer.dart';
class MortalityLogScreen extends StatelessWidget {
  const MortalityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);
    final records = provider.mortality;

    return Scaffold(
      appBar: AppBar(title: const Text('\u{2620}\u{FE0F} Mortality Log')),
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
                  const Text('Total Deaths YTD',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textLight)),
                  const SizedBox(height: 4),
                  Text(
                    '${provider.totalDeaths.toInt()}',
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
                ? const Center(child: Text('No mortality records'))
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
                                '${r.date.toLocal().toString().substring(0, 10)}  |  Batch: ${r.batchId}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${r.birdType}  |  Deaths: ${r.deaths}  |  Cause: ${r.causeOfDeath}',
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Cumulative: ${r.cumulativeDeaths}  |  '
                                'Rate: ${r.mortalityRate.toStringAsFixed(1)}%  |  '
                                'Action: ${r.actionTaken}',
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

