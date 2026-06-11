import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../state/auth/auth_provider.dart';
import '../poultry/widgets/poultry_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.userModel;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B8A3C),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
      ),
      drawer: const PoultryDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(auth),
            const SizedBox(height: 20),
            _buildInfoSection(auth, user),
            const SizedBox(height: 12),
            _buildActionsSection(context, auth),
            const SizedBox(height: 12),
            _buildSignOut(context, auth),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AuthProvider auth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?auto=format&fit=crop&w=600&q=80'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
              child: ClipOval(
                child: Image.asset(
                  "assets/images/3D Logo 'sam k' with Nature tru one .png",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Text(
                      (auth.displayName.isNotEmpty ? auth.displayName[0] : 'U').toUpperCase(),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(auth.displayName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Poppins', shadows: [Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 2))])),
            const SizedBox(height: 4),
            Text(auth.userEmail, style: const TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'Poppins', shadows: [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1))])),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                auth.userRole.replaceAll('_', ' ').toUpperCase(),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(AuthProvider auth, dynamic user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _ProfileTile(icon: Icons.phone_rounded, label: 'Phone', value: user?.phone ?? '+254 712 345 678', onTap: () {}),
          const Divider(height: 1, indent: 56),
          _ProfileTile(icon: Icons.badge_rounded, label: 'Role', value: auth.userRole.replaceAll('_', ' '), onTap: () {}),
          const Divider(height: 1, indent: 56),
          _ProfileTile(icon: Icons.calendar_today_rounded, label: 'Member Since', value: user?.createdAt.toString().substring(0, 10) ?? 'N/A', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context, AuthProvider auth) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _ProfileTile(icon: Icons.lock_rounded, label: 'Change Password', value: '', onTap: () => _showChangePasswordDialog(context, auth)),
          const Divider(height: 1, indent: 56),
          _ProfileTile(icon: Icons.notifications_rounded, label: 'Notification Settings', value: '', onTap: () {
            Navigator.pushNamed(context, '/notifications');
          }),
        ],
      ),
    );
  }

  Widget _buildSignOut(BuildContext context, AuthProvider auth) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          await auth.signOut();
          if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
        },
        icon: const Icon(Icons.logout_rounded, color: AppColors.accentRed),
        label: const Text('Sign Out', style: TextStyle(color: AppColors.accentRed)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.accentRed),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}

void _showChangePasswordDialog(BuildContext context, AuthProvider auth) {
  final currentPwdCtrl = TextEditingController();
  final newPwdCtrl = TextEditingController();
  final confirmPwdCtrl = TextEditingController();
  bool obscureCurrent = true, obscureNew = true, obscureConfirm = true;
  bool isLoading = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.lock_rounded, color: Color(0xFF1B8A3C), size: 22),
          SizedBox(width: 8),
          Text('Change Password', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins', fontSize: 18)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPwdCtrl,
              obscureText: obscureCurrent,
              decoration: InputDecoration(
                labelText: 'Current Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                suffixIcon: IconButton(icon: Icon(obscureCurrent ? Icons.visibility_off : Icons.visibility, size: 20), onPressed: () => setDialogState(() => obscureCurrent = !obscureCurrent)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPwdCtrl,
              obscureText: obscureNew,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: const Icon(Icons.lock_rounded, size: 20),
                suffixIcon: IconButton(icon: Icon(obscureNew ? Icons.visibility_off : Icons.visibility, size: 20), onPressed: () => setDialogState(() => obscureNew = !obscureNew)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPwdCtrl,
              obscureText: obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: const Icon(Icons.lock_rounded, size: 20),
                suffixIcon: IconButton(icon: Icon(obscureConfirm ? Icons.visibility_off : Icons.visibility, size: 20), onPressed: () => setDialogState(() => obscureConfirm = !obscureConfirm)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            if (isLoading) ...[const SizedBox(height: 12), const Center(child: CircularProgressIndicator(strokeWidth: 3))],
          ],
        ),
        actions: [
          TextButton(onPressed: isLoading ? null : () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(fontFamily: 'Poppins'))),
          ElevatedButton(
            onPressed: isLoading ? null : () async {
              final current = currentPwdCtrl.text.trim();
              final newPwd = newPwdCtrl.text.trim();
              final confirm = confirmPwdCtrl.text.trim();
              if (current.isEmpty || newPwd.isEmpty || confirm.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill all fields'), behavior: SnackBarBehavior.floating));
                return;
              }
              if (newPwd != confirm) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match'), behavior: SnackBarBehavior.floating));
                return;
              }
              if (newPwd.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password must be at least 6 characters'), behavior: SnackBarBehavior.floating));
                return;
              }
              setDialogState(() => isLoading = true);
              final success = await auth.changePassword(current, newPwd);
              setDialogState(() => isLoading = false);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(children: [
                    Icon(success ? Icons.check_circle_rounded : Icons.error_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(child: Text(success ? 'Password changed successfully' : auth.error ?? 'Failed to change password', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13))),
                  ]),
                  backgroundColor: success ? const Color(0xFF1B8A3C) : const Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B8A3C), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Change', style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
          ),
        ],
      ),
    ),
  );
}
class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ProfileTile({required this.icon, required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryGreen, size: 20),
      ),
      title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: AppColors.textDark)),
      subtitle: value.isNotEmpty ? Text(value, style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontFamily: 'Poppins')) : null,
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
      onTap: onTap,
    );
  }
}
