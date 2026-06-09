import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';

import 'state/auth/auth_provider.dart';
import 'state/poultry/poultry_provider.dart';
import 'presentation/auth/screens/splash_screen.dart';
import 'presentation/auth/screens/login_screen.dart';
import 'presentation/auth/screens/register_screen.dart';

import 'presentation/poultry/screens/dashboard_screen.dart';
import 'presentation/poultry/screens/farm_config_screen.dart';
import 'presentation/poultry/screens/flock_register_screen.dart';
import 'presentation/poultry/screens/production_log_screen.dart';
import 'presentation/poultry/screens/sales_screen.dart';
import 'presentation/poultry/screens/other_income_screen.dart';
import 'presentation/poultry/screens/feed_expenses_screen.dart';
import 'presentation/poultry/screens/feed_consumption_screen.dart';
import 'presentation/poultry/screens/vet_health_screen.dart';
import 'presentation/poultry/screens/mortality_log_screen.dart';
import 'presentation/poultry/screens/housing_expenses_screen.dart';
import 'presentation/poultry/screens/labour_screen.dart';
import 'presentation/poultry/screens/overheads_screen.dart';
import 'presentation/poultry/screens/batch_performance_screen.dart';
import 'presentation/poultry/screens/inventory_screen.dart';
import 'presentation/poultry/screens/monthly_summary_screen.dart';
import 'presentation/poultry/screens/annual_pl_screen.dart';
import 'presentation/poultry/screens/asset_register_screen.dart';
import 'presentation/poultry/screens/user_manual_screen.dart';

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

      // ── Poultry Screens ──────────────────────────────
      case '/dashboard':
        page = const DashboardScreen();
        break;
      case '/farm-config':
        page = const FarmConfigScreen();
        break;
      case '/flock-register':
        page = const FlockRegisterScreen();
        break;
      case '/production-log':
        page = const ProductionLogScreen();
        break;
      case '/sales':
        page = const SalesScreen();
        break;
      case '/other-income':
        page = const OtherIncomeScreen();
        break;
      case '/feed-expenses':
        page = const FeedExpensesScreen();
        break;
      case '/feed-consumption':
        page = const FeedConsumptionScreen();
        break;
      case '/vet-health':
        page = const VetHealthScreen();
        break;
      case '/mortality-log':
        page = const MortalityLogScreen();
        break;
      case '/housing-expenses':
        page = const HousingExpensesScreen();
        break;
      case '/labour':
        page = const LabourScreen();
        break;
      case '/overheads':
        page = const OverheadsScreen();
        break;
      case '/batch-performance':
        page = const BatchPerformanceScreen();
        break;
      case '/inventory':
        page = const InventoryScreen();
        break;
      case '/monthly-summary':
        page = const MonthlySummaryScreen();
        break;
      case '/annual-pl':
        page = const AnnualPLScreen();
        break;
      case '/asset-register':
        page = const AssetRegisterScreen();
        break;
      case '/user-manual':
        page = const UserManualScreen();
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
