import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/auth/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeToTerms = false;
  String _selectedRole = 'general';

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _slideController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 150),
            () => mounted ? _slideController.forward() : null);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).clearError();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      _showSnack('Please agree to the terms to continue');
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signUp(
      _emailController.text.trim(),
      _passwordController.text,
      _nameController.text.trim(),
      role: _selectedRole,
    );

    if (mounted) setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.accentOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Background ──
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1564135625714-0e0a2e1b39f9?auto=format&fit=crop&w=1080&q=80'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0x660A3D1F),
                        Color(0x991B8A3C),
                        Color(0xCC4CAF50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Top header ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.28,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  // Back button
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                            context, '/login'),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Join AgriLedger 🌾',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Start managing your farm business today',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom form sheet ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _slideAnim,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  height: size.height * 0.74,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(36)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 30,
                        offset: Offset(0, -10),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 10, 28, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Pull handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(top: 12, bottom: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Fill in your details to get started',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Account type selector ─────────────────────────
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Account Type',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildRoleOption(
                              role: 'general',
                              icon: Icons.agriculture_rounded,
                              title: 'General Worker',
                              description: 'Record farm activities, manage inventory & view cashbook',
                              color: AppColors.primaryGreen,
                              bg: const Color(0xFFF0FBF4),
                            ),
                            const SizedBox(height: 8),
                            _buildRoleOption(
                              role: 'viewAdmin',
                              icon: Icons.visibility_rounded,
                              title: 'View Admin',
                              description: 'View reports, export data & analytics dashboard',
                              color: const Color(0xFF1565C0),
                              bg: const Color(0xFFF0F4FF),
                            ),
                            const SizedBox(height: 8),
                            _buildRoleOption(
                              role: 'superAdmin',
                              icon: Icons.shield_rounded,
                              title: 'Super Admin',
                              description: 'Full access: manage users, roles & all farm data',
                              color: const Color(0xFFB71C1C),
                              bg: const Color(0xFFFFF0F0),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Full Name
                              _buildTextField(
                                controller: _nameController,
                                label: 'Full Name',
                                hint: 'John Farmer',
                                icon: Icons.person_outline_rounded,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  if (v.trim().length < 3) {
                                    return 'Name must be at least 3 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),

                              // Email
                              _buildTextField(
                                controller: _emailController,
                                label: 'Email Address',
                                hint: 'you@farm.com',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!v.contains('@') || !v.contains('.')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),

                              // Password
                              _buildTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'Min. 6 characters',
                                icon: Icons.lock_outline_rounded,
                                obscure: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textLight,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                          () => _obscurePassword = !_obscurePassword),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (v.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),

                              // Confirm Password
                              _buildTextField(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                hint: 'Re-enter password',
                                icon: Icons.lock_outline_rounded,
                                obscure: _obscureConfirm,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textLight,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                          () => _obscureConfirm = !_obscureConfirm),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (v != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Password strength indicator
                        _buildPasswordStrength(),

                        const SizedBox(height: 16),

                        // Terms checkbox
                        GestureDetector(
                          onTap: () =>
                              setState(() => _agreeToTerms = !_agreeToTerms),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: _agreeToTerms
                                      ? AppColors.primaryGreen
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _agreeToTerms
                                        ? AppColors.primaryGreen
                                        : const Color(0xFFDDF0E5),
                                    width: 2,
                                  ),
                                ),
                                child: _agreeToTerms
                                    ? const Icon(Icons.check,
                                    color: Colors.white, size: 14)
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: AppColors.textLight,
                                    ),
                                    children: [
                                      TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms & Privacy Policy',
                                        style: TextStyle(
                                          color: AppColors.primaryGreen,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Error message
                        if (authProvider.error != null) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F0),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.accentRed.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline_rounded,
                                    color: AppColors.accentRed, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    authProvider.error!,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: AppColors.accentRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Register button
                        AppWidgets.gradientButton(
                          label: 'Create Account',
                          icon: Icons.person_add_rounded,
                          isLoading: _isLoading,
                          onTap: _handleRegister,
                        ),

                        const SizedBox(height: 20),

                        // Sign in link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: AppColors.textLight,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, '/login'),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStrength() {
    final password = _passwordController.text;
    if (password.isEmpty) return const SizedBox.shrink();

    int strength = 0;
    if (password.length >= 6) strength++;
    if (password.length >= 10) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*]'))) strength++;

    final colors = [
      AppColors.accentRed,
      AppColors.accentOrange,
      AppColors.accentAmber,
      AppColors.secondaryGreen,
      AppColors.primaryGreen,
    ];
    final labels = ['Very Weak', 'Weak', 'Fair', 'Strong', 'Very Strong'];
    final idx = (strength - 1).clamp(0, 4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (i) {
            return Expanded(
              child: Container(
                height: 5,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: i < strength ? colors[idx] : const Color(0xFFE8F5ED),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          'Password strength: ${labels[idx]}',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: colors[idx],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ── Role option card ──────────────────────────────────────────────────────
  Widget _buildRoleOption({
    required String role,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Color bg,
  }) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? bg : Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.15) : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: isSelected ? color : Colors.grey[500], size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: isSelected ? color : AppColors.textDark,
                      )),
                  Text(description,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: isSelected ? color.withOpacity(0.8) : AppColors.textLight,
                      )),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 13),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 15,
        color: AppColors.textDark,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.textMuted,
          fontSize: 13,
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.mintGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryGreen, size: 18),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF8FDF9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDDF0E5), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDDF0E5), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
          const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
          const BorderSide(color: AppColors.accentRed, width: 1.5),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      validator: validator,
    );
  }
}