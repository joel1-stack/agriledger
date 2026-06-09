import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/poultry/poultry_provider.dart';
import '../../../data/models/poultry/monthly_summary.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/poultry_constants.dart';

import '../widgets/poultry_drawer.dart';
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);
    final summaries = provider.monthlySummaries;

    return Scaffold(
      appBar: AppBar(title: const Text('\U0001f414 Poultry Dashboard')),
      drawer: const PoultryDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKpiGrid(context, provider),
            const SizedBox(height: 24),
            const Text('Monthly Performance Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 12),
            _buildMonthlyTable(summaries),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiGrid(BuildContext context, PoultryProvider p) {
    final kpis = [
      _KpiItem('Total Income', 'KES ${p.totalRevenue.toStringAsFixed(0)}', Icons.trending_up, AppColors.primaryGreen),
      _KpiItem('Total Expenses', 'KES ${p.totalExpenses.toStringAsFixed(0)}', Icons.money_off, AppColors.accentRed),
      _KpiItem('Net Profit', 'KES ${p.netProfit.toStringAsFixed(0)}', Icons.account_balance, AppColors.accentTeal),
      _KpiItem('Egg Income', 'KES ${p.totalEggIncome.toStringAsFixed(0)}', Icons.egg, AppColors.accentAmber),
      _KpiItem('Bird Sales', 'KES ${p.totalBirdSales.toStringAsFixed(0)}', Icons.sell, AppColors.accentOrange),
      _KpiItem('Total Birds', '${p.totalActiveBirds}', Icons.pets, AppColors.accentBlue),
      _KpiItem('Laying Rate', '${p.avgLayerRate.toStringAsFixed(1)}%', Icons.bar_chart, AppColors.accentPurple),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: kpis.length,
      itemBuilder: (_, i) => _kpiCard(kpis[i]),
    );
  }

  Widget _kpiCard(_KpiItem item) {
    return Card(
      color: item.color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(item.icon, color: item.color, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(item.label, style: const TextStyle(fontSize: 12, color: AppColors.textLight))),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: item.color)),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyTable(List<MonthlySummary> summaries) {
    if (summaries.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text('No monthly data yet', style: TextStyle(color: AppColors.textMuted))),
        ),
      );
    }

    final columns = ['Month', 'Income', 'Expenses', 'Net P/L', 'Margin%', 'Feed', 'Vet', 'Labour', 'Housing', 'Overhead', 'Egg Inc', 'Bird Sales'];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16,
          headingRowColor: WidgetStateProperty.all(AppColors.primaryGreen.withOpacity(0.1)),
          columns: columns.map((c) => DataColumn(label: Text(c, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)))).toList(),
          rows: summaries.map((s) => DataRow(cells: [
            DataCell(Text(s.month, style: const TextStyle(fontSize: 11))),
            DataCell(Text(s.totalIncome.toStringAsFixed(0), style: const TextStyle(fontSize: 11))),
            DataCell(Text(s.totalExpenses.toStringAsFixed(0), style: const TextStyle(fontSize: 11))),
            DataCell(Text(s.netPL.toStringAsFixed(0), style: TextStyle(fontSize: 11, color: s.netPL >= 0 ? AppColors.primaryGreen : AppColors.accentRed))),
            DataCell(Text('${s.marginPercent.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 11))),
            DataCell(Text(s.feedCost.toStringAsFixed(0), style: const TextStyle(fontSize: 11))),
            DataCell(Text(s.vetCost.toStringAsFixed(0), style: const TextStyle(fontSize: 11))),
            DataCell(Text(s.labour.toStringAsFixed(0), style: const TextStyle(fontSize: 11))),
            DataCell(Text(s.housing.toStringAsFixed(0), style: const TextStyle(fontSize: 11))),
            DataCell(Text(s.overheads.toStringAsFixed(0), style: const TextStyle(fontSize: 11))),
            DataCell(Text(s.eggIncome.toStringAsFixed(0), style: const TextStyle(fontSize: 11))),
            DataCell(Text(s.birdSales.toStringAsFixed(0), style: const TextStyle(fontSize: 11))),
          ])).toList(),
        ),
      ),
    );
  }
}

class _KpiItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  _KpiItem(this.label, this.value, this.icon, this.color);
}

