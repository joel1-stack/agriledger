import 'dart:io';
import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/module_config.dart';
import '../../data/models/daily_record_model.dart';
import '../../state/daily_record/daily_record_provider.dart';
import '../../state/poultry/poultry_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PoultryProvider>();
    final dr = context.watch<DailyRecordProvider>();
    final allRecords = dr.records.where((r) => r.status == 'approved').toList();

    final monthlyData = _computeMonthlyData(allRecords);
    final summary = _computeSummary(allRecords);
    final moduleTotals = _computeModuleTotals(allRecords);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B8A3C),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Reports & Analytics',
          style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins'),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            color: Colors.white,
            onSelected: (v) => _handleExport(
              context,
              v,
              allRecords,
              summary,
              monthlyData,
              moduleTotals,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'pdf',
                child: ListTile(
                  leading: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Color(0xFFEF4444),
                  ),
                  title: Text(
                    'Download PDF',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'print',
                child: ListTile(
                  leading: Icon(Icons.print_rounded, color: Color(0xFF0EA5E9)),
                  title: Text(
                    'Print Report',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share_rounded, color: Color(0xFF10B981)),
                  title: Text(
                    'Share Report',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(summary),
            const SizedBox(height: 20),
            _buildIncomeExpenseChart(monthlyData),
            const SizedBox(height: 16),
            _buildProfitTrendChart(monthlyData),
            const SizedBox(height: 16),
            _buildModulePieChart(moduleTotals),
            const SizedBox(height: 16),
            _buildAllModulesBreakdown(moduleTotals),
            const SizedBox(height: 16),
            _buildProductionStats(p),
          ],
        ),
      ),
    );
  }

  // ── Data helpers ──────────────────────────────────────────────────────────

  double _getKey(Map<String, dynamic> flat, String key) {
    final v = flat[key];
    if (v != null) {
      final n = double.tryParse('$v');
      if (n != null && n > 0) return n;
    }
    return 0;
  }

  /// Returns (income, expense) for a single record, handling hybrid sheets
  (double, double) _getAmounts(DailyRecord r) {
    final flat = r.toFlatMap();
    final sheet = r.sheetType;

    // Hybrid sheets with both income and expense fields
    if (sheet == 'trips') return (_getKey(flat, 'Income'), _getKey(flat, 'Expenses'));
    if (sheet == 'daily_entries') return (_getKey(flat, 'Credit'), _getKey(flat, 'Debit'));
    if (sheet == 'balances') return (_getKey(flat, 'Total Credit'), _getKey(flat, 'Total Debit'));
    if (sheet == 'bank_reconciliation') return (_getKey(flat, 'Bank Balance'), _getKey(flat, 'Difference'));
    if (sheet == 'debits') return (_getKey(flat, 'Credit'), _getKey(flat, 'Debit'));
    if (sheet == 'credits') return (_getKey(flat, 'Credit'), _getKey(flat, 'Debit'));

    // Standard single-amount sheets
    const moneyFields = <String>['Total', 'Amount', 'Cost', 'Price', 'Income', 'Paid', 'Total Value', 'Expenses', 'Profit', 'Unit Cost'];
    for (final key in moneyFields) {
      final v = flat[key];
      if (v != null) {
        final n = double.tryParse('$v');
        if (n != null && n > 0) {
          if (_isExpenseSheet(sheet)) return (0, n);
          return (n, 0);
        }
      }
    }
    return (0, 0);
  }

  bool _isExpenseSheet(String sheet) {
    return ['feed', 'vet', 'labour', 'housing', 'overheads', 'expense', 'cost', 'feed_consumption', 'maintenance', 'fuel', 'supplies', 'health', 'fertilizer', 'pest_control', 'planting', 'debits'].contains(sheet);
  }

  Map<String, _MonthData> _computeMonthlyData(List<DailyRecord> records) {
    final map = <String, _MonthData>{};
    for (final r in records) {
      final month = '${r.date.year}-${r.date.month.toString().padLeft(2, '0')}';
      final (inc, exp) = _getAmounts(r);
      if (inc <= 0 && exp <= 0) continue;
      final data = map.putIfAbsent(month, () => _MonthData(month, 0, 0));
      data.income += inc;
      data.expenses += exp;
    }
    return map;
  }

  _Summary _computeSummary(List<DailyRecord> records) {
    double income = 0, expenses = 0;
    for (final r in records) {
      final (inc, exp) = _getAmounts(r);
      income += inc;
      expenses += exp;
    }
    return _Summary(income, expenses);
  }

  Map<String, _ModuleTotal> _computeModuleTotals(List<DailyRecord> records) {
    final map = <String, _ModuleTotal>{};
    for (final r in records) {
      final (inc, exp) = _getAmounts(r);
      if (inc <= 0 && exp <= 0) continue;
      final data = map.putIfAbsent(r.module, () => _ModuleTotal(r.module, 0, 0));
      data.income += inc;
      data.expenses += exp;
    }
    return map;
  }

  // ── Builders ──────────────────────────────────────────────────────────────

  Widget _buildSummaryCards(_Summary s) {
    final profit = s.income - s.expenses;
    final margin = s.income > 0 ? (profit / s.income * 100) : 0.0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&w=600&q=80',
          ),
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
            _statRow(
              'Total Revenue',
              'KES ${_fmt(s.income)}',
              const Color(0xFF10B981),
            ),
            const SizedBox(height: 6),
            _statRow(
              'Total Expenses',
              'KES ${_fmt(s.expenses)}',
              const Color(0xFFEF4444),
            ),
            const Divider(color: Colors.white24, height: 16),
            _statRow(
              'Net Profit',
              'KES ${_fmt(profit)}',
              profit >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
            _statRow(
              'Profit Margin',
              '${margin.toStringAsFixed(1)}%',
              const Color(0xFF0EA5E9),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseChart(Map<String, _MonthData> monthly) {
    if (monthly.isEmpty)
      return _emptyChartCard(
        'Income vs Expenses',
        Icons.bar_chart_rounded,
        const Color(0xFF10B981),
      );
    final sorted = monthly.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final labels = sorted.map((e) => e.key.substring(5)).toList();
    final maxVal = sorted.fold<double>(
      0,
      (m, e) =>
          [m, e.value.income, e.value.expenses].reduce((a, b) => a > b ? a : b),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  size: 16,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Income vs Expenses',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal * 1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBorderRadius: BorderRadius.circular(8),
                    getTooltipItem: (g, gIndex, bar, barIndex) =>
                        BarTooltipItem(
                          _fmt(bar.toY),
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, m) => v.toInt() < labels.length
                          ? Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                labels[v.toInt()],
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (v, m) => Text(
                        _fmt(v),
                        style: const TextStyle(
                          fontSize: 9,
                          fontFamily: 'Poppins',
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxVal > 0 ? maxVal / 4 : 1,
                  getDrawingHorizontalLine: (v) =>
                      FlLine(color: const Color(0xFFF1F5F9), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  sorted.length,
                  (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: sorted[i].value.income,
                        color: const Color(0xFF10B981),
                        width: 10,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: sorted[i].value.expenses,
                        color: const Color(0xFFEF4444),
                        width: 10,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(const Color(0xFF10B981), 'Income'),
              const SizedBox(width: 20),
              _legendDot(const Color(0xFFEF4444), 'Expenses'),
            ],
          ),
        ],
      ),
    );
  }

  navbar() {}

  Widget _buildProfitTrendChart(Map<String, _MonthData> monthly) {
    if (monthly.isEmpty)
      return _emptyChartCard(
        'Profit Trend',
        Icons.trending_up_rounded,
        const Color(0xFF8B5CF6),
      );
    final sorted = monthly.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final labels = sorted.map((e) => e.key.substring(5)).toList();
    final profits = sorted
        .map((e) => e.value.income - e.value.expenses)
        .toList();
    final minVal = profits.fold<double>(0, (m, v) => v < m ? v : m);
    final maxVal = profits.fold<double>(0, (m, v) => v > m ? v : m);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  size: 16,
                  color: Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Profit Trend',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: minVal < 0 ? minVal * 1.3 : 0,
                maxY: maxVal > 0 ? maxVal * 1.3 : 1,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBorderRadius: BorderRadius.circular(8),
                    getTooltipItems: (spots) => spots
                        .map(
                          (s) => LineTooltipItem(
                            'KES ${_fmt(s.y)}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, m) => v.toInt() < labels.length
                          ? Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                labels[v.toInt()],
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (v, m) => Text(
                        _fmt(v),
                        style: const TextStyle(
                          fontSize: 9,
                          fontFamily: 'Poppins',
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxVal > 0 ? (maxVal - minVal) / 4 : 1,
                  getDrawingHorizontalLine: (v) =>
                      FlLine(color: const Color(0xFFF1F5F9), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      profits.length,
                      (i) => FlSpot(i.toDouble(), profits[i]),
                    ),
                    isCurved: true,
                    color: const Color(0xFF8B5CF6),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (s, percent, bar, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2.5,
                            strokeColor: const Color(0xFF8B5CF6),
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_legendDot(const Color(0xFF8B5CF6), 'Net Profit/Loss')],
          ),
        ],
      ),
    );
  }

  Widget _buildModulePieChart(Map<String, _ModuleTotal> moduleTotals) {
    if (moduleTotals.isEmpty)
      return _emptyChartCard(
        'Revenue by Module',
        Icons.pie_chart_rounded,
        const Color(0xFFF59E0B),
      );
    final total = moduleTotals.values.fold<double>(0, (s, m) => s + m.income);
    if (total <= 0)
      return _emptyChartCard(
        'Revenue by Module',
        Icons.pie_chart_rounded,
        const Color(0xFFF59E0B),
      );

    final sorted = moduleTotals.entries.toList()
      ..sort((a, b) => b.value.income.compareTo(a.value.income));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.pie_chart_rounded,
                  size: 16,
                  color: Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Revenue by Module',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
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
                    sections: sorted
                        .map(
                          (e) => PieChartSectionData(
                            value: e.value.income,
                            color: ModuleConfig.moduleColor(e.key),
                            radius: 50,
                            title:
                                '${(e.value.income / total * 100).toStringAsFixed(0)}%',
                            titleStyle: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sorted
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: ModuleConfig.moduleColor(e.key),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  ModuleConfig.moduleLabel(e.key),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF475569),
                                  ),
                                ),
                              ),
                              Text(
                                '${(e.value.income / total * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllModulesBreakdown(Map<String, _ModuleTotal> moduleTotals) {
    if (moduleTotals.isEmpty)
      return _emptyChartCard(
        'Module Breakdown',
        Icons.account_balance_rounded,
        const Color(0xFF3B82F6),
      );
    final sorted = moduleTotals.entries.toList()
      ..sort(
        (a, b) => (b.value.income + b.value.expenses).compareTo(
          a.value.income + a.value.expenses,
        ),
      );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  size: 16,
                  color: Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'All Modules Breakdown',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...sorted.map((e) => _moduleRow(e.key, e.value)),
        ],
      ),
    );
  }

  Widget _moduleRow(String module, _ModuleTotal t) {
    final color = ModuleConfig.moduleColor(module);
    final label = ModuleConfig.moduleLabel(module);
    final profit = t.income - t.expenses;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(ModuleConfig.moduleIcon(module), size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Inc: KES ${_fmt(t.income)}  Exp: KES ${_fmt(t.expenses)}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF94A3B8),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Text(
            'KES ${_fmt(profit)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
              color: profit >= 0
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductionStats(PoultryProvider p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.egg_rounded,
                  size: 16,
                  color: Color(0xFF0EA5E9),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Poultry Production',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ReportRow(
            'Active Birds',
            '${p.totalActiveBirds}',
            const Color(0xFF10B981),
          ),
          _ReportRow(
            'Laying Rate',
            '${p.avgLayerRate.toStringAsFixed(1)}%',
            const Color(0xFFF59E0B),
          ),
          _ReportRow(
            'Kienyeji Rate',
            '${p.avgKienyejiRate.toStringAsFixed(1)}%',
            const Color(0xFFF97316),
          ),
          _ReportRow(
            'Egg Income',
            'KES ${_fmt(p.totalEggIncome)}',
            const Color(0xFF14B8A6),
          ),
          _ReportRow(
            'Bird Sales',
            'KES ${_fmt(p.totalBirdSales)}',
            const Color(0xFF0EA5E9),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, Color color) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontFamily: 'Poppins',
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _emptyChartCard(String title, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color.withValues(alpha: 0.3)),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Add records to see chart',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF94A3B8),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double v) => v >= 1000000
      ? '${(v / 1000000).toStringAsFixed(1)}M'
      : v >= 1000
      ? '${(v / 1000).toStringAsFixed(1)}K'
      : v.toStringAsFixed(0);

  void _handleExport(
    BuildContext context,
    String action,
    List<DailyRecord> records,
    _Summary summary,
    Map<String, _MonthData> monthly,
    Map<String, _ModuleTotal> moduleTotals,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final pdfBytes = await _generatePdf(summary, monthly, moduleTotals);
      if (!context.mounted) return;
      Navigator.pop(context);

      if (action == 'pdf') {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/agri_ledger_report.pdf');
        await file.writeAsBytes(pdfBytes);
        Share.shareXFiles([XFile(file.path)], text: 'AgriLedger Report');
      } else if (action == 'print') {
        await Printing.layoutPdf(onLayout: (_) => pdfBytes);
      } else if (action == 'share') {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/agri_ledger_report.pdf');
        await file.writeAsBytes(pdfBytes);
        Share.shareXFiles([XFile(file.path)], text: 'AgriLedger Report');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Future<Uint8List> _generatePdf(
    _Summary summary,
    Map<String, _MonthData> monthly,
    Map<String, _ModuleTotal> moduleTotals,
  ) async {
    final pdf = pw.Document();
    const green = PdfColor.fromInt(0xFF1B8A3C);
    const dark = PdfColor.fromInt(0xFF0F172A);
    const muted = PdfColor.fromInt(0xFF64748B);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (ctx) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'AgriLedger Report',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: green,
              ),
            ),
          ),
          pw.Paragraph(
            text:
                'Generated: ${DateTime.now().toLocal().toString().substring(0, 16)}',
            style: pw.TextStyle(color: muted, fontSize: 10),
          ),
          pw.SizedBox(height: 16),

          pw.Header(level: 1, text: 'Financial Summary'),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            headerDecoration: pw.BoxDecoration(color: green),
            cellStyle: pw.TextStyle(fontSize: 10),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
            },
            headers: ['Metric', 'Value'],
            data: [
              ['Total Revenue', 'KES ${summary.income.toStringAsFixed(2)}'],
              ['Total Expenses', 'KES ${summary.expenses.toStringAsFixed(2)}'],
              [
                'Net Profit',
                'KES ${(summary.income - summary.expenses).toStringAsFixed(2)}',
              ],
              [
                'Profit Margin',
                summary.income > 0
                    ? '${((summary.income - summary.expenses) / summary.income * 100).toStringAsFixed(1)}%'
                    : '0.0%',
              ],
            ],
          ),
          pw.SizedBox(height: 24),

          pw.Header(level: 1, text: 'Monthly Breakdown'),
          () {
            final entries = monthly.entries.toList();
            entries.sort((a, b) => a.key.compareTo(b.key));
            final rows = entries.map((e) {
              final profit = e.value.income - e.value.expenses;
              return <dynamic>[
                e.key,
                e.value.income.toStringAsFixed(2),
                e.value.expenses.toStringAsFixed(2),
                profit.toStringAsFixed(2),
              ];
            }).toList();
            return pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: pw.BoxDecoration(color: green),
              cellStyle: pw.TextStyle(fontSize: 9),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
              },
              headers: ['Month', 'Income', 'Expenses', 'Profit'],
              data: rows,
            );
          }(),
          pw.SizedBox(height: 24),

          pw.Header(level: 1, text: 'Module Breakdown'),
          () {
            final entries = moduleTotals.entries.toList();
            entries.sort(
              (a, b) => (b.value.income + b.value.expenses).compareTo(
                a.value.income + a.value.expenses,
              ),
            );
            final rows = entries.map((e) {
              final profit = e.value.income - e.value.expenses;
              return <dynamic>[
                ModuleConfig.moduleLabel(e.key),
                e.value.income.toStringAsFixed(2),
                e.value.expenses.toStringAsFixed(2),
                profit.toStringAsFixed(2),
              ];
            }).toList();
            return pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: pw.BoxDecoration(color: green),
              cellStyle: pw.TextStyle(fontSize: 9),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
              },
              headers: ['Module', 'Income', 'Expenses', 'Profit'],
              data: rows,
            );
          }(),
          pw.SizedBox(height: 24),

          pw.Header(level: 2, text: 'Notes'),
          pw.Paragraph(
            text:
                'This report was automatically generated by AgriLedger. All figures are in Kenyan Shillings (KES). Only approved records are included.',
            style: pw.TextStyle(color: muted, fontSize: 8),
          ),
        ],
      ),
    );

    return pdf.save();
  }
}

class _MonthData {
  final String month;
  double income, expenses;
  _MonthData(this.month, this.income, this.expenses);
}

class _Summary {
  final double income, expenses;
  _Summary(this.income, this.expenses);
}

class _ModuleTotal {
  final String module;
  double income, expenses;
  _ModuleTotal(this.module, this.income, this.expenses);
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
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
