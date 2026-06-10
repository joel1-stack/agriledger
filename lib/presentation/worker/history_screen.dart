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
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('My History'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
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
                  Icon(Icons.history_rounded, size: 64, color: AppColors.textMuted.withValues(alpha: 0.3)),
                  const SizedBox(height: 12),
                  const Text('No records yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/worker/add'),
                    icon: const Icon(Icons.add),
                    label: const Text('Add your first record'),
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

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            StatusBadge(status: r.status),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: modColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(ModuleConfig.moduleIcon(r.module), size: 10, color: modColor),
                                  const SizedBox(width: 3),
                                  Text(modLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: modColor)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(_capitalize(r.sheetType), style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontFamily: 'Poppins')),
                            const Spacer(),
                            Text(r.date.toString().substring(0, 10), style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Poppins')),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Unit: ${r.unitId}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: AppColors.textDark)),
                        if (r.rejectionReason != null) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: AppColors.accentRed.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(Icons.info_rounded, size: 14, color: AppColors.accentRed),
                                const SizedBox(width: 6),
                                Expanded(child: Text(r.rejectionReason!, style: const TextStyle(fontSize: 11, color: AppColors.accentRed, fontFamily: 'Poppins'))),
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
