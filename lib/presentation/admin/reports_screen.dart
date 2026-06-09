import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../state/poultry/poultry_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PoultryProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(title: const Text('Reports & Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Financial Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: AppColors.textDark)),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _ReportRow('Total Revenue', 'KES ${_fmt(p.totalRevenue)}', AppColors.primaryGreen),
                    _ReportRow('Feed Costs', 'KES ${_fmt(p.totalFeedCost)}', AppColors.accentOrange),
                    _ReportRow('Vet Costs', 'KES ${_fmt(p.totalVetCost)}', AppColors.accentRed),
                    _ReportRow('Labour Costs', 'KES ${_fmt(p.totalLabourCost)}', AppColors.accentAmber),
                    _ReportRow('Housing Costs', 'KES ${_fmt(p.totalHousingCost)}', AppColors.accentBlue),
                    _ReportRow('Overhead Costs', 'KES ${_fmt(p.totalOverheadCost)}', AppColors.accentPurple),
                    const Divider(thickness: 1.5),
                    _ReportRow('Total Expenses', 'KES ${_fmt(p.totalExpenses)}', AppColors.accentRed),
                    _ReportRow('Net Profit', 'KES ${_fmt(p.netProfit)}', p.netProfit >= 0 ? AppColors.primaryGreen : AppColors.accentRed),
                    _ReportRow('Profit Margin', '${p.profitMargin.toStringAsFixed(1)}%', AppColors.accentTeal),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Production', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: AppColors.textDark)),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _ReportRow('Total Active Birds', '${p.totalActiveBirds}', AppColors.primaryGreen),
                    _ReportRow('Laying Rate (Layers)', '${p.avgLayerRate.toStringAsFixed(1)}%', AppColors.accentAmber),
                    _ReportRow('Kienyeji Rate', '${p.avgKienyejiRate.toStringAsFixed(1)}%', AppColors.accentOrange),
                    _ReportRow('Egg Income', 'KES ${_fmt(p.totalEggIncome)}', AppColors.accentTeal),
                    _ReportRow('Bird Sales', 'KES ${_fmt(p.totalBirdSales)}', AppColors.accentBlue),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double v) => v >= 1000000 ? '${(v / 1000000).toStringAsFixed(1)}M' : v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}K' : v.toStringAsFixed(0);
}

class _ReportRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const _ReportRow(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textMedium, fontFamily: 'Poppins')),
          ),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color, fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}
