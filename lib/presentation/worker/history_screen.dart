import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../state/poultry/poultry_provider.dart';
import '../../state/auth/auth_provider.dart';
import '../../config/sheet_config.dart';
import '../poultry/widgets/poultry_drawer.dart';
import '../poultry/widgets/status_badge.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final poultry = context.watch<PoultryProvider>();
    final auth = context.watch<AuthProvider>();
    final myRecords = poultry.allRecords.where((r) => r['recordedBy'] == auth.userId).toList();
    myRecords.sort((a, b) => (b['date'] ?? '').toString().compareTo((a['date'] ?? '').toString()));

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
                final birdType = r['birdType'] ?? 'layers';
                final sheetKey = r['sheetType'] ?? 'feed';
                final sheetCfg = allSheets[birdType]?.firstWhere((s) => s.key == sheetKey, orElse: () => layerSheets.first);

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
                            StatusBadge(status: r['status'] ?? 'pending'),
                            const SizedBox(width: 8),
                            if (sheetCfg != null) ...[
                              Icon(sheetCfg.icon, size: 14, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(sheetCfg.label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontFamily: 'Poppins')),
                            ],
                            const Spacer(),
                            Text(r['date'] ?? '', style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Poppins')),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (r['flockName'] != null || r['flockId'] != null)
                          Text('Flock: ${r['flockName'] ?? r['flockId']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: AppColors.textDark)),
                        if (r['rejectionReason'] != null) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.accentRed.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_rounded, size: 14, color: AppColors.accentRed),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(r['rejectionReason'], style: const TextStyle(fontSize: 11, color: AppColors.accentRed, fontFamily: 'Poppins')),
                                ),
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
}
