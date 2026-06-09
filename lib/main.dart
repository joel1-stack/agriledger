import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';

import 'state/auth/auth_provider.dart';
import 'state/poultry/poultry_provider.dart';
import 'services/notification_service.dart';

import 'presentation/auth/screens/splash_screen.dart';
import 'presentation/auth/screens/login_screen.dart';
import 'presentation/auth/screens/register_screen.dart';

import 'presentation/poultry/screens/sheet_screen.dart';
import 'presentation/poultry/screens/flock_register_screen.dart';

import 'presentation/admin/admin_dashboard.dart';
import 'presentation/admin/user_management_screen.dart';
import 'presentation/admin/reports_screen.dart';

import 'presentation/worker/worker_dashboard.dart';
import 'presentation/worker/history_screen.dart';

import 'presentation/approvals/approval_queue_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  await NotificationService.init();

  runApp(const PoultryApp());
}

class PoultryApp extends StatelessWidget {
  const PoultryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PoultryProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Poultry Manager',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    Widget page;

    final args = settings.arguments as Map<String, dynamic>? ?? {};

    switch (settings.name) {
      case '/':
        page = const SplashScreen();
        break;
      case '/login':
        page = const LoginScreen();
        break;
      case '/register':
        page = const RegisterScreen();
        break;

      // -- Role-based Dashboards --
      case '/dashboard':
        page = _RoleRouter();
        break;
      case '/admin/dashboard':
        page = const AdminDashboard();
        break;
      case '/admin/users':
        page = const UserManagementScreen();
        break;
      case '/admin/reports':
        page = const ReportsScreen();
        break;

      case '/manager/approvals':
        page = const ApprovalQueueScreen();
        break;

      case '/worker/dashboard':
        page = const WorkerDashboard();
        break;
      case '/worker/add':
        page = const WorkerDashboard();
        break;
      case '/worker/history':
        page = const HistoryScreen();
        break;
      case '/worker/notifications':
        page = const HistoryScreen();
        break;

      // -- Sheets (Excel-like data view for all roles) --
      case '/sheets':
        page = SheetScreen(
          birdType: args['birdType'] ?? 'layers',
          initialSheet: args['initialSheet'] ?? 'feed',
          flockId: args['flockId'],
        );
        break;

      // -- Legacy screens --
      case '/flock-register':
        page = const FlockRegisterScreen();
        break;

      default:
        page = _NotFoundScreen(routeName: settings.name ?? 'unknown');
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(0.0, 0.04);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: SlideTransition(position: animation.drive(tween), child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 280),
    );
  }
}

/// Routes to the correct dashboard based on user role
class _RoleRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isAuthenticated) return const LoginScreen();
    if (auth.isSuperAdmin) return const AdminDashboard();
    if (auth.isManager) return const ApprovalQueueScreen();
    return const WorkerDashboard();
  }
}

class _NotFoundScreen extends StatelessWidget {
  final String routeName;
  const _NotFoundScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, height: 100,
              decoration: const BoxDecoration(
                color: AppColors.mintGreen, shape: BoxShape.circle,
              ),
              child: const Icon(Icons.map_outlined, size: 48, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 24),
            const Text('Page Not Found', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Text('Route "$routeName" does not exist', style: const TextStyle(fontSize: 14, color: AppColors.textLight)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
              icon: const Icon(Icons.home_rounded),
              label: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}

