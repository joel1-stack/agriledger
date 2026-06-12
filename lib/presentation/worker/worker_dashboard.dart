import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/module_config.dart';
import '../../state/daily_record/daily_record_provider.dart';
import '../../state/auth/auth_provider.dart';
import '../poultry/widgets/poultry_drawer.dart';

class WorkerDashboard extends StatelessWidget {
  const WorkerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DailyRecordProvider>();
    final auth = context.watch<AuthProvider>();

    final totalMy = provider.records.where((r) => r.recordedBy == auth.userId).length;
    final pendingMy = provider.records.where((r) => r.recordedBy == auth.userId && r.status == 'pending').length;
    final approvedMy = provider.records.where((r) => r.recordedBy == auth.userId && r.status == 'approved').length;
    final rejectedMy = provider.records.where((r) => r.recordedBy == auth.userId && r.status == 'rejected').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B8A3C),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Dashboard', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => Navigator.pushNamed(context, '/worker/history'),
            tooltip: 'My History',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () => Navigator.pushNamed(context, '/worker/notifications'),
            tooltip: 'Notifications',
          ),
        ],
      ),
      drawer: const PoultryDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Welcome header ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0D5C26), Color(0xFF1B8A3C)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: const Color(0xFF1B8A3C).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
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
                          (auth.displayName.isNotEmpty ? auth.displayName[0] : 'W').toUpperCase(),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Poppins'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hello, ${auth.displayName.split(' ')[0]}!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Poppins')),
                            const Text('Ready to record today\'s activities', style: TextStyle(fontSize: 12, color: Colors.white70, fontFamily: 'Poppins')),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                        child: Text(_today(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Poppins')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Stats cards ──
            Row(
              children: [
                _statCard('Total', '$totalMy', const Color(0xFF3B82F6), Icons.assignment_rounded),
                const SizedBox(width: 8),
                _statCard('Pending', '$pendingMy', const Color(0xFFF59E0B), Icons.hourglass_bottom_rounded),
                const SizedBox(width: 8),
                _statCard('Approved', '$approvedMy', const Color(0xFF10B981), Icons.check_circle_rounded),
                const SizedBox(width: 8),
                _statCard('Rejected', '$rejectedMy', const Color(0xFFEF4444), Icons.cancel_rounded),
              ],
            ),
            const SizedBox(height: 20),

            // ── Quick actions ──
            const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Poppins', color: Color(0xFF0F172A))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _actionCard(
                    context,
                    icon: Icons.add_circle_rounded,
                    label: 'Add Record',
                    color: const Color(0xFF1B8A3C),
                    route: '/worker/add',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _actionCard(
                    context,
                    icon: Icons.history_rounded,
                    label: 'My History',
                    color: const Color(0xFF0EA5E9),
                    route: '/worker/history',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _actionCard(
                    context,
                    icon: Icons.assessment_rounded,
                    label: 'All Sheets',
                    color: const Color(0xFF8B5CF6),
                    route: '/sheets',
                    args: const {'module': 'poultry'},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Module grid ──
            const Text('My Modules', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Poppins', color: Color(0xFF0F172A))),
            const SizedBox(height: 12),
            ...ModuleConfig.moduleIds.map((id) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, '/sheets', arguments: {'module': id}),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: ModuleConfig.moduleColor(id).withValues(alpha: 0.15)),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: ModuleConfig.moduleColor(id).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(ModuleConfig.moduleIcon(id), color: ModuleConfig.moduleColor(id), size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ModuleConfig.moduleLabel(id), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: Color(0xFF0F172A))),
                                Text('${provider.pendingCount(id)} pending', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontFamily: 'Poppins')),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: ModuleConfig.moduleColor(id).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(provider.pendingCount(id) > 0 ? '${provider.pendingCount(id)}' : '0', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: ModuleConfig.moduleColor(id), fontFamily: 'Poppins')),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.chevron_right, size: 18, color: ModuleConfig.moduleColor(id).withValues(alpha: 0.5)),
                        ],
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/worker/add'),
        backgroundColor: const Color(0xFF1B8A3C),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Record', style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Poppins', color: color)),
            Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8), fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(BuildContext context, {required IconData icon, required String label, required Color color, required String route, Map<String, dynamic>? args}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route, arguments: args),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, size: 26, color: color),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: color), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  String _today() {
    final d = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}
