import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/poultry/poultry_provider.dart';

import '../widgets/poultry_drawer.dart';
class FeedConsumptionScreen extends StatelessWidget {
  const FeedConsumptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);
    final records = provider.feedConsumption;

    return Scaffold(
      appBar: AppBar(title: const Text('\u{1F4CA} Feed Consumption')),
      drawer: const PoultryDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: records.isEmpty
          ? const Center(child: Text('No feed consumption records'))
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (_, i) {
                final r = records[i];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${r.date.toLocal().toString().substring(0, 10)}  |  Batch: ${r.batchId}',
                          style:
                              const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Birds: ${r.birds}  |  ${r.birdType}  |  ${r.feedType}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fed: ${r.amountFed.toStringAsFixed(1)} kg  |  '
                          'Per Bird/Day: ${r.perBirdPerDay.toStringAsFixed(2)} kg  |  '
                          'FCR: ${r.fcr?.toStringAsFixed(2) ?? "N/A"}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}


