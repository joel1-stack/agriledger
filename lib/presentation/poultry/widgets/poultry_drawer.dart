import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/auth/auth_provider.dart';
import '../../../state/poultry/poultry_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../config/sheet_config.dart';

class PoultryDrawer extends StatelessWidget {
  const PoultryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final poultry = Provider.of<PoultryProvider>(context);
    final user = auth.userModel;
    final isSuper = auth.isSuperAdmin;
    final isMgr = auth.isManager;
    final isWkr = auth.isWorker;

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // User Header
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
                        radius: 26,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: Text(
                          (user?.name ?? 'U').substring(0, 1).toUpperCase(),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.name ?? 'User', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Poppins')),
                            Text(user?.email ?? '', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8), fontFamily: 'Poppins'), overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          isSuper ? 'Super Admin' : (isMgr ? 'Manager' : 'Worker'),
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('${poultry.totalActiveBirds} birds', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 6),
                children: [
                  _Section('MAIN', [
                    _Item(Icons.dashboard_rounded, 'Dashboard', () => Navigator.pushReplacementNamed(context, '/dashboard')),
                    if (isSuper || isMgr)
                      _Item(Icons.people_rounded, 'Approvals', () => Navigator.pushReplacementNamed(context, '/manager/approvals')),
                  ]),

                  _Section('SHEETS', [
                    ...birdTypes.map((bt) => _Item(
                          birdTypeIcons[bt] ?? Icons.description,
                          _cap(bt),
                          () => Navigator.pushReplacementNamed(context, '/sheets', arguments: {'birdType': bt}),
                        )),
                  ]),

                  if (isSuper || isMgr)
                    _Section('MANAGEMENT', [
                      if (isSuper)
                        _Item(Icons.people_rounded, 'Users', () => Navigator.pushReplacementNamed(context, '/admin/users')),
                      _Item(Icons.pets_rounded, 'Flocks', () => Navigator.pushReplacementNamed(context, '/flock-register')),
                    ]),

                  if (isSuper)
                    _Section('REPORTS', [
                      _Item(Icons.assessment_rounded, 'Reports', () => Navigator.pushReplacementNamed(context, '/admin/reports')),
                    ]),

                  if (isWkr)
                    _Section('WORKER', [
                      _Item(Icons.home_rounded, 'My Dashboard', () => Navigator.pushReplacementNamed(context, '/worker/dashboard')),
                      _Item(Icons.history_rounded, 'My History', () => Navigator.pushReplacementNamed(context, '/worker/history')),
                    ]),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE8F5ED)))),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await auth.signOut();
                    if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentRed,
                    side: const BorderSide(color: AppColors.accentRed),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Sign Out', style: TextStyle(fontSize: 13)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _cap(String s) => s[0].toUpperCase() + s.substring(1);
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section(this.title, this.children);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryGreen, letterSpacing: 1.2, fontFamily: 'Poppins')),
        ),
        ...children,
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _Item(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textMedium, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'Poppins', color: AppColors.textDark)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 16),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      onTap: onTap,
    );
  }
}
