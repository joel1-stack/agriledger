import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../state/poultry/poultry_provider.dart';
import '../../data/models/poultry/monthly_summary.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PoultryProvider>();
    final summaries = p.monthlySummaries;
    final hasData = summaries.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B8A3C),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Reports & Analytics', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(p),
            const SizedBox(height: 20),
            if (hasData) ...[
              _buildIncomeExpenseChart(summaries),
              const SizedBox(height: 16),
              _buildProfitTrendChart(summaries),
              const SizedBox(height: 16),
              _buildExpensePieChart(summaries),
              const SizedBox(height: 16),
            ],
            _buildFinancialBreakdown(p),
            const SizedBox(height: 16),
            _buildProductionStats(p),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(PoultryProvider p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&w=600&q=80'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            _statRow('Total Revenue', 'KES ${_fmt(p.totalRevenue)}', const Color(0xFF10B981)),
            const SizedBox(height: 6),
            _statRow('Total Expenses', 'KES ${_fmt(p.totalExpenses)}', const Color(0xFFEF4444)),
            const Divider(color: Colors.white24, height: 16),
            _statRow('Net Profit', 'KES ${_fmt(p.netProfit)}', p.netProfit >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
            _statRow('Profit Margin', '${p.profitMargin.toStringAsFixed(1)}%', const Color(0xFF0EA5E9)),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseChart(List<MonthlySummary> summaries) {
    final sorted = List<MonthlySummary>.from(summaries)..sort((a, b) => a.month.compareTo(b.month));
    final labels = sorted.map((s) => s.month.length >= 3 ? s.month.substring(0, 3) : s.month).toList();
    final maxVal = sorted.fold<double>(0, (m, s) => [m, s.totalIncome, s.totalExpenses].reduce((a, b) => a > b ? a : b));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.bar_chart_rounded, size: 16, color: Color(0xFF10B981))),
            const SizedBox(width: 8),
            const Text('Income vs Expenses', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, fontFamily: 'Poppins', color: Color(0xFF0F172A))),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal * 1.2,
                barTouchData: BarTouchData(enabled: true, touchTooltipData: BarTouchTooltipData(tooltipBorderRadius: BorderRadius.circular(8), getTooltipItem: (g, gIndex, bar, barIndex) => BarTooltipItem(bar.toY.toStringAsFixed(0), const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: 'Poppins')))),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) => v.toInt() < labels.length ? Padding(padding: const EdgeInsets.only(top: 6), child: Text(labels[v.toInt()], style: const TextStyle(fontSize: 10, fontFamily: 'Poppins', color: Color(0xFF94A3B8)))) : const SizedBox())),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v, m) => Text(_fmt(v), style: const TextStyle(fontSize: 9, fontFamily: 'Poppins', color: Color(0xFF94A3B8))))),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: maxVal > 0 ? maxVal / 4 : 1, getDrawingHorizontalLine: (v) => FlLine(color: const Color(0xFFF1F5F9), strokeWidth: 1)),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(sorted.length, (i) {
                  return BarChartGroupData(x: i, barRods: [
                    BarChartRodData(toY: sorted[i].totalIncome, color: const Color(0xFF10B981), width: 10, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
                    BarChartRodData(toY: sorted[i].totalExpenses, color: const Color(0xFFEF4444), width: 10, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
                  ]);
                }),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _legendDot(const Color(0xFF10B981), 'Income'),
            const SizedBox(width: 20),
            _legendDot(const Color(0xFFEF4444), 'Expenses'),
          ]),
        ],
      ),
    );
  }

  Widget _buildProfitTrendChart(List<MonthlySummary> summaries) {
    final sorted = List<MonthlySummary>.from(summaries)..sort((a, b) => a.month.compareTo(b.month));
    final labels = sorted.map((s) => s.month.length >= 3 ? s.month.substring(0, 3) : s.month).toList();
    final minVal = sorted.fold<double>(0, (m, s) => s.netPL < m ? s.netPL : m);
    final maxVal = sorted.fold<double>(0, (m, s) => s.netPL > m ? s.netPL : m);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFF8B5CF6).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.trending_up_rounded, size: 16, color: Color(0xFF8B5CF6))),
            const SizedBox(width: 8),
            const Text('Profit Trend', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, fontFamily: 'Poppins', color: Color(0xFF0F172A))),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: minVal < 0 ? minVal * 1.3 : 0,
                maxY: maxVal > 0 ? maxVal * 1.3 : 1,
                lineTouchData: LineTouchData(enabled: true, touchTooltipData: LineTouchTooltipData(tooltipBorderRadius: BorderRadius.circular(8), getTooltipItems: (spots) => spots.map((s) => LineTooltipItem('KES ${_fmt(s.y)}', const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: 'Poppins'))).toList())),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) => v.toInt() < labels.length ? Padding(padding: const EdgeInsets.only(top: 6), child: Text(labels[v.toInt()], style: const TextStyle(fontSize: 10, fontFamily: 'Poppins', color: Color(0xFF94A3B8)))) : const SizedBox())),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v, m) => Text(_fmt(v), style: const TextStyle(fontSize: 9, fontFamily: 'Poppins', color: Color(0xFF94A3B8))))),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: maxVal > 0 ? (maxVal - minVal) / 4 : 1, getDrawingHorizontalLine: (v) => FlLine(color: const Color(0xFFF1F5F9), strokeWidth: 1)),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(sorted.length, (i) => FlSpot(i.toDouble(), sorted[i].netPL)),
                    isCurved: true,
                    color: const Color(0xFF8B5CF6),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true, getDotPainter: (s, percent, bar, index) => FlDotCirclePainter(radius: 4, color: Colors.white, strokeWidth: 2.5, strokeColor: const Color(0xFF8B5CF6))),
                    belowBarData: BarAreaData(show: true, color: const Color(0xFF8B5CF6).withValues(alpha: 0.1)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _legendDot(const Color(0xFF8B5CF6), 'Net Profit/Loss'),
          ]),
        ],
      ),
    );
  }

  Widget _buildExpensePieChart(List<MonthlySummary> summaries) {
    final totalFeed = summaries.fold<double>(0, (s, m) => s + m.feedCost);
    final totalVet = summaries.fold<double>(0, (s, m) => s + m.vetCost);
    final totalLabour = summaries.fold<double>(0, (s, m) => s + m.labour);
    final totalHousing = summaries.fold<double>(0, (s, m) => s + m.housing);
    final totalOverhead = summaries.fold<double>(0, (s, m) => s + m.overheads);
    final grandTotal = totalFeed + totalVet + totalLabour + totalHousing + totalOverhead;

    final sections = [
      _PieSection('Feed', totalFeed, const Color(0xFFF59E0B)),
      _PieSection('Vet', totalVet, const Color(0xFFEF4444)),
      _PieSection('Labour', totalLabour, const Color(0xFF3B82F6)),
      _PieSection('Housing', totalHousing, const Color(0xFF0EA5E9)),
      _PieSection('Overhead', totalOverhead, const Color(0xFF8B5CF6)),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFFF59E0B).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.pie_chart_rounded, size: 16, color: Color(0xFFF59E0B))),
            const SizedBox(width: 8),
            const Text('Expense Breakdown', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, fontFamily: 'Poppins', color: Color(0xFF0F172A))),
          ]),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                height: 160,
                width: 160,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 36,
                    sections: sections.where((s) => s.value > 0).map((s) => PieChartSectionData(
                      value: s.value,
                      color: s.color,
                      radius: 50,
                      title: grandTotal > 0 ? '${(s.value / grandTotal * 100).toStringAsFixed(0)}%' : '0%',
                      titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Poppins'),
                    )).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sections.where((s) => s.value > 0).map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: s.color, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Expanded(child: Text(s.label, style: const TextStyle(fontSize: 12, fontFamily: 'Poppins', color: Color(0xFF475569)))),
                        Text('${(s.value / grandTotal * 100).toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: Color(0xFF0F172A))),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialBreakdown(PoultryProvider p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFFF59E0B).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.receipt_long_rounded, size: 16, color: Color(0xFFF59E0B))),
            const SizedBox(width: 8),
            const Text('Financial Breakdown', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, fontFamily: 'Poppins', color: Color(0xFF0F172A))),
          ]),
          const SizedBox(height: 12),
          _ReportRow('Feed Costs', 'KES ${_fmt(p.totalFeedCost)}', const Color(0xFFF59E0B)),
          _ReportRow('Vet Costs', 'KES ${_fmt(p.totalVetCost)}', const Color(0xFFEF4444)),
          _ReportRow('Labour', 'KES ${_fmt(p.totalLabourCost)}', const Color(0xFF3B82F6)),
          _ReportRow('Housing', 'KES ${_fmt(p.totalHousingCost)}', const Color(0xFF0EA5E9)),
          _ReportRow('Overheads', 'KES ${_fmt(p.totalOverheadCost)}', const Color(0xFF8B5CF6)),
        ],
      ),
    );
  }

  Widget _buildProductionStats(PoultryProvider p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFF0EA5E9).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.egg_rounded, size: 16, color: Color(0xFF0EA5E9))),
            const SizedBox(width: 8),
            const Text('Production', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, fontFamily: 'Poppins', color: Color(0xFF0F172A))),
          ]),
          const SizedBox(height: 12),
          _ReportRow('Active Birds', '${p.totalActiveBirds}', const Color(0xFF10B981)),
          _ReportRow('Laying Rate', '${p.avgLayerRate.toStringAsFixed(1)}%', const Color(0xFFF59E0B)),
          _ReportRow('Kienyeji Rate', '${p.avgKienyejiRate.toStringAsFixed(1)}%', const Color(0xFFF97316)),
          _ReportRow('Egg Income', 'KES ${_fmt(p.totalEggIncome)}', const Color(0xFF14B8A6)),
          _ReportRow('Bird Sales', 'KES ${_fmt(p.totalBirdSales)}', const Color(0xFF0EA5E9)),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, Color color) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.white70, fontFamily: 'Poppins'))),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color, fontFamily: 'Poppins')),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 11, fontFamily: 'Poppins', color: Color(0xFF64748B))),
    ]);
  }

  String _fmt(double v) => v >= 1000000 ? '${(v / 1000000).toStringAsFixed(1)}M' : v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}K' : v.toStringAsFixed(0);
}

class _PieSection {
  final String label;
  final double value;
  final Color color;
  const _PieSection(this.label, this.value, this.color);
}

class _ReportRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const _ReportRow(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontFamily: 'Poppins'))),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color, fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}
