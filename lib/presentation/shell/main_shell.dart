import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../state/auth/auth_provider.dart';
import '../../state/daily_record/daily_record_provider.dart';
import '../poultry/screens/dashboard_screen.dart';
import '../sheets/module_selector_screen.dart';
import '../approvals/approval_queue_screen.dart';
import '../worker/worker_dashboard.dart';
import '../profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final pending = context.watch<DailyRecordProvider>().totalPending;
    final isAdmin = auth.isManager;

    final pages = <Widget>[
      _buildHome(auth),
      const ModuleSelectorScreen(),
      isAdmin ? const ApprovalQueueScreen() : const WorkerDashboard(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 6)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFF0F172A),
            unselectedItemColor: const Color(0xFF94A3B8),
            selectedFontSize: 11,
            unselectedFontSize: 10,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: _navIcon(Icons.home_rounded, 0),
                activeIcon: _navIconActive(Icons.home_rounded, const Color(0xFF0EA5E9)),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _navIcon(Icons.grid_view_rounded, 1),
                activeIcon: _navIconActive(Icons.grid_view_rounded, const Color(0xFFF59E0B)),
                label: 'Modules',
              ),
              BottomNavigationBarItem(
                icon: isAdmin
                    ? Badge(
                        isLabelVisible: pending > 0,
                        label: Text('$pending', style: const TextStyle(fontSize: 9, color: Colors.white)),
                        child: _navIcon(Icons.checklist_rounded, 2),
                      )
                    : _navIcon(Icons.history_rounded, 2),
                activeIcon: isAdmin
                    ? Badge(
                        isLabelVisible: pending > 0,
                        label: Text('$pending', style: const TextStyle(fontSize: 9, color: Colors.white)),
                        child: _navIconActive(Icons.checklist_rounded, const Color(0xFF8B5CF6)),
                      )
                    : _navIconActive(Icons.history_rounded, const Color(0xFF8B5CF6)),
                label: isAdmin ? 'Approvals' : 'History',
              ),
              BottomNavigationBarItem(
                icon: _navIcon(Icons.person_rounded, 3),
                activeIcon: _navIconActive(Icons.person_rounded, const Color(0xFF10B981)),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: _currentIndex == index ? Colors.transparent : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 22),
    );
  }

  Widget _navIconActive(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 22, color: color),
    );
  }

  Widget _buildHome(AuthProvider auth) {
    if (auth.isSuperAdmin) return const DashboardScreen();
    if (auth.isManager) return const DashboardScreen();
    return const WorkerDashboard();
  }
}
