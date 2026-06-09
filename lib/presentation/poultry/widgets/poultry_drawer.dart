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

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      (user?.name ?? 'U').substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                  accountName: Text(user?.name ?? 'User'),
                  accountEmail: Text(user?.email ?? ''),
                ),
                _DrawerSection(
                  title: 'OVERVIEW',
                  children: [
                    _DrawerTile(
                      icon: Icons.dashboard,
                      label: 'Dashboard',
                      subtitle: '${poultry.totalActiveBirds} birds',
                      onTap: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                    ),
                    _DrawerTile(
                      icon: Icons.settings,
                      label: 'Farm Setup',
                      onTap: () => Navigator.pushReplacementNamed(context, '/farm-config'),
                    ),
                    _DrawerTile(
                      icon: Icons.menu_book,
                      label: 'User Manual',
                      onTap: () => Navigator.pushReplacementNamed(context, '/user-manual'),
                    ),
                  ],
                ),
                _DrawerSection(
                  title: 'FLOCK & PRODUCTION',
                  children: [
                    _DrawerTile(
                      icon: Icons.pets,
                      label: 'Flock Register',
                      onTap: () => Navigator.pushReplacementNamed(context, '/flock-register'),
                    ),
                    _DrawerTile(
                      icon: Icons.inventory_2,
                      label: 'Production Log',
                      onTap: () => Navigator.pushReplacementNamed(context, '/production-log'),
                    ),
                    _DrawerTile(
                      icon: Icons.analytics,
                      label: 'Batch Performance',
                      onTap: () => Navigator.pushReplacementNamed(context, '/batch-performance'),
                    ),
                  ],
                ),
                _DrawerSection(
                  title: 'SALES & INCOME',
                  children: [
                    _DrawerTile(
                      icon: Icons.payments,
                      label: 'Sales Tracker',
                      onTap: () => Navigator.pushReplacementNamed(context, '/sales'),
                    ),
                    _DrawerTile(
                      icon: Icons.attach_money,
                      label: 'Other Income',
                      onTap: () => Navigator.pushReplacementNamed(context, '/other-income'),
                    ),
                  ],
                ),
                _DrawerSection(
                  title: 'EXPENSES',
                  children: [
                    _DrawerTile(
                      icon: Icons.restaurant,
                      label: 'Feed Expenses',
                      onTap: () => Navigator.pushReplacementNamed(context, '/feed-expenses'),
                    ),
                    _DrawerTile(
                      icon: Icons.bar_chart,
                      label: 'Feed Consumption',
                      onTap: () => Navigator.pushReplacementNamed(context, '/feed-consumption'),
                    ),
                    _DrawerTile(
                      icon: Icons.medical_services,
                      label: 'Vet & Health',
                      onTap: () => Navigator.pushReplacementNamed(context, '/vet-health'),
                    ),
                    _DrawerTile(
                      icon: Icons.warning_amber,
                      label: 'Mortality Log',
                      onTap: () => Navigator.pushReplacementNamed(context, '/mortality-log'),
                    ),
                    _DrawerTile(
                      icon: Icons.home_repair_service,
                      label: 'Housing & Equipment',
                      onTap: () => Navigator.pushReplacementNamed(context, '/housing-expenses'),
                    ),
                    _DrawerTile(
                      icon: Icons.people,
                      label: 'Labour & Staffing',
                      onTap: () => Navigator.pushReplacementNamed(context, '/labour'),
                    ),
                    _DrawerTile(
                      icon: Icons.build,
                      label: 'Operations & Overheads',
                      onTap: () => Navigator.pushReplacementNamed(context, '/overheads'),
                    ),
                  ],
                ),
                _DrawerSection(
                  title: 'FINANCIALS',
                  children: [
                    _DrawerTile(
                      icon: Icons.calendar_month,
                      label: 'Monthly Summary',
                      onTap: () => Navigator.pushReplacementNamed(context, '/monthly-summary'),
                    ),
                    _DrawerTile(
                      icon: Icons.account_balance,
                      label: 'Annual P&L',
                      onTap: () => Navigator.pushReplacementNamed(context, '/annual-pl'),
                    ),
                  ],
                ),
                _DrawerSection(
                  title: 'INVENTORY & ASSETS',
                  children: [
                    _DrawerTile(
                      icon: Icons.inventory,
                      label: 'Inventory & Supplies',
                      onTap: () => Navigator.pushReplacementNamed(context, '/inventory'),
                    ),
                    _DrawerTile(
                      icon: Icons.business,
                      label: 'Asset Register',
                      onTap: () => Navigator.pushReplacementNamed(context, '/asset-register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              border: Border(top: BorderSide(color: Color(0xFFE8F5ED))),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Poultry Manager v1.0',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DrawerSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGreen,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textDark),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: const TextStyle(fontSize: 11, color: AppColors.textMuted))
          : null,
      dense: true,
      onTap: onTap,
    );
  }
}
