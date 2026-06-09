import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/poultry_constants.dart';
import '../../../state/poultry/poultry_provider.dart';

import '../widgets/poultry_drawer.dart';
class OverheadsScreen extends StatelessWidget {
  const OverheadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);
    final overheads = provider.overheads;
    final totalOverhead = provider.totalOverheadCost;

    return Scaffold(
      appBar: AppBar(title: const Text('\u2699\ufe0f Operations & Overheads')),
      drawer: const PoultryDrawer(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.primaryGreen,
            child: Text(
              'Total Overhead Cost: KES ${totalOverhead.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: overheads.length,
              itemBuilder: (context, index) {
                final o = overheads[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    title: Text('${o.category} - ${o.description}'),
                    subtitle: Text(
                      '${o.date.toString().substring(0, 10)} | Ref: ${o.referenceNo ?? 'N/A'}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('KES ${o.amount.toStringAsFixed(2)}'),
                        if (o.cumulative != null)
                          Text(
                            'Cum: KES ${o.cumulative!.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

