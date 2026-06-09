import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../state/poultry/poultry_provider.dart';
import '../../state/auth/auth_provider.dart';
import '../poultry/widgets/poultry_drawer.dart';
import '../../config/sheet_config.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final poultry = context.watch<PoultryProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Poultry Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_rounded),
            onPressed: () => Navigator.pushNamed(context, '/admin/users'),
          ),
          IconButton(
            icon: const Icon(Icons.assessment_rounded),
            onPressed: () => Navigator.pushNamed(context, '/admin/reports'),
          ),
        ],
      ),
      drawer: const PoultryDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome + Role
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0D5C26), Color(0xFF1B8A3C)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: Text(
                          (auth.displayName.isNotEmpty ? auth.displayName[0] : 'A').toUpperCase(),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome, ${auth.displayName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Poppins')),
                            const Text('Super Admin • Read-Only View', style: TextStyle(fontSize: 12, color: Colors.white70, fontFamily: 'Poppins')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _MiniStat('Total Birds', '${poultry.totalActiveBirds}', Colors.white),
                      _MiniStat('Revenue', 'KES ${_fmt(poultry.totalRevenue)}', Colors.white),
                      _MiniStat('Expenses', 'KES ${_fmt(poultry.totalExpenses)}', Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Overview Grid
            const Text('Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark, fontFamily: 'Poppins')),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _StatCard('Total Birds', '${poultry.totalActiveBirds}', Icons.pets_rounded, AppColors.cardGradientGreen, () {}),
                _StatCard('Mortality Today', '${poultry.totalMortality}', Icons.warning_amber_rounded, AppColors.cardGradientOrange, () {}),
                _StatCard('Egg Income', 'KES ${_fmt(poultry.totalEggIncome)}', Icons.egg_alt_rounded, AppColors.cardGradientAmber, () {}),
                _StatCard('Net Profit', 'KES ${_fmt(poultry.netProfit)}', Icons.account_balance_rounded, AppColors.cardGradientBlue, () {}),
              ],
            ),
            const SizedBox(height: 20),

            // Quick access to sheets
            const Text('Sheets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark, fontFamily: 'Poppins')),
            const SizedBox(height: 12),
            ...birdTypes.map((bt) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, '/sheets', arguments: {'birdType': bt}),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          Icon(birdTypeIcons[bt], color: birdTypeColors[bt]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(_capitalize(bt), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: AppColors.textDark)),
                          ),
                          Text('${allSheets[bt]?.length ?? 0} sheets', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          const Icon(Icons.chevron_right, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  ),
                )),

            const SizedBox(height: 20),
            // Users management link
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/admin/users'),
                icon: const Icon(Icons.people_rounded),
                label: const Text('Manage Users'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  String _fmt(double v) => v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}K' : v.toStringAsFixed(0);
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MiniStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color, fontFamily: 'Poppins')),
            Text(label, style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.8), fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;
  const _StatCard(this.title, this.value, this.icon, this.gradient, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: Colors.white, size: 22),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Poppins')),
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.white70, fontFamily: 'Poppins')),
      ]),
    );
  }
}

