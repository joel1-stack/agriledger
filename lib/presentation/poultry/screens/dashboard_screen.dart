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
                  image: NetworkImage('https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?auto=format&fit=crop&w=800&q=80'),
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: const Color(0xFF0EA5E9).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.flash_on_rounded, size: 16, color: Color(0xFF0EA5E9)),
                      ),
                      const SizedBox(width: 10),
                      const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontFamily: 'Poppins')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildActionCards(context, isSuperAdmin),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: const Color(0xFFF59E0B).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.grid_view_rounded, size: 16, color: Color(0xFFF59E0B)),
                      ),
                      const SizedBox(width: 10),
                      const Text('Farm Modules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontFamily: 'Poppins')),
                    ],
                  ),
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
      _ActionCardData('All Modules', Icons.dashboard_rounded, AppColors.cardGradientGreen, '/modules', 'https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=400&q=80'),
      _ActionCardData('Approvals', Icons.people_rounded, AppColors.cardGradientOrange, '/manager/approvals', 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=400&q=80'),
      _ActionCardData('Poultry', Icons.pets_rounded, AppColors.cardGradientBlue, {'module': 'poultry'}, 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=400&q=80'),
      _ActionCardData('Dairy', Icons.agriculture_rounded, AppColors.cardGradientAmber, {'module': 'dairy'}, 'https://images.unsplash.com/photo-1564135625714-0e0a2e1b39f9?w=400&q=80'),
    ];
    if (isSuperAdmin) {
      cards.insert(2, _ActionCardData('User Management', Icons.settings_rounded, const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)]), '/admin/users', 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400&q=80'));
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
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(image: NetworkImage(card.imageUrl), fit: BoxFit.cover),
            boxShadow: [
              BoxShadow(color: card.gradient.colors.first.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6)),
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
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
                  child: Icon(card.icon, color: card.gradient.colors.first, size: 22),
                ),
                Text(card.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800, fontFamily: 'Poppins', shadows: [Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2)), Shadow(color: Colors.black38, blurRadius: 16, offset: Offset(0, 4))])),
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
      'poultry': Color(0xFF1B8A3C),
      'dairy': Color(0xFF0EA5E9),
      'crops': Color(0xFFF59E0B),
      'livestock': Color(0xFFEF4444),
      'property': Color(0xFF8B5CF6),
      'transport': Color(0xFF14B8A6),
      'cashbook': Color(0xFF059669),
      'inventory': Color(0xFFEC4899),
      'journal': Color(0xFFF43F5E),
      'contracts': Color(0xFF06B6D4),
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
        final color = overlayColors[id] ?? const Color(0xFF1B8A3C);
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/sheets', arguments: {'module': id}),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: imgUrl.isNotEmpty ? DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover) : null,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 5)),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(14)),
                        child: Icon(mod.icon, color: color, size: 22),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mod.label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Poppins', shadows: [Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2)), Shadow(color: Colors.black38, blurRadius: 16, offset: Offset(0, 4))])),
                          const SizedBox(height: 2),
                          Text('${mod.sheets.length} sheets', style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Poppins', shadows: [const Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 2))])),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
  final String imageUrl;
  _ActionCardData(this.title, this.icon, this.gradient, this.route, this.imageUrl);
}
