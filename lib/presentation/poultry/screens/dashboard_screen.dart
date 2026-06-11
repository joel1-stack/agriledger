import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/daily_record/daily_record_provider.dart';
import '../../../state/auth/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/module_config.dart';
import '../widgets/poultry_drawer.dart';
import '../widgets/quick_add_sheet.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final records = Provider.of<DailyRecordProvider>(context);
    final user = auth.userModel;
    final isSuperAdmin = auth.isSuperAdmin;
    final isViewAdmin = auth.isViewAdmin;
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
          SliverToBoxAdapter(
            child: Container(
              height: 280,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=800&q=80'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0x30000000)],
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
                                color: Color(0x25FFFFFF),
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
                        Text(
                          'Hello, ${user?.name ?? 'Farmer'}',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Poppins'),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${records.totalPending} pending approvals across ${ModuleConfig.moduleIds.length} modules',
                          style: const TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'Poppins'),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _QuickStat(label: 'Records', value: '${records.records.length}', color: Colors.white),
                            _QuickStat(label: 'Pending', value: '${records.totalPending}', color: Colors.white),
                            _QuickStat(label: 'Modules', value: '${ModuleConfig.moduleIds.length}', color: Colors.white),
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
                  const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  _buildActionCards(context, isSuperAdmin),
                  const SizedBox(height: 24),
                  const Text('Modules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  _buildModuleCards(context),
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

  Widget _buildActionCards(BuildContext context, bool isSuperAdmin) {
    final cards = <_ActionCardData>[
      _ActionCardData('All Modules', Icons.dashboard_rounded, AppColors.cardGradientGreen, '/modules'),
      _ActionCardData('Approvals', Icons.people_rounded, AppColors.cardGradientOrange, '/manager/approvals'),
      _ActionCardData('Poultry', Icons.pets_rounded, AppColors.cardGradientBlue, {'module': 'poultry'}),
      _ActionCardData('Dairy', Icons.agriculture_rounded, AppColors.cardGradientAmber, {'module': 'dairy'}),
    ];
    if (isSuperAdmin) {
      cards.insert(2, _ActionCardData('User Management', Icons.settings_rounded, const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)]), '/admin/users'));
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
            BoxShadow(color: card.gradient.colors.first.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 6)),
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
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(12)),
                child: Icon(card.icon, color: Colors.white, size: 24),
              ),
              Text(card.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleCards(BuildContext context) {
    const moduleImages = {
      'poultry': 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=400&q=80',
      'dairy': 'https://images.unsplash.com/photo-1564135625714-0e0a2e1b39f9?w=400&q=80',
      'crops': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=400&q=80',
      'livestock': 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=400&q=80',
      'property': 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=400&q=80',
      'transport': 'https://images.unsplash.com/photo-1519003722824-194d4455a60c?w=400&q=80',
      'cashbook': 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=400&q=80',
      'inventory': 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=400&q=80',
      'journal': 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=400&q=80',
      'contracts': 'https://images.unsplash.com/photo-1507925921958-8a62f3d1a50d?w=400&q=80',
    };
    const overlayColors = {
      'poultry': Color(0xCC1B8A3C),
      'dairy': Color(0xCC0EA5E9),
      'crops': Color(0xCCF59E0B),
      'livestock': Color(0xCCEF4444),
      'property': Color(0xCC8B5CF6),
      'transport': Color(0xCC14B8A6),
      'cashbook': Color(0xCC1B8A3C),
      'inventory': Color(0xCCEC4899),
      'journal': Color(0xCCF43F5E),
      'contracts': Color(0xCC06B6D4),
    };
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: ModuleConfig.moduleIds.length,
      itemBuilder: (_, i) {
        final id = ModuleConfig.moduleIds[i];
        final mod = ModuleConfig.getModule(id);
        final imgUrl = moduleImages[id] ?? '';
        final overlay = overlayColors[id] ?? const Color(0xCC1B8A3C);
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/sheets', arguments: {'module': id}),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: imgUrl.isNotEmpty ? DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover) : null,
              boxShadow: [
                BoxShadow(color: overlay.withValues(alpha: 0.4), blurRadius: 14, offset: const Offset(0, 6)),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [overlay.withValues(alpha: 0.85), overlay]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(12)),
                      child: Icon(mod.icon, color: Colors.white, size: 24),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mod.label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                        Text('${mod.sheets.length} sheets', style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Poppins')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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

class _ActionCardData {
  final String title;
  final IconData icon;
  final Gradient gradient;
  final dynamic route;
  _ActionCardData(this.title, this.icon, this.gradient, this.route);
}
