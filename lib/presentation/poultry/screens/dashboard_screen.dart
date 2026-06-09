import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/poultry/poultry_provider.dart';
import '../../../state/auth/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/poultry_drawer.dart';
import '../widgets/quick_add_sheet.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final poultry = Provider.of<PoultryProvider>(context);
    final user = auth.userModel;
    final isSuperAdmin = auth.isSuperAdmin;
    final isViewAdmin = auth.isManager;
    final canEdit = auth.canAddEdit;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      drawer: const PoultryDrawer(),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              onPressed: () => _showQuickAdd(context),
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              elevation: 6,
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      body: CustomScrollView(
        slivers: [
          // ── Profile Header with Gradient ──
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0D5C26), Color(0xFF1B8A3C), Color(0xFF27AE60)],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top bar
                      Row(
                        children: [
                          Builder(
                            builder: (ctx) => IconButton(
                              icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
                              onPressed: () => Scaffold.of(ctx).openDrawer(),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSuperAdmin ? Icons.shield : (isViewAdmin ? Icons.visibility : Icons.person),
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isSuperAdmin ? 'Super Admin' : (isViewAdmin ? 'Admin' : 'User'),
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Greeting
                      Text(
                        'Hello, ${user?.name ?? 'Farmer'}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${poultry.totalActiveBirds} active birds across all batches',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.85),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Quick Stats Row
                      Row(
                        children: [
                          _QuickStat(label: 'Income', value: 'KES ${_fmt(poultry.totalRevenue)}', color: Colors.white),
                          _QuickStat(label: 'Expenses', value: 'KES ${_fmt(poultry.totalExpenses)}', color: Colors.white),
                          _QuickStat(label: 'Profit', value: 'KES ${_fmt(poultry.netProfit)}', color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Content Area ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Action Cards ──
                  const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  _buildActionCards(context, isSuperAdmin),
                  const SizedBox(height: 24),

                  // ── Performance Summary ──
                  const Text('Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  _buildPerformanceCards(context, poultry),
                  const SizedBox(height: 24),

                  // ── Monthly Overview ──
                  if (isSuperAdmin || isViewAdmin) ...[
                    const Text('Monthly Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    _buildMonthlyChart(context, poultry),
                  ],
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }

  void _showQuickAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QuickAddSheet(),
    );
  }

  Widget _buildActionCards(BuildContext context, bool isSuperAdmin) {
    final cards = <_ActionCardData>[
      _ActionCardData('Production Log', Icons.egg_alt_rounded, AppColors.cardGradientOrange, {'birdType': 'layers', 'initialSheet': 'eggs'}),
      _ActionCardData('Sales Tracker', Icons.payments_rounded, AppColors.cardGradientBlue, {'birdType': 'layers', 'initialSheet': 'sales'}),
      _ActionCardData('Feed Expenses', Icons.restaurant_rounded, AppColors.cardGradientAmber, {'birdType': 'layers', 'initialSheet': 'feed'}),
      _ActionCardData('Flock Register', Icons.pets_rounded, AppColors.cardGradientGreen, '/flock-register'),
      _ActionCardData('Vet & Health', Icons.medical_services_rounded, const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]), {'birdType': 'layers', 'initialSheet': 'vet'}),
    ];
    if (isSuperAdmin) {
      cards.insert(4, _ActionCardData('Farm Setup', Icons.settings_rounded, const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)]), {'birdType': 'layers', 'initialSheet': 'feed'}));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: cards.length,
      itemBuilder: (_, i) => _buildActionCard(context, cards[i]),
    );
  }

  Widget _buildActionCard(BuildContext context, _ActionCardData card) {
    return GestureDetector(
      onTap: () {
        if (card.route is String) {
          Navigator.pushNamed(context, card.route);
        } else {
          Navigator.pushNamed(context, '/sheets', arguments: card.route);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: card.gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: card.gradient.colors.first.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(card.icon, color: Colors.white, size: 24),
              ),
              Text(
                card.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceCards(BuildContext context, PoultryProvider p) {
    return Row(
      children: [
        Expanded(
          child: _PerformanceCard(
            title: 'Laying Rate',
            value: '${p.avgLayerRate.toStringAsFixed(1)}%',
            icon: Icons.egg_alt_rounded,
            gradient: AppColors.cardGradientOrange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PerformanceCard(
            title: 'Total Birds',
            value: '${p.totalActiveBirds}',
            icon: Icons.pets_rounded,
            gradient: AppColors.cardGradientGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyChart(BuildContext context, PoultryProvider p) {
    final summaries = p.monthlySummaries;
    if (summaries.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.bar_chart_rounded, size: 48, color: AppColors.textMuted),
                const SizedBox(height: 12),
                const Text('No monthly data yet', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: summaries.take(5).map((s) {
            final maxIncome = summaries.map((e) => e.totalIncome).reduce((a, b) => a > b ? a : b);
            final ratio = maxIncome > 0 ? s.totalIncome / maxIncome : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Text(s.month, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 10,
                        backgroundColor: AppColors.backgroundGrey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          s.netPL >= 0 ? AppColors.primaryGreen : AppColors.accentRed,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    child: Text(
                      'KES ${(s.totalIncome / 1000).toStringAsFixed(0)}K',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _QuickStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color.withValues(alpha: 0.8),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Gradient gradient;
  const _PerformanceCard({required this.title, required this.value, required this.icon, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Poppins'),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85), fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }
}

class _ActionCardData {
  final String title;
  final IconData icon;
  final Gradient gradient;
  final dynamic route; // String for named route, Map for /sheets arguments
  _ActionCardData(this.title, this.icon, this.gradient, this.route);
}
