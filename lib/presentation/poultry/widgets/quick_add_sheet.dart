import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class QuickAddSheet extends StatelessWidget {
  const QuickAddSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (ctx, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Quick Add',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Tap to add a new record',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted, fontFamily: 'Poppins'),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _QuickAddItem(
                    icon: Icons.egg_alt_rounded,
                    title: 'Record Egg Collection',
                    subtitle: 'Morning or afternoon eggs',
                    gradient: AppColors.cardGradientOrange,
                    onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/production-log'); },
                  ),
                  _QuickAddItem(
                    icon: Icons.payments_rounded,
                    title: 'Record Sale',
                    subtitle: 'Egg or bird sale',
                    gradient: AppColors.cardGradientBlue,
                    onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/sales'); },
                  ),
                  _QuickAddItem(
                    icon: Icons.restaurant_rounded,
                    title: 'Log Feed Purchase',
                    subtitle: 'Starter, layer or finisher',
                    gradient: AppColors.cardGradientAmber,
                    onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/feed-expenses'); },
                  ),
                  _QuickAddItem(
                    icon: Icons.pets_rounded,
                    title: 'Add New Batch',
                    subtitle: 'Layer, broiler or kienyeji',
                    gradient: AppColors.cardGradientGreen,
                    onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/flock-register'); },
                  ),
                  _QuickAddItem(
                    icon: Icons.medical_services_rounded,
                    title: 'Vet Record',
                    subtitle: 'Vaccination or treatment',
                    gradient: LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
                    onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/vet-health'); },
                  ),
                  _QuickAddItem(
                    icon: Icons.warning_amber_rounded,
                    title: 'Log Mortality',
                    subtitle: 'Record bird loss',
                    gradient: LinearGradient(colors: [Color(0xFF6B7280), Color(0xFF4B5563)]),
                    onTap: () { Navigator.pop(context); Navigator.pushNamed(context, '/mortality-log'); },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAddItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _QuickAddItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
