import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/auth/auth_provider.dart';
import '../../../state/daily_record/daily_record_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/module_config.dart';

class PoultryDrawer extends StatelessWidget {
  const PoultryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final recordProvider = Provider.of<DailyRecordProvider>(context);
    final user = auth.userModel;
    final isSuper = auth.isSuperAdmin;
    final isAdmin = auth.isViewAdmin;
    final isMgr = auth.isManager;
    final isGen = auth.isGeneralUser;

    String roleLabel = 'General User';
    String roleColor = '#10B981';
    if (isSuper) { roleLabel = 'Super Admin'; roleColor = '#8B5CF6'; }
    else if (isAdmin) { roleLabel = 'Admin'; roleColor = '#F59E0B'; }
    else if (isGen) { roleLabel = 'Worker'; roleColor = '#0EA5E9'; }

    return Drawer(
      backgroundColor: const Color(0xFFF8FAFC),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Stack(
                children: [
                  SizedBox(
                    height: 200,
                    child: ClipRRect(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?auto=format&fit=crop&w=400&q=80',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        errorBuilder: (_, __, ___) => Container(height: 200, color: const Color(0xFF1B8A3C)),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xBB0F172A)],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16, left: 16, right: 16,
                    child: Row(
                      children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                          child: ClipOval(
                            child: Image.asset(
                              "assets/images/3D Logo 'sam k' with Nature tru one .png",
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Text(
                                  (user?.name ?? 'U').substring(0, 1).toUpperCase(),
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user?.name ?? 'User', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Poppins', shadows: [Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 2))])),
                              Text(user?.email ?? '', style: const TextStyle(fontSize: 11, color: Colors.white, fontFamily: 'Poppins', shadows: [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1))]), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(roleLabel, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                children: [
                  _drawerItem(Icons.dashboard_rounded, 'Dashboard', const Color(0xFF0EA5E9), () => Navigator.pushReplacementNamed(context, '/dashboard')),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _sectionTitle('OPERATIONS'),
                  _moduleItem('poultry', const Color(0xFF3B82F6), context),
                  _moduleItem('dairy', const Color(0xFF10B981), context),
                  _moduleItem('crops', const Color(0xFFF59E0B), context),
                  _moduleItem('livestock', const Color(0xFFEF4444), context),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _sectionTitle('FINANCE'),
                  _moduleItem('cashbook', const Color(0xFF059669), context),
                  _moduleItem('inventory', const Color(0xFFEC4899), context),
                  _moduleItem('journal', const Color(0xFFF43F5E), context),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _sectionTitle('ASSETS'),
                  _moduleItem('property', const Color(0xFF8B5CF6), context),
                  _moduleItem('transport', const Color(0xFF06B6D4), context),
                  _moduleItem('contracts', const Color(0xFF0891B2), context),
                  if (isMgr) ...[
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _sectionTitle('MANAGEMENT'),
                    _drawerItem(Icons.checklist_rounded, 'Approvals', const Color(0xFFF97316), () => Navigator.pushReplacementNamed(context, '/manager/approvals')),
                    if (isSuper) _drawerItem(Icons.people_rounded, 'Users', const Color(0xFF8B5CF6), () => Navigator.pushReplacementNamed(context, '/admin/users')),
                  ],
                  if (isSuper) ...[
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _sectionTitle('REPORTS'),
                    _drawerItem(Icons.assessment_rounded, 'Reports', const Color(0xFF14B8A6), () => Navigator.pushReplacementNamed(context, '/admin/reports')),
                    _drawerItem(Icons.settings_rounded, 'Settings', const Color(0xFF64748B), () => Navigator.pushReplacementNamed(context, '/settings')),
                  ],
                  if (isGen) ...[
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _sectionTitle('WORKER'),
                    _drawerItem(Icons.home_rounded, 'My Dashboard', const Color(0xFF0EA5E9), () => Navigator.pushReplacementNamed(context, '/worker/dashboard')),
                    _drawerItem(Icons.history_rounded, 'My History', const Color(0xFF8B5CF6), () => Navigator.pushReplacementNamed(context, '/worker/history')),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await auth.signOut();
                    if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Sign Out', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 2),
      child: Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8), letterSpacing: 1.5, fontFamily: 'Poppins')),
    );
  }

  Widget _drawerItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: Color(0xFF1E293B))),
      trailing: Icon(Icons.chevron_right_rounded, color: color.withValues(alpha: 0.4), size: 16),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: onTap,
    );
  }

  Widget _moduleItem(String id, Color color, BuildContext context) {
    final mod = ModuleConfig.getModule(id);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(mod.icon, color: color, size: 18),
      ),
      title: Text(mod.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: Color(0xFF1E293B))),
      trailing: Icon(Icons.chevron_right_rounded, color: color.withValues(alpha: 0.4), size: 16),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () => Navigator.pushReplacementNamed(context, '/sheets', arguments: {'module': id}),
    );
  }
}
