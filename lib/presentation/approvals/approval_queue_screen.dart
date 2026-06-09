import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../state/poultry/poultry_provider.dart';
import '../../config/sheet_config.dart';
import '../poultry/widgets/poultry_drawer.dart';

class ApprovalQueueScreen extends StatefulWidget {
  const ApprovalQueueScreen({super.key});

  @override
  State<ApprovalQueueScreen> createState() => _ApprovalQueueScreenState();
}

class _ApprovalQueueScreenState extends State<ApprovalQueueScreen> {
  String _selectedBirdType = 'all';
  String _selectedSheetType = 'all';

  @override
  Widget build(BuildContext context) {
    final poultry = context.watch<PoultryProvider>();
    final pending = poultry.allRecords.where((r) => r['status'] == 'pending').toList();
    final filtered = pending.where((r) {
      if (_selectedBirdType != 'all' && r['birdType'] != _selectedBirdType) return false;
      if (_selectedSheetType != 'all' && r['sheetType'] != _selectedSheetType) return false;
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
          // Filters
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: _DropdownFilter('Bird Type', _selectedBirdType, ['all', ...birdTypes], (v) => setState(() => _selectedBirdType = v)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DropdownFilter('Sheet Type', _selectedSheetType,
                      ['all', ...allSheets.values.expand((s) => s).map((s) => s.key).toSet()], (v) => setState(() => _selectedSheetType = v)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Pending list
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

  void _approve(Map<String, dynamic> r) async {
    await context.read<PoultryProvider>().updateRecordStatus(r['id'], 'approved');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Approved'), backgroundColor: AppColors.primaryGreen),
      );
    }
  }

  void _reject(Map<String, dynamic> r) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => _RejectDialog(),
    );
    if (reason == null) return;
    await context.read<PoultryProvider>().updateRecordStatus(r['id'], 'rejected', rejectionReason: reason);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rejected'), backgroundColor: AppColors.accentRed),
      );
    }
  }
}

class _DropdownFilter extends StatelessWidget {
  final String label, value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  const _DropdownFilter(this.label, this.value, this.items, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        filled: true,
        fillColor: AppColors.backgroundGrey,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(_capitalize(i), style: const TextStyle(fontSize: 12, fontFamily: 'Poppins')))).toList(),
      onChanged: (v) => onChanged(v ?? 'all'),
    );
  }

  String _capitalize(String s) => s == 'all' ? 'All' : s[0].toUpperCase() + s.substring(1);
}

class _ApprovalCard extends StatelessWidget {
  final Map<String, dynamic> record;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _ApprovalCard({required this.record, required this.onApprove, required this.onReject});

  @override
  Widget build(BuildContext context) {
    final birdType = record['birdType'] ?? 'layers';
    final sheetType = record['sheetType'] ?? 'feed';
    final sheetConfig = allSheets[birdType]?.firstWhere((s) => s.key == sheetType, orElse: () => layerSheets.first);

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
                    color: birdTypeColors[birdType]?.withValues(alpha: 0.15) ?? AppColors.mintGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_capitalize(birdType), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: birdTypeColors[birdType])),
                ),
                const SizedBox(width: 6),
                if (sheetConfig != null) ...[
                  Icon(sheetConfig.icon, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(sheetConfig.label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Poppins')),
                ],
                const Spacer(),
                Text(record['date'] ?? '', style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Poppins')),
              ],
            ),
            const SizedBox(height: 8),
            Text('Flock: ${record['flockName'] ?? record['flockId'] ?? 'N/A'}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: AppColors.textDark)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.person_rounded, size: 12, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text('By: ${record['recordedBy'] ?? 'Worker'}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Poppins')),
                const Spacer(),
                Text(record['createdAt']?.toString().substring(0, 16) ?? '', style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontFamily: 'Poppins')),
              ],
            ),
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

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}

class _RejectDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final reasons = ['Numbers don\'t match', 'Missing photo', 'Cost error', 'Duplicate', 'Wrong flock'];
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
            onSubmitted: (v) {
              if (v.isNotEmpty) Navigator.pop(context, v);
            },
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      ],
    );
  }
}

