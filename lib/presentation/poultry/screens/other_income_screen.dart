import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/poultry/poultry_provider.dart';
import '../../../data/models/poultry/other_income.dart';
import '../../../core/theme/app_theme.dart';

import '../widgets/poultry_drawer.dart';
class OtherIncomeScreen extends StatelessWidget {
  const OtherIncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('\U0001f4b0 Other Income')),
      drawer: const PoultryDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.mintGreen,
            child: Center(
              child: Column(
                children: [
                  const Text('Total Other Income', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                  const SizedBox(height: 4),
                  Text('KES ${provider.totalOtherIncome.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                ],
              ),
            ),
          ),
          Expanded(
            child: provider.otherIncome.isEmpty
                ? const Center(child: Text('No other income records', style: TextStyle(color: AppColors.textMuted)))
                : ListView.builder(
                    itemCount: provider.otherIncome.length,
                    itemBuilder: (_, i) => _incomeTile(context, provider.otherIncome[i]),
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

  Widget _incomeTile(BuildContext context, OtherIncome o) {
    final dateStr = '${o.date.day}/${o.date.month}/${o.date.year}';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.accentBlue.withOpacity(0.2),
          child: const Icon(Icons.attach_money, color: AppColors.accentBlue),
        ),
        title: Text('$dateStr - ${o.category}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(
          '${o.description}  |  ${o.quantity} x KES ${o.unitPrice.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text('KES ${o.total.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryGreen)),
      ),
    );
  }
}


