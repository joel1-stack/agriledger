import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/auth/auth_provider.dart';
import '../../../state/poultry/poultry_provider.dart';
import '../../../core/theme/app_theme.dart';

class PoultryDrawer extends StatelessWidget {
  const PoultryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final poultry = Provider.of<PoultryProvider>(context);
    final user = auth.userModel;
    final isSuperAdmin = auth.isSuperAdmin;
    final isViewAdmin = auth.isViewAdmin;
    final canEdit = isSuperAdmin;

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // ── User Profile Header ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0D5C26), Color(0xFF1B8A3C)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                        child: Text(
                          (user?.name ?? 'U').substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'User',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.email ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.8),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSuperAdmin ? Icons.shield_rounded : (isViewAdmin ? Icons.visibility_rounded : Icons.person_rounded),
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isSuperAdmin ? 'Super Admin' : (isViewAdmin ? 'View Admin' : 'General User'),
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${poultry.totalActiveBirds} birds',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // ── OVERVIEW ──
                  _buildSection('OVERVIEW', [
                    _DrawerItem(
                      icon: Icons.dashboard_rounded,
                      label: 'Dashboard',
                      onTap: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                    ),
                    if (isSuperAdmin)
                      _DrawerItem(
                        icon: Icons.settings_rounded,
                        label: 'Farm Setup',
                        onTap: () => Navigator.pushReplacementNamed(context, '/farm-config'),
                      ),
                    _DrawerItem(
                      icon: Icons.menu_book_rounded,
                      label: 'User Manual',
                      onTap: () => Navigator.pushReplacementNamed(context, '/user-manual'),
                    ),
                  ]),

                  // ── FLOCK & PRODUCTION ──
                  _buildSection('FLOCK & PRODUCTION', [
                    _DrawerItem(
                      icon: Icons.pets_rounded,
                      label: 'Flock Register',
                      badge: '${poultry.totalActiveBirds}',
                      onTap: () => Navigator.pushReplacementNamed(context, '/flock-register'),
                    ),
                    _DrawerItem(
                      icon: Icons.egg_alt_rounded,
                      label: 'Production Log',
                      onTap: () => Navigator.pushReplacementNamed(context, '/production-log'),
                    ),
                    _DrawerItem(
                      icon: Icons.analytics_rounded,
                      label: 'Batch Performance',
                      onTap: () => Navigator.pushReplacementNamed(context, '/batch-performance'),
                    ),
                  ]),

                  // ── SALES & INCOME ──
                  _buildSection('SALES & INCOME', [
                    _DrawerItem(
                      icon: Icons.payments_rounded,
                      label: 'Sales Tracker',
                      onTap: () => Navigator.pushReplacementNamed(context, '/sales'),
                    ),
                    _DrawerItem(
                      icon: Icons.attach_money_rounded,
                      label: 'Other Income',
                      onTap: () => Navigator.pushReplacementNamed(context, '/other-income'),
                    ),
                  ]),

                  // ── EXPENSES ──
                  _buildSection('EXPENSES', [
                    _DrawerItem(
                      icon: Icons.restaurant_rounded,
                      label: 'Feed Expenses',
                      onTap: () => Navigator.pushReplacementNamed(context, '/feed-expenses'),
                    ),
                    _DrawerItem(
                      icon: Icons.bar_chart_rounded,
                      label: 'Feed Consumption',
                      onTap: () => Navigator.pushReplacementNamed(context, '/feed-consumption'),
                    ),
                    _DrawerItem(
                      icon: Icons.medical_services_rounded,
                      label: 'Vet & Health',
                      onTap: () => Navigator.pushReplacementNamed(context, '/vet-health'),
                    ),
                    _DrawerItem(
                      icon: Icons.warning_amber_rounded,
                      label: 'Mortality Log',
                      onTap: () => Navigator.pushReplacementNamed(context, '/mortality-log'),
                    ),
                    _DrawerItem(
                      icon: Icons.home_repair_service_rounded,
                      label: 'Housing & Equipment',
                      onTap: () => Navigator.pushReplacementNamed(context, '/housing-expenses'),
                    ),
                    _DrawerItem(
                      icon: Icons.people_rounded,
                      label: 'Labour & Staffing',
                      onTap: () => Navigator.pushReplacementNamed(context, '/labour'),
                    ),
                    _DrawerItem(
                      icon: Icons.build_rounded,
                      label: 'Operations & Overheads',
                      onTap: () => Navigator.pushReplacementNamed(context, '/overheads'),
                    ),
                  ]),

                  // ── FINANCIALS (Admin only) ──
                  if (isSuperAdmin || isViewAdmin)
                    _buildSection('FINANCIALS', [
                      _DrawerItem(
                        icon: Icons.calendar_month_rounded,
                        label: 'Monthly Summary',
                        onTap: () => Navigator.pushReplacementNamed(context, '/monthly-summary'),
                      ),
                      _DrawerItem(
                        icon: Icons.account_balance_rounded,
                        label: 'Annual P&L',
                        onTap: () => Navigator.pushReplacementNamed(context, '/annual-pl'),
                      ),
                    ]),

                  // ── INVENTORY & ASSETS (Super Admin only) ──
                  if (isSuperAdmin)
                    _buildSection('INVENTORY & ASSETS', [
                      _DrawerItem(
                        icon: Icons.inventory_2_rounded,
                        label: 'Inventory & Supplies',
                        onTap: () => Navigator.pushReplacementNamed(context, '/inventory'),
                      ),
                      _DrawerItem(
                        icon: Icons.business_rounded,
                        label: 'Asset Register',
                        onTap: () => Navigator.pushReplacementNamed(context, '/asset-register'),
                      ),
                    ]),
                ],
              ),
            ),

            // ── Footer ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE8F5ED), width: 1)),
              ),
              child: Column(
                children: [
                  Text(
                    'Poultry Manager v1.0',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await auth.signOut();
                        if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accentRed,
                        side: const BorderSide(color: AppColors.accentRed, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('Sign Out', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGreen,
              letterSpacing: 1.2,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        ...children,
        const Divider(height: 1, indent: 20, endIndent: 20),
      ],
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textMedium, size: 22),
      title: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark, fontFamily: 'Poppins'),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge!,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
              ),
            )
          : const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      onTap: onTap,
    );
  }
}
