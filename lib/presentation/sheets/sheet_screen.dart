import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/module_config.dart';
import '../../core/utils/role_guard.dart';
import '../../services/sync_service.dart';
import '../../state/daily_record/daily_record_provider.dart';
import '../../state/auth/auth_provider.dart';
import '../poultry/widgets/poultry_drawer.dart';
import '../poultry/widgets/spreadsheet_table.dart';
import '../poultry/widgets/sheet_tabs.dart' as tabs;
import '../poultry/widgets/status_badge.dart';
import '../poultry/screens/add_record_sheet.dart';

class SheetScreen extends StatefulWidget {
  final String module;
  final String subType;
  final String initialSheet;
  final String? unitId;

  const SheetScreen({
    super.key,
    required this.module,
    this.subType = '',
    this.initialSheet = 'feed',
    this.unitId,
  });

  @override
  State<SheetScreen> createState() => _SheetScreenState();
}

class _SheetScreenState extends State<SheetScreen> {
  late int _subIndex;
  late int _sheetIndex;
  String _searchQuery = '';
  String _statusFilter = 'all';
  int _pendingSyncCount = 0;

  ModuleInfo get _modInfo => ModuleConfig.getModule(widget.module);
  List<String> get _subTypes => _modInfo.subTypes;
  List<String> get _sheetKeys => ModuleConfig.getSheetKeys(widget.module);
  String get _currentSheetKey => _sheetKeys.isNotEmpty ? _sheetKeys[_sheetIndex] : 'feed';
  List<String> get _currentColumns => ModuleConfig.getSheetColumns(widget.module, _currentSheetKey);

  @override
  void initState() {
    super.initState();
    _subIndex = _subTypes.indexOf(widget.subType);
    if (_subIndex < 0) _subIndex = 0;
    _sheetIndex = _sheetKeys.indexOf(widget.initialSheet);
    if (_sheetIndex < 0) _sheetIndex = 0;
    _loadPendingCount();
  }

  Future<void> _loadPendingCount() async {
    final count = await SyncService().getPendingCount();
    if (mounted) setState(() => _pendingSyncCount = count);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DailyRecordProvider>();
    final isEditable = context.canAddEdit;

    final allRecords = provider.records;
    final filtered = allRecords.where((r) {
      final modOk = r.module == widget.module;
      final subOk = _subTypes[_subIndex] == _subTypes.first || r.subType == _subTypes[_subIndex];
      final sheetOk = r.sheetType == _currentSheetKey;
      final unitOk = widget.unitId == null || r.unitId == widget.unitId;
      final flat = r.toFlatMap();
      final searchOk = _searchQuery.isEmpty ||
          flat.values.any((v) => v.toString().toLowerCase().contains(_searchQuery.toLowerCase()));
      final statusOk = _statusFilter == 'all' || r.status == _statusFilter;
      return modOk && subOk && sheetOk && unitOk && searchOk && statusOk;
    }).toList();
    filtered.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: Text('${_capitalize(_currentSheetKey)} — ${_modInfo.label}'),
        actions: [
          if (isEditable)
            IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () => _showAddRecord(context),
            ),
          if (_pendingSyncCount > 0)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.sync),
                  onPressed: () async {
                    await SyncService().syncPendingRecords();
                    await _loadPendingCount();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.cloud_done_rounded, color: Colors.white, size: 20),
                            const SizedBox(width: 10),
                            const Expanded(child: Text('All pending records synced to server', style: TextStyle(fontFamily: 'Poppins', fontSize: 13))),
                          ],
                        ),
                        backgroundColor: const Color(0xFF1B8A3C),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ));
                    }
                  },
                ),
                Positioned(
                  right: 4, top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.accentRed, shape: BoxShape.circle),
                    child: Text('$_pendingSyncCount', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => _showSearch(context),
          ),
        ],
      ),
      drawer: const PoultryDrawer(),
      floatingActionButton: isEditable
          ? FloatingActionButton(
              onPressed: () => _showAddRecord(context),
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          if (_subTypes.length > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: Row(
                children: _subTypes.asMap().entries.map((e) {
                  final isSelected = e.key == _subIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() { _subIndex = e.key; _sheetIndex = 0; }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: isSelected ? _modInfo.color.withValues(alpha: 0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected ? Border.all(color: _modInfo.color, width: 1.5) : null,
                        ),
                        child: Text(
                          _capitalize(e.value),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _modInfo.color, fontFamily: 'Poppins'),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          if (_sheetKeys.isNotEmpty)
            tabs.SheetTabs(
              sheets: _sheetKeys.map((k) => tabs.SheetTabData(label: _capitalize(k))).toList(),
              selectedIndex: _sheetIndex,
              onChanged: (i) => setState(() => _sheetIndex = i),
            ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip('All', _statusFilter == 'all', () => setState(() => _statusFilter = 'all')),
                const SizedBox(width: 8),
                _FilterChip('Pending', _statusFilter == 'pending', () => setState(() => _statusFilter = 'pending')),
                const SizedBox(width: 8),
                _FilterChip('Approved', _statusFilter == 'approved', () => setState(() => _statusFilter = 'approved')),
                const SizedBox(width: 8),
                _FilterChip('Rejected', _statusFilter == 'rejected', () => setState(() => _statusFilter = 'rejected')),
                const Spacer(),
                Text('${filtered.length} records', style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'Poppins')),
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
                        Icon(ModuleConfig.moduleIcon(widget.module), size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        const Text('No records yet', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                        if (isEditable) ...[
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _showAddRecord(context),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add First Record'),
                          ),
                        ],
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: SpreadsheetTable(
                      columns: _currentColumns,
                      rows: filtered.map((r) => r.toFlatMap()).toList(),
                      showStatus: true,
                      showApproval: context.canApprove,
                      onApprove: (row) => _approveRecord(row),
                      onReject: (row) => _rejectRecord(context, row),
                      onTapRow: (row) => _showRowDetail(context, row),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddRecord(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddRecordSheet(
        module: widget.module,
        subType: _subTypes[_subIndex],
        sheetKey: _currentSheetKey,
        columns: _currentColumns,
        unitId: widget.unitId,
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Search Records'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Search any field...', prefixIcon: Icon(Icons.search)),
          onChanged: (v) { setState(() => _searchQuery = v); Navigator.pop(context); },
        ),
      ),
    );
  }

  void _approveRecord(Map<String, dynamic> row) async {
    final provider = context.read<DailyRecordProvider>();
    final auth = context.read<AuthProvider>();
    await provider.updateRecordStatus(row['id'], 'approved', approvedBy: auth.userId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            const Expanded(child: Text('Record approved successfully', style: TextStyle(fontFamily: 'Poppins', fontSize: 13))),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ));
    }
  }

  void _rejectRecord(BuildContext context, Map<String, dynamic> row) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => _RejectDialog(),
    );
    if (reason == null) return;
    final provider = context.read<DailyRecordProvider>();
    await provider.updateRecordStatus(row['id'], 'rejected', rejectionReason: reason);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(Icons.cancel_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text('Rejected: $reason', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13))),
          ],
        ),
        backgroundColor: AppColors.accentRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ));
    }
  }

  void _showRowDetail(BuildContext context, Map<String, dynamic> row) {
    final canDelete = context.canDelete;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RecordDetailSheet(
        row: row,
        canDelete: canDelete,
        onDelete: canDelete ? () => _deleteRecord(row) : null,
      ),
    );
  }

  void _deleteRecord(Map<String, dynamic> row) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Record'),
        content: const Text('Are you sure? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: AppColors.accentRed))),
        ],
      ),
    );
    if (confirmed != true) return;
    final provider = context.read<DailyRecordProvider>();
    final modInfo = ModuleConfig.getModule(row['module'] ?? '');
    final sheetLabel = _capitalize((row['sheetType'] ?? 'record').toString());
    await provider.deleteRecord(row['id']);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text('$sheetLabel record deleted', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13))),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip(this.label, this.selected, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen.withValues(alpha: 0.15) : AppColors.mintGreen,
          borderRadius: BorderRadius.circular(12),
          border: selected ? Border.all(color: AppColors.primaryGreen, width: 1) : null,
        ),
        child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: selected ? AppColors.primaryGreen : AppColors.textMedium, fontFamily: 'Poppins')),
      ),
    );
  }
}

class _RejectDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final presetReasons = [
      'Numbers don\'t match',
      'Missing photo',
      'Cost calculation error',
      'Duplicate entry',
      'Wrong unit selected',
    ];
    return AlertDialog(
      title: const Text('Reject Record'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select a reason:', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          ...presetReasons.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, r),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.backgroundGrey, borderRadius: BorderRadius.circular(8)),
                    child: Text(r, style: const TextStyle(fontSize: 13, fontFamily: 'Poppins')),
                  ),
                ),
              )),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Or type custom reason...', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
            onSubmitted: (v) { if (v.isNotEmpty) Navigator.pop(context, v); },
          ),
        ],
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
    );
  }
}

class _RecordDetailSheet extends StatelessWidget {
  final Map<String, dynamic> row;
  final bool canDelete;
  final VoidCallback? onDelete;

  const _RecordDetailSheet({required this.row, this.canDelete = false, this.onDelete});

  static const _systemKeys = {
    'id', 'module', 'subType', 'sheetType', 'unitId',
    'recordedBy', 'recordedByName', 'approvedBy',
    'status', 'rejectionReason', 'createdAt', 'updatedAt', 'data',
  };

  @override
  Widget build(BuildContext context) {
    final displayFields = row.entries
        .where((e) => !_systemKeys.contains(e.key))
        .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (ctx, scroll) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFB),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: scroll,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.textMuted.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF1B8A3C).withValues(alpha: 0.08), Color(0xFF0EA5E9).withValues(alpha: 0.05)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  StatusBadge(status: row['status'] ?? 'pending'),
                  const Spacer(),
                  Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(row['date'] ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textMuted, fontFamily: 'Poppins')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...displayFields.map((e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(_humanizeKey(e.key), style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontFamily: 'Poppins')),
                  ),
                  Expanded(
                    child: Text(
                      e.value?.toString() ?? '',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark, fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
            )),
            if (row['rejectionReason'] != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.accentRed.withValues(alpha: 0.08), AppColors.accentRed.withValues(alpha: 0.03)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentRed.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_rounded, color: AppColors.accentRed, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(row['rejectionReason'], style: const TextStyle(fontSize: 12, color: AppColors.accentRed, fontFamily: 'Poppins'))),
                  ],
                ),
              ),
            ],
            if (canDelete) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_forever_rounded, size: 18),
                  label: const Text('Delete Record'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentRed,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shadowColor: AppColors.accentRed.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _humanizeKey(String key) {
    if (key.isEmpty) return key;
    return '${key[0].toUpperCase()}${key.substring(1)}';
  }
}
