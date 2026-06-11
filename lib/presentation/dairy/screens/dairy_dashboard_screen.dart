import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/daily_record/daily_record_provider.dart';
import '../../../state/auth/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/module_config.dart';
import '../../poultry/widgets/poultry_drawer.dart';
import '../../poultry/widgets/quick_add_sheet.dart';

class DairyDashboardScreen extends StatelessWidget {
  const DairyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final records = Provider.of<DailyRecordProvider>(context);
    final user = auth.userModel;
    final isSuperAdmin = auth.isSuperAdmin;
    final isViewAdmin = auth.isViewAdmin;
    final canEdit = auth.canAddEdit;
    final modColor = const Color(0xFF10B981);
    final dairyRecords = records.recordsByModule('dairy');

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      drawer: const PoultryDrawer(),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              onPressed: () => _showQuickAdd(context),
              backgroundColor: modColor,
              foregroundColor: Colors.white,
              elevation: 6,
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 280,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1523475496151-48c8c6e8dd3a?auto=format&fit=crop&w=800&q=80'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0x40000000)],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                color: const Color(0x25FFFFFF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSuperAdmin ? Icons.shield : (isViewAdmin ? Icons.visibility : Icons.person),
                                    color: Colors.white, size: 14,
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
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.agriculture_rounded, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Dairy',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${dairyRecords.where((r) => r.status == 'pending').length} pending records',
                          style: const TextStyle(fontSize: 14, color: Colors.white70, fontFamily: 'Poppins'),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _QuickStat(label: 'Total', value: '${dairyRecords.length}', color: Colors.white),
                            _QuickStat(label: 'Approved', value: '${dairyRecords.where((r) => r.status == 'approved').length}', color: Colors.white),
                            _QuickStat(label: 'Pending', value: '${dairyRecords.where((r) => r.status == 'pending').length}', color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: modColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.flash_on_rounded, size: 16, color: Color(0xFF10B981)),
                      ),
                      const SizedBox(width: 10),
                      const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontFamily: 'Poppins')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildQuickActions(context, modColor),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: const Color(0xFFF59E0B).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.list_alt_rounded, size: 16, color: Color(0xFF10B981)),
                      ),
                      const SizedBox(width: 10),
                      const Text('Dairy Records', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontFamily: 'Poppins')),
                    ],
                  ),
                  _buildDairySheets(context, modColor),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QuickAddSheet(),
    );
  }

  Widget _buildQuickActions(BuildContext context, Color color) {
    final actions = [
      _ActionData('Milk Records', Icons.coffee_rounded, color, '/sheets', {'module': 'dairy', 'initialSheet': 'milk'}),
      _ActionData('Feed', Icons.grass_rounded, const Color(0xFFF59E0B), '/sheets', {'module': 'dairy', 'initialSheet': 'feed'}),
      _ActionData('Vet Visits', Icons.medical_services_rounded, const Color(0xFFEF4444), '/sheets', {'module': 'dairy', 'initialSheet': 'vet'}),
      _ActionData('Breeding', Icons.biotech_rounded, const Color(0xFF8B5CF6), '/sheets', {'module': 'dairy', 'initialSheet': 'breeding'}),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: actions.length,
      itemBuilder: (_, i) => _buildActionCard(context, actions[i]),
    );
  }

  Widget _buildActionCard(BuildContext context, _ActionData card) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, card.route, arguments: card.args),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1570042225831-d98af757d3e2?w=400&q=80'),
            fit: BoxFit.cover,
          ),
          boxShadow: [BoxShadow(color: card.color.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Colors.transparent, card.color.withValues(alpha: 0.7)],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
                child: Icon(card.icon, color: card.color, size: 22),
              ),
              Text(card.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800, fontFamily: 'Poppins', shadows: [Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2))])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDairySheets(BuildContext context, Color color) {
    final sheets = ModuleConfig.getSheetKeys('dairy').map((s) => _capitalize(s)).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: sheets.length,
      itemBuilder: (_, i) {
        final sheet = sheets[i];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/sheets', arguments: {'module': 'dairy', 'initialSheet': sheet.toLowerCase()}),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.description_rounded, color: color, size: 22),
                  ),
                  Text(sheet, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, fontFamily: 'Poppins', color: Color(0xFF0F172A))),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
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
        decoration: BoxDecoration(color: const Color(0xFFFFFF).withValues(alpha: 0.18), borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color, fontFamily: 'Poppins')),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.8), fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }
}

class _ActionData {
  final String title;
  final IconData icon;
  final Color color;
  final String route;
  final Map<String, dynamic> args;
  _ActionData(this.title, this.icon, this.color, this.route, this.args);
}
