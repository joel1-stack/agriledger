import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/module_config.dart';
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
  String _statusFilter = 'pending';
  final Set<String> _loadingIds = {};

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DailyRecordProvider>();
    final auth = context.watch<AuthProvider>();
    final allRecords = provider.records;
    final filtered = allRecords.where((r) {
      if (_statusFilter != 'all' && r.status != _statusFilter) return false;
      if (_selectedModule != 'all' && r.module != _selectedModule) return false;
      if (_selectedSheetType != 'all' && r.sheetType != _selectedSheetType) return false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B8A3C),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Approvals', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('${filtered.length} records', style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Poppins')),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _filterChip('Pending', _statusFilter == 'pending', const Color(0xFFF59E0B)),
                const SizedBox(width: 6),
                _filterChip('Approved', _statusFilter == 'approved', const Color(0xFF10B981)),
                const SizedBox(width: 6),
                _filterChip('Rejected', _statusFilter == 'rejected', const Color(0xFFEF4444)),
                const SizedBox(width: 6),
                _filterChip('All', _statusFilter == 'all', const Color(0xFF64748B)),
                const Spacer(),
                Text('${filtered.length}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF64748B), fontFamily: 'Poppins')),
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
                        isSuperAdmin: auth.isSuperAdmin,
                        isLoading: _loadingIds.contains(r.id),
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

  Widget _filterChip(String label, bool selected, Color color) {
    return GestureDetector(
      onTap: () => setState(() => _statusFilter = selected ? _statusFilter : label.toLowerCase()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: selected ? Colors.white : const Color(0xFF64748B), fontFamily: 'Poppins')),
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
    setState(() => _loadingIds.add(r.id));
    final provider = context.read<DailyRecordProvider>();
    final auth = context.read<AuthProvider>();
    await provider.updateRecordStatus(r.id, 'approved', approvedBy: auth.userId);
    if (mounted) {
      setState(() => _loadingIds.remove(r.id));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text('${_capitalize(r.sheetType ?? "record")} approved', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13))),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ));
    }
  }

  void _reject(dynamic r) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => _RejectDialog(),
    );
    if (reason == null) return;
    setState(() => _loadingIds.add(r.id));
    final provider = context.read<DailyRecordProvider>();
    await provider.updateRecordStatus(r.id, 'rejected', rejectionReason: reason);
    if (mounted) {
      setState(() => _loadingIds.remove(r.id));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(Icons.cancel_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text('${_capitalize(r.sheetType ?? "record")} rejected: $reason', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13))),
          ],
        ),
        backgroundColor: AppColors.accentRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ));
    }
  }

  String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

class _ApprovalCard extends StatelessWidget {
  final dynamic record;
  final bool isSuperAdmin;
  final bool isLoading;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _ApprovalCard({required this.record, this.isSuperAdmin = false, this.isLoading = false, required this.onApprove, required this.onReject});

  @override
  Widget build(BuildContext context) {
    final module = record.module ?? 'poultry';
    final sheetType = record.sheetType ?? '';
    final modColor = ModuleConfig.moduleColor(module);
    final modLabel = ModuleConfig.moduleLabel(module);
    final sheetKeys = ModuleConfig.getSheetKeys(module);
    final sheetLabel = sheetKeys.contains(sheetType) ? _capitalize(sheetType) : sheetType;
    final flat = record.toFlatMap();
    final amount = _extractAmount(flat);
    final needsSuperAdmin = amount >= 15000 && !isSuperAdmin;

    const moduleImages = {
      'poultry': 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=200&q=80',
      'dairy': 'https://images.unsplash.com/photo-1570042225831-d98af757d3e2?w=200&q=80',
      'crops': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=200&q=80',
      'livestock': 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=200&q=80',
      'property': 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=200&q=80',
      'transport': 'https://images.unsplash.com/photo-1519003722824-194d4455a60c?w=200&q=80',
      'cashbook': 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=200&q=80',
      'inventory': 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=200&q=80',
      'journal': 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=200&q=80',
      'contracts': 'https://images.unsplash.com/photo-1507925921958-8a62f3d1a50d?w=200&q=80',
    };
    final imgUrl = moduleImages[module] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              image: imgUrl.isNotEmpty ? DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover) : null,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(ModuleConfig.moduleIcon(module), size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(modLabel, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(sheetLabel, style: const TextStyle(fontSize: 11, color: Colors.white70, fontFamily: 'Poppins')),
                      const Spacer(),
                      Text(_formatDate(record.date), style: const TextStyle(fontSize: 11, color: Colors.white70, fontFamily: 'Poppins')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.pin_drop_rounded, size: 13, color: modColor),
                    const SizedBox(width: 4),
                    Text('Unit: ${record.unitId}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: const Color(0xFF0F172A))),
                    const Spacer(),
                    Text(record.createdAt.toString().substring(0, 16), style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontFamily: 'Poppins')),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person_rounded, size: 12, color: const Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text('By: ${record.recordedByName ?? record.recordedBy ?? 'Worker'}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontFamily: 'Poppins')),
                  ],
                ),
                if (amount > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.monetization_on_rounded, size: 12, color: needsSuperAdmin ? const Color(0xFFEF4444) : modColor),
                      const SizedBox(width: 4),
                      Text('Amount: KES ${_fmt(amount)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: needsSuperAdmin ? const Color(0xFFEF4444) : const Color(0xFF0F172A))),
                      if (needsSuperAdmin) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFEF4444).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                          child: const Text('Super Admin only', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Color(0xFFEF4444), fontFamily: 'Poppins')),
                        ),
                      ],
                    ],
                  ),
                ],
                if (flat['Notes'] != null || flat['notes'] != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Icon(Icons.notes_rounded, size: 12, color: const Color(0xFF94A3B8)),
                        const SizedBox(width: 6),
                        Expanded(child: Text('${flat['Notes'] ?? flat['notes']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontFamily: 'Poppins'))),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                  child: isLoading
                      ? const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                      : ElevatedButton.icon(
                          onPressed: needsSuperAdmin ? null : onApprove,
                          icon: Icon(Icons.check_circle_rounded, size: 18, color: needsSuperAdmin ? const Color(0xFF94A3B8) : Colors.white),
                          label: Text(needsSuperAdmin ? 'Locked' : 'Approve', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: needsSuperAdmin ? const Color(0xFF94A3B8) : Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: needsSuperAdmin ? const Color(0xFFE2E8F0) : const Color(0xFF1B8A3C),
                            foregroundColor: needsSuperAdmin ? const Color(0xFF94A3B8) : Colors.white,
                            disabledBackgroundColor: const Color(0xFFE2E8F0),
                            disabledForegroundColor: const Color(0xFF94A3B8),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: needsSuperAdmin ? 0 : 2,
                            shadowColor: needsSuperAdmin ? Colors.transparent : const Color(0xFF1B8A3C).withValues(alpha: 0.4),
                        ),
                      ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: isLoading
                      ? const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                      : ElevatedButton.icon(
                          onPressed: onReject,
                          icon: const Icon(Icons.cancel_rounded, size: 18),
                          label: const Text('Reject', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                            shadowColor: AppColors.accentRed.withValues(alpha: 0.4),
                          ),
                        ),
                ),
              ],
            ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _extractAmount(Map<String, dynamic> flat) {
    const candidates = ['totalCost', 'totalRevenue', 'amount', 'cost', 'netPay', 'revenue', 'income', 'value', 'total', 'price'];
    for (final key in candidates) {
      final v = flat[key];
      if (v != null) {
        final n = double.tryParse('$v');
        if (n != null && n > 0) return n;
      }
    }
    return 0;
  }

  String _fmt(double v) => v >= 1000000 ? '${(v / 1000000).toStringAsFixed(1)}M' : v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}K' : v.toStringAsFixed(0);

  String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _formatDate(dynamic d) {
    if (d == null) return '';
    if (d is DateTime) return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return d.toString();
  }
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
