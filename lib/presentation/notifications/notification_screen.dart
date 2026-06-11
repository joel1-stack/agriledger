import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../state/auth/auth_provider.dart';
import '../poultry/widgets/poultry_drawer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<_NotificationItem> _notifications = [
    _NotificationItem(icon: Icons.check_circle_rounded, iconColor: const Color(0xFF10B981), title: 'Record Approved', subtitle: 'Feed Expense — Batch A', body: 'Manager Mike approved your entry', time: '2 hours ago', type: 'approval', isRead: false),
    _NotificationItem(icon: Icons.cancel_rounded, iconColor: const Color(0xFFEF4444), title: 'Record Rejected', subtitle: 'Mortality — Batch B', body: '"Missing photo for 5+ deaths"', time: '3 hours ago', type: 'rejection', isRead: false, actionLabel: 'Edit & Resubmit'),
    _NotificationItem(icon: Icons.inventory_2_rounded, iconColor: const Color(0xFFF59E0B), title: 'Low Stock Alert', subtitle: 'Layer Mash: 5 bags remaining', body: '', time: '1 day ago', type: 'alert', isRead: true, actionLabel: 'View Inventory'),
    _NotificationItem(icon: Icons.info_rounded, iconColor: const Color(0xFF0EA5E9), title: 'Assigned to New Flock', subtitle: 'House 3 — Broilers', body: 'You are now assigned to Batch C', time: '1 day ago', type: 'info', isRead: true),
  ];

  bool get _hasUnread => _notifications.any((n) => !n.isRead);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B8A3C),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
        actions: [
          if (_hasUnread)
            TextButton(
              onPressed: () { setState(() { for (final n in _notifications) { n.isRead = true; } }); },
              child: const Text('Mark All Read', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      drawer: const PoultryDrawer(),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_rounded, size: 56, color: const Color(0xFF94A3B8).withValues(alpha: 0.4)),
                  const SizedBox(height: 12),
                  const Text('No notifications yet', style: TextStyle(fontSize: 16, color: Color(0xFF94A3B8), fontFamily: 'Poppins')),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final n = _notifications[i];
                return GestureDetector(
                  onTap: () => setState(() => n.isRead = true),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: n.isRead ? Colors.white : n.iconColor.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: n.isRead ? null : Border.all(color: n.iconColor.withValues(alpha: 0.15)),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: n.iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                          child: Icon(n.icon, color: n.iconColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(n.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A), fontFamily: 'Poppins'))),
                                  if (!n.isRead)
                                    Container(width: 8, height: 8, decoration: BoxDecoration(color: n.iconColor, shape: BoxShape.circle)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(n.subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontFamily: 'Poppins')),
                              if (n.body.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(n.body, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontFamily: 'Poppins')),
                              ],
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(n.time, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontFamily: 'Poppins')),
                                  if (n.actionLabel != null) ...[
                                    const Spacer(),
                                    Text(n.actionLabel!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: n.iconColor, fontFamily: 'Poppins')),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title, subtitle, body, time, type;
  bool isRead;
  String? actionLabel;
  _NotificationItem({required this.icon, required this.iconColor, required this.title, required this.subtitle, required this.body, required this.time, required this.type, required this.isRead, this.actionLabel});
}
