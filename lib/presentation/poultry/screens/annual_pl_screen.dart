import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/poultry/poultry_provider.dart';

import '../widgets/poultry_drawer.dart';
class AnnualPLScreen extends StatelessWidget {
  const AnnualPLScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('\u{1F4CA} Annual P&L')),
      drawer: const PoultryDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader('REVENUE'),
          _plRow('Egg Sales', provider.totalEggIncome),
          _plRow('Bird Sales', provider.totalBirdSales),
          _plRow('Other Income', provider.totalOtherIncome),
          const Divider(thickness: 2),
          _plRow('TOTAL REVENUE', provider.totalRevenue, bold: true, color: AppColors.primaryGreen),
          const SizedBox(height: 16),
          _sectionHeader('EXPENSES'),
          _plRow('Feed & Nutrition', provider.totalFeedCost),
          _plRow('Veterinary & Health', provider.totalVetCost),
          _plRow('Labour & Staffing', provider.totalLabourCost),
          _plRow('Housing & Equipment', provider.totalHousingCost),
          _plRow('Farm Overheads', provider.totalOverheadCost),
          const Divider(thickness: 2),
          _plRow('TOTAL EXPENSES', provider.totalExpenses, bold: true, color: AppColors.accentRed),
          const SizedBox(height: 16),
          _sectionHeader('PROFITABILITY'),
          const Divider(thickness: 2, color: AppColors.primaryGreen),
          _plRow('GROSS PROFIT', provider.netProfit, bold: true,
              color: provider.netProfit >= 0 ? AppColors.primaryGreen : AppColors.accentRed),
          _plRow('Profit Margin %', provider.profitMargin, bold: true,
              color: provider.profitMargin >= 0 ? AppColors.primaryGreen : AppColors.accentRed, isPercent: true),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _plRow(String label, double value, {bool bold = false, Color? color, bool isPercent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
          Text(
            isPercent ? '${value.toStringAsFixed(2)}%' : 'KES ${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: color ?? AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}


