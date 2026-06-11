import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/module_config.dart';
import '../../state/daily_record/daily_record_provider.dart';
import '../../state/auth/auth_provider.dart';
import '../poultry/widgets/poultry_drawer.dart';
import '../poultry/widgets/status_badge.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DailyRecordProvider>();
    final auth = context.watch<AuthProvider>();
    final myRecords = provider.records.where((r) => r.recordedBy == auth.userId).toList();
    myRecords.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B8A3C),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('My History', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
            child: Text('${myRecords.length} total', style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Poppins')),
          ),
        ],
      ),
      drawer: const PoultryDrawer(),
      body: myRecords.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFF94A3B8).withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.history_rounded, size: 48, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 12),
                  const Text('No records yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF64748B), fontFamily: 'Poppins')),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/worker/add'),
                    icon: const Icon(Icons.add),
                    label: const Text('Add your first record'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B8A3C), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: myRecords.length,
              itemBuilder: (_, i) {
                final r = myRecords[i];
                final modColor = ModuleConfig.moduleColor(r.module);
                final modLabel = ModuleConfig.moduleLabel(r.module);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          StatusBadge(status: r.status),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: modColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(ModuleConfig.moduleIcon(r.module), size: 10, color: modColor),
                                const SizedBox(width: 3),
                                Text(modLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: modColor)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(_capitalize(r.sheetType), style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontFamily: 'Poppins')),
                          const Spacer(),
                          Icon(Icons.calendar_today_rounded, size: 11, color: const Color(0xFF94A3B8)),
                          const SizedBox(width: 3),
                          Text(r.date.toString().substring(0, 10), style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontFamily: 'Poppins')),
                        ]),
                        const SizedBox(height: 8),
                        Text('Unit: ${r.unitId}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: Color(0xFF0F172A))),
                        if (r.rejectionReason != null) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: const Color(0xFFEF4444).withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(Icons.info_rounded, size: 14, color: Color(0xFFEF4444)),
                                const SizedBox(width: 6),
                                Expanded(child: Text(r.rejectionReason!, style: const TextStyle(fontSize: 11, color: Color(0xFFEF4444), fontFamily: 'Poppins'))),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
