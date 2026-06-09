import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;
  final bool compact;

  const StatusBadge({
    super.key,
    required this.status,
    this.fontSize = 11,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icon,
            size: fontSize - 2,
            color: color,
          ),
          if (!compact) const SizedBox(width: 4),
          if (!compact)
            Text(
              _label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: color,
                fontFamily: 'Poppins',
              ),
            ),
        ],
      ),
    );
  }

  Color get _color {
    switch (status) {
      case 'approved': return AppColors.primaryGreen;
      case 'rejected': return AppColors.accentRed;
      case 'pending_sync': return AppColors.accentAmber;
      default: return AppColors.accentOrange;
    }
  }

  IconData get _icon {
    switch (status) {
      case 'approved': return Icons.check_circle;
      case 'rejected': return Icons.cancel;
      case 'pending_sync': return Icons.sync;
      default: return Icons.hourglass_empty;
    }
  }

  String get _label {
    switch (status) {
      case 'approved': return 'Approved';
      case 'rejected': return 'Rejected';
      case 'pending_sync': return 'Syncing';
      default: return 'Pending';
    }
  }
}
