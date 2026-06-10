import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/module_config.dart';
import '../../state/auth/auth_provider.dart';
import '../poultry/widgets/poultry_drawer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<_NotificationItem> _notifications = [
    _NotificationItem(
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.primaryGreen,
      title: 'Record Approved',
      subtitle: 'Feed Expense — Batch A',
      body: 'Manager Mike approved your entry',
      time: '2 hours ago',
      type: 'approval',
      isRead: false,
    ),
    _NotificationItem(
      icon: Icons.cancel_rounded,
      iconColor: AppColors.accentRed,
      title: 'Record Rejected',
      subtitle: 'Mortality — Batch B',
      body: '"Missing photo for 5+ deaths"',
      time: '3 hours ago',
      type: 'rejection',
      isRead: false,
      actionLabel: 'Edit & Resubmit',
    ),
    _NotificationItem(
      icon: Icons.inventory_2_rounded,
      iconColor: AppColors.accentAmber,
      title: 'Low Stock Alert',
      subtitle: 'Layer Mash: 5 bags remaining',
      body: '',
      time: '1 day ago',
      type: 'alert',
      isRead: true,
      actionLabel: 'View Inventory',
    ),
    _NotificationItem(
      icon: Icons.info_rounded,
      iconColor: AppColors.accentBlue,
      title: 'Assigned to New Flock',
      subtitle: 'House 3 — Broilers',
      body: 'You are now assigned to Batch C',
      time: '1 day ago',
      type: 'info',
      isRead: true,
    ),
  ];

  bool get _hasUnread => _notifications.any((n) => !n.isRead);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (_hasUnread)
            TextButton(
              onPressed: () {
                setState(() {
                  for (final n in _notifications) { n.isRead = true; }
                });
              },
              child: const Text('Mark All Read', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
        ],
      ),
      drawer: const PoultryDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _notifications.length + _sections().length,
        itemBuilder: (_, i) {
          final sections = _sections();
          if (i < sections.length) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
              child: Text(sections[i], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textMedium, fontFamily: 'Poppins')),
            );
          }
          final n = _notifications[i - sections.length];
          return _NotificationCard(
            item: n,
            onTap: () {
              setState(() => n.isRead = true);
              if (n.actionLabel != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navigate: ${n.actionLabel}')),
                );
              }
            },
          );
        },
      ),
    );
  }

  List<String> _sections() {
    final sections = <String>[];
    final today = _notifications.where((n) => n.time.contains('hour') || n.time.contains('minute')).toList();
    final yesterday = _notifications.where((n) => n.time.contains('day')).toList();
    if (today.isNotEmpty) sections.add('TODAY');
    if (yesterday.isNotEmpty) sections.add('YESTERDAY');
    return sections;
  }
}

class _NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String body;
  final String time;
  final String type;
  bool isRead;
  final String? actionLabel;

  _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.time,
    required this.type,
    this.isRead = false,
    this.actionLabel,
  });
}

class _NotificationCard extends StatelessWidget {
  final _NotificationItem item;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: item.isRead ? Colors.white : AppColors.mintGreen,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: item.isRead ? FontWeight.w500 : FontWeight.w700,
                              fontFamily: 'Poppins',
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(color: AppColors.accentRed, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(item.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMedium, fontFamily: 'Poppins')),
                    if (item.body.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(item.body, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Poppins')),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(item.time, style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontFamily: 'Poppins')),
                        const Spacer(),
                        if (item.actionLabel != null)
                          Text(
                            item.actionLabel!,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryGreen, fontFamily: 'Poppins'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
