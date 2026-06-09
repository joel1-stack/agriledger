import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/poultry/poultry_provider.dart';
import '../../../data/models/poultry/egg_production.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/poultry_constants.dart';

import '../widgets/poultry_drawer.dart';
class ProductionLogScreen extends StatelessWidget {
  const ProductionLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);
    final production = provider.production;
    final today = DateTime.now();
    final todayEggs = production
        .where((p) =>
            p.date.year == today.year && p.date.month == today.month && p.date.day == today.day)
        .fold(0, (sum, p) => sum + p.totalEggs);
    final monthlyTrays = production
        .where((p) => p.date.year == today.year && p.date.month == today.month)
        .fold(0.0, (sum, p) => sum + p.trays);

    return Scaffold(
      appBar: AppBar(title: const Text('\U0001f95a Production Log')),
      drawer: const PoultryDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.mintGreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _sumItem('Monthly Trays', monthlyTrays.toStringAsFixed(1)),
                _sumItem('Avg Layer %', '${provider.avgLayerRate.toStringAsFixed(1)}%'),
                _sumItem('Avg Kien %', '${provider.avgKienyejiRate.toStringAsFixed(1)}%'),
                _sumItem('Eggs Today', '$todayEggs'),
              ],
            ),
          ),
          Expanded(
            child: production.isEmpty
                ? const Center(child: Text('No production records', style: TextStyle(color: AppColors.textMuted)))
                : ListView.builder(
                    itemCount: production.length,
                    itemBuilder: (_, i) => _prodTile(context, production[i]),
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

  Widget _sumItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
      ],
    );
  }

  Widget _prodTile(BuildContext context, EggProduction p) {
    final dateStr = '${p.date.day}/${p.date.month}/${p.date.year}';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.accentAmber.withOpacity(0.2),
          child: const Icon(Icons.egg, color: AppColors.accentAmber),
        ),
        title: Text('$dateStr - ${p.batchId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(
          '${p.birdType}  |  AM:${p.morningEggs} PM:${p.afternoonEggs}  |  Total:${p.totalEggs}  |  ${p.henDayPercent.toStringAsFixed(1)}%  |  ${p.trays.toStringAsFixed(1)} trays',
          style: const TextStyle(fontSize: 12),
        ),
        onTap: () {},
      ),
    );
  }
}

