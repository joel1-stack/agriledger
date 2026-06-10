import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/module_config.dart';
import '../../core/utils/role_guard.dart';
import '../../state/daily_record/daily_record_provider.dart';
import '../../state/auth/auth_provider.dart';
import '../poultry/widgets/poultry_drawer.dart';

class ApprovalQueueScreen extends StatefulWidget {
  const ApprovalQueueScreen({super.key});

  @override
  State<ApprovalQueueScreen> createState() => _ApprovalQueueScreenState();
}

class _ApprovalQueueScreenState extends State<ApprovalQueueScreen> {
  String _selectedModule = 'all';
  String _selectedSheetType = 'all';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DailyRecordProvider>();
    final pending = provider.pendingRecords;
    final filtered = pending.where((r) {
      if (_selectedModule != 'all' && r.module != _selectedModule) return false;
      if (_selectedSheetType != 'all' && r.sheetType != _selectedSheetType) return false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Approval Queue'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('${filtered.length} pending', style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Poppins')),
          ),
        ],
      ),
      drawer: const PoultryDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedModule,
                    decoration: _input('Module', Icons.category_rounded),
                    items: ['all', ...ModuleConfig.moduleIds].map((m) => DropdownMenuItem(
                      value: m,
                      child: Text(m == 'all' ? 'All Modules' : ModuleConfig.moduleLabel(m), style: const TextStyle(fontSize: 12, fontFamily: 'Poppins')),
                    )).toList(),
                    onChanged: (v) => setState(() => _selectedModule = v ?? 'all'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedSheetType,
                    decoration: _input('Sheet Type', Icons.description_rounded),
                    items: ['all', ...ModuleConfig.moduleIds.expand((m) => ModuleConfig.getSheetKeys(m)).toSet()].map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(_capitalize(s), style: const TextStyle(fontSize: 12, fontFamily: 'Poppins')),
                    )).toList(),
                    onChanged: (v) => setState(() => _selectedSheetType = v ?? 'all'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 64, color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                        const SizedBox(height: 12),
                        const Text('All caught up!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                        const Text('No pending approvals', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final r = filtered[i];
                      return _ApprovalCard(
                        record: r,
                        onApprove: () => _approve(r),
                        onReject: () => _reject(r),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  InputDecoration _input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11),
      prefixIcon: Icon(icon, size: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      filled: true,
      fillColor: AppColors.backgroundGrey,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    );
  }

  void _approve(dynamic r) async {
    final provider = context.read<DailyRecordProvider>();
    final auth = context.read<AuthProvider>();
    await provider.updateRecordStatus(r.id, 'approved', approvedBy: auth.userId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Approved'), backgroundColor: AppColors.primaryGreen),
      );
    }
  }

  void _reject(dynamic r) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => _RejectDialog(),
    );
    if (reason == null) return;
    final provider = context.read<DailyRecordProvider>();
    await provider.updateRecordStatus(r.id, 'rejected', rejectionReason: reason);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rejected'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

class _ApprovalCard extends StatelessWidget {
  final dynamic record;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _ApprovalCard({required this.record, required this.onApprove, required this.onReject});

  @override
  Widget build(BuildContext context) {
    final module = record.module ?? 'poultry';
    final sheetType = record.sheetType ?? '';
    final modColor = ModuleConfig.moduleColor(module);
    final modLabel = ModuleConfig.moduleLabel(module);
    final sheetKeys = ModuleConfig.getSheetKeys(module);
    final sheetLabel = sheetKeys.contains(sheetType) ? _capitalize(sheetType) : sheetType;
    final flat = record.toFlatMap();

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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: modColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(ModuleConfig.moduleIcon(module), size: 12, color: modColor),
                      const SizedBox(width: 4),
                      Text(modLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: modColor)),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(sheetLabel, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Poppins')),
                const Spacer(),
                Text(record.date, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Poppins')),
              ],
            ),
            const SizedBox(height: 8),
            Text('Unit: ${record.unitId}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: AppColors.textDark)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.person_rounded, size: 12, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text('By: ${record.recordedByName ?? record.recordedBy ?? 'Worker'}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Poppins')),
                const Spacer(),
                Text(record.createdAt.toString().substring(0, 16), style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontFamily: 'Poppins')),
              ],
            ),
            if (flat['Notes'] != null || flat['notes'] != null) ...[
              const SizedBox(height: 6),
              Text('Notes: ${flat['Notes'] ?? flat['notes']}', style: const TextStyle(fontSize: 11, color: AppColors.textMedium, fontFamily: 'Poppins')),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check_circle_rounded, size: 18),
                    label: const Text('Approve', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.cancel_rounded, size: 18),
                    label: const Text('Reject', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accentRed,
                      side: const BorderSide(color: AppColors.accentRed),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

class _RejectDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final reasons = ['Numbers don\'t match', 'Missing information', 'Cost error', 'Duplicate', 'Wrong unit'];
    return AlertDialog(
      title: const Text('Reject Record'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...reasons.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, r),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.backgroundGrey, borderRadius: BorderRadius.circular(8)),
                    child: Text(r, style: const TextStyle(fontFamily: 'Poppins')),
                  ),
                ),
              )),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Custom reason...', isDense: true),
            onSubmitted: (v) { if (v.isNotEmpty) Navigator.pop(context, v); },
          ),
        ],
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
    );
  }
}
