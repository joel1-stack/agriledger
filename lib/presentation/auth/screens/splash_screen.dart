import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/auth/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _bgController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _textOpacity;
  late Animation<double> _bgOpacity;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _bgOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeIn),
    );
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _logoController,
          curve: const Interval(0, 0.5, curve: Curves.easeIn)),
    );
    _textSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await _bgController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1800));
    _navigate();
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Wait a bit for Firebase Auth to restore persisted session
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    if (authProvider.isAuthenticated || authProvider.firebaseUser != null) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _bgController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) => FadeTransition(
          opacity: _bgOpacity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Background: rich gradient + nature pattern ──
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0A3D1F),
                      Color(0xFF1B8A3C),
                      Color(0xFF27AE60),
                      Color(0xFF52C77B),
                    ],
                    stops: [0.0, 0.35, 0.70, 1.0],
                  ),
                ),
              ),

              // ── Decorative leaf-like circles ──
              Positioned(
                top: -80,
                right: -80,
                child: _decorCircle(300, Colors.white.withOpacity(0.05)),
              ),
              Positioned(
                top: -40,
                right: -40,
                child: _decorCircle(200, Colors.white.withOpacity(0.05)),
              ),
              Positioned(
                bottom: -120,
                left: -80,
                child: _decorCircle(380, Colors.white.withOpacity(0.04)),
              ),
              Positioned(
                bottom: 80,
                right: -60,
                child: _decorCircle(180, Colors.white.withOpacity(0.06)),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.35,
                left: -50,
                child: _decorCircle(140, Colors.white.withOpacity(0.05)),
              ),

              // ── Tiny decorative leaf icons ──
              ..._buildLeafDecorations(),

              // ── Background overlay ──
              Positioned.fill(
                child: Container(color: const Color(0xFF0A3D1F)),
              ),

              // ── Center Content ──
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo circle with glow
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) => FadeTransition(
                        opacity: _logoOpacity,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: AnimatedBuilder(
                            animation: _pulse,
                            builder: (context, child) => Transform.scale(
                              scale: _pulse.value,
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.neonGreen.withOpacity(0.4),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.1),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/images/3D Logo 'sam k' with Nature tru one .png",
                                    fit: BoxFit.cover,
                                    width: 130,
                                    height: 130,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.eco_rounded, size: 68, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // App Name & Tagline
                    SlideTransition(
                      position: _textSlide,
                      child: FadeTransition(
                        opacity: _textOpacity,
                        child: Column(
                          children: [
                            const Text(
                              'AgriLedger',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1.5,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.25),
                                ),
                              ),
                              child: const Text(
                                'Farm Business Accounting',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 80),

                    // Loading indicator
                    FadeTransition(
                      opacity: _textOpacity,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 44,
                            height: 44,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading your farm data...',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Bottom Brand Strip ──
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _featurePill(Icons.bar_chart_rounded, 'Finance'),
                        const SizedBox(width: 12),
                        _featurePill(Icons.grass_rounded, 'Farming'),
                        const SizedBox(width: 12),
                        _featurePill(Icons.inventory_2_rounded, 'Inventory'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _decorCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  List<Widget> _buildLeafDecorations() {
    final leaves = [
      {
        'top': 120.0,
        'left': 30.0,
        'size': 18.0,
        'opacity': 0.25,
        'icon': Icons.spa_rounded
      },
      {
        'top': 200.0,
        'right': 50.0,
        'size': 14.0,
        'opacity': 0.2,
        'icon': Icons.eco_rounded
      },
      {
        'top': 350.0,
        'left': 60.0,
        'size': 22.0,
        'opacity': 0.2,
        'icon': Icons.nature_rounded
      },
      {
        'bottom': 300.0,
        'right': 40.0,
        'size': 16.0,
        'opacity': 0.25,
        'icon': Icons.grass_rounded
      },
    ];

    return leaves.map((leaf) {
      return Positioned(
        top: leaf['top'] as double?,
        bottom: leaf['bottom'] as double?,
        left: leaf['left'] as double?,
        right: leaf['right'] as double?,
        child: Icon(
          leaf['icon'] as IconData,
          size: leaf['size'] as double,
          color: Colors.white.withOpacity(leaf['opacity'] as double),
        ),
      );
    }).toList();
  }

  Widget _featurePill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white.withOpacity(0.85)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}