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
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, -4)),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: AppColors.textMuted,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
          elevation: 0,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            const BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Modules'),
            BottomNavigationBarItem(
              icon: isAdmin
                  ? Badge(
                      isLabelVisible: pending > 0,
                      label: Text('$pending', style: const TextStyle(fontSize: 10)),
                      child: const Icon(Icons.checklist_rounded),
                    )
                  : const Icon(Icons.history_rounded),
              label: isAdmin ? 'Approvals' : 'History',
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildHome(AuthProvider auth) {
    if (auth.isSuperAdmin) return const DashboardScreen();
    if (auth.isManager) return const DashboardScreen();
    return const WorkerDashboard();
  }
}
