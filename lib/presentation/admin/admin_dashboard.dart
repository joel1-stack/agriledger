import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/module_config.dart';
import '../../state/daily_record/daily_record_provider.dart';
import '../../state/auth/auth_provider.dart';
import '../poultry/widgets/poultry_drawer.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DailyRecordProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Sam K'),
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
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=800&q=80'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0x55000000)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                            backgroundColor: const Color(0x40FFFFFF),
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
                              const Text('Super Admin • All Modules', style: TextStyle(fontSize: 12, color: Colors.white70, fontFamily: 'Poppins')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        _MiniStat('Total Records', '${provider.records.length}', Colors.white),
                        _MiniStat('Pending', '${provider.totalPending}', Colors.white),
                        _MiniStat('Modules', '${ModuleConfig.moduleIds.length}', Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Modules', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark, fontFamily: 'Poppins')),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: ModuleConfig.moduleIds.map((id) {
                final mod = ModuleConfig.getModule(id);
                final pendingCount = provider.pendingCount(id);
                return _StatCard(
                  mod.label,
                  '$pendingCount pending',
                  mod.icon,
                  LinearGradient(colors: [mod.color, mod.color.withValues(alpha: 0.7)]),
                  () => Navigator.pushNamed(context, '/sheets', arguments: {'module': id}),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text('Approval Queue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark, fontFamily: 'Poppins')),
            const SizedBox(height: 12),
            ...ModuleConfig.moduleIds.where((mid) => provider.pendingCount(mid) > 0).map((id) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, '/manager/approvals'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          Icon(ModuleConfig.moduleIcon(id), color: ModuleConfig.moduleColor(id)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(ModuleConfig.moduleLabel(id), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: AppColors.textDark)),
                          ),
                          Text('${provider.pendingCount(id)} pending', style: const TextStyle(fontSize: 12, color: AppColors.accentOrange)),
                          const Icon(Icons.chevron_right, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 20),
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
        decoration: BoxDecoration(color: const Color(0x30FFFFFF), borderRadius: BorderRadius.circular(10)),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: Colors.white, size: 22),
          const Spacer(),
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.white70, fontFamily: 'Poppins')),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Poppins')),
        ]),
      ),
    );
  }
}
