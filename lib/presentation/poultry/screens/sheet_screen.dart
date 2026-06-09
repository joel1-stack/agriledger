import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/role_guard.dart';
import '../../../services/sync_service.dart';
import '../../../state/poultry/poultry_provider.dart';
import '../../../config/sheet_config.dart';
import '../widgets/poultry_drawer.dart';
import '../widgets/spreadsheet_table.dart';
import '../widgets/sheet_tabs.dart';
import '../widgets/status_badge.dart';
import 'add_record_sheet.dart';

class SheetScreen extends StatefulWidget {
  final String birdType;
  final String initialSheet;
  final String? flockId;

  const SheetScreen({
    super.key,
    required this.birdType,
    this.initialSheet = 'feed',
    this.flockId,
  });

  @override
  State<SheetScreen> createState() => _SheetScreenState();
}

class _SheetScreenState extends State<SheetScreen> {
  late int _birdIndex;
  late int _sheetIndex;
  String _searchQuery = '';
  String _statusFilter = 'all';
  int _pendingSyncCount = 0;

  List<SheetConfig> get _currentSheets => allSheets[birdTypes[_birdIndex]] ?? layerSheets;
  SheetConfig get _currentSheet => _currentSheets[_sheetIndex];

  @override
  void initState() {
    super.initState();
    _birdIndex = birdTypes.indexOf(widget.birdType);
    if (_birdIndex < 0) _birdIndex = 0;
    final sheets = allSheets[widget.birdType] ?? layerSheets;
    _sheetIndex = sheets.indexWhere((s) => s.key == widget.initialSheet);
    if (_sheetIndex < 0) _sheetIndex = 0;
    _loadPendingCount();
  }

  Future<void> _loadPendingCount() async {
    final count = await SyncService().getPendingCount();
    if (mounted) setState(() => _pendingSyncCount = count);
  }

  @override
  Widget build(BuildContext context) {
    final poultry = context.watch<PoultryProvider>();
    final isEditable = context.canAddEdit;

    // Get all records from provider filtered by sheet type
    final allRecords = poultry.allRecords;
    var filtered = allRecords.where((r) {
      final birdOk = r['birdType'] == birdTypes[_birdIndex];
      final sheetOk = r['sheetType'] == _currentSheet.key;
      final flockOk = widget.flockId == null || r['flockId'] == widget.flockId;
      final searchOk = _searchQuery.isEmpty ||
          r.values.any((v) => v.toString().toLowerCase().contains(_searchQuery.toLowerCase()));
      final statusOk = _statusFilter == 'all' || r['status'] == _statusFilter;
      return birdOk && sheetOk && flockOk && searchOk && statusOk;
    }).toList();
    filtered.sort((a, b) => (b['date'] ?? '').toString().compareTo((a['date'] ?? '').toString()));

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: Text('${_currentSheet.label} — ${_capitalize(birdTypes[_birdIndex])}'),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pending records synced')),
                      );
                    }
                  },
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.accentRed,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_pendingSyncCount',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
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
          // Bird Type Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Row(
              children: birdTypes.asMap().entries.map((e) {
                final isSelected = e.key == _birdIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _birdIndex = e.key;
                      _sheetIndex = 0;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: isSelected ? birdTypeColors[e.value]!.withValues(alpha: 0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(color: birdTypeColors[e.value]!, width: 1.5)
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(birdTypeIcons[e.value], size: 16, color: birdTypeColors[e.value]),
                          const SizedBox(width: 4),
                          Text(
                            _capitalize(e.value),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: birdTypeColors[e.value],
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Sheet Type Tabs
          SheetTabs(
            sheets: _currentSheets,
            selectedIndex: _sheetIndex,
            onChanged: (i) => setState(() => _sheetIndex = i),
          ),
          const SizedBox(height: 8),

          // Status Filter
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

          // Spreadsheet Table
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_currentSheet.icon, size: 48, color: AppColors.textMuted),
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
                      columns: _currentSheet.columns,
                      rows: filtered,
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
        birdType: birdTypes[_birdIndex],
        sheetConfig: _currentSheet,
        flockId: widget.flockId,
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
          decoration: const InputDecoration(
            hintText: 'Search any field...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (v) {
            setState(() => _searchQuery = v);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _approveRecord(Map<String, dynamic> row) async {
    final poultry = context.read<PoultryProvider>();
    await poultry.updateRecordStatus(row['id'], 'approved');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record approved'), backgroundColor: AppColors.primaryGreen),
      );
    }
  }

  void _rejectRecord(BuildContext context, Map<String, dynamic> row) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => _RejectDialog(),
    );
    if (reason == null) return;
    final poultry = context.read<PoultryProvider>();
    await poultry.updateRecordStatus(row['id'], 'rejected', rejectionReason: reason);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rejected: $reason'), backgroundColor: AppColors.accentRed),
      );
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
        columns: _currentSheet.columns,
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
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.accentRed)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final poultry = context.read<PoultryProvider>();
    await poultry.deleteRecord(row['id'], row['sheetType']);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record deleted'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
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
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.primaryGreen : AppColors.textMedium,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}

class _RejectDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final presetReasons = [
      'Numbers don\'t match flock count',
      'Missing photo for mortality',
      'Cost calculation error',
      'Duplicate entry',
      'Wrong flock selected',
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
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(r, style: const TextStyle(fontSize: 13, fontFamily: 'Poppins')),
                  ),
                ),
              )),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Or type custom reason...',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
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

class _RecordDetailSheet extends StatelessWidget {
  final Map<String, dynamic> row;
  final List<SheetColumn> columns;
  final bool canDelete;
  final VoidCallback? onDelete;

  const _RecordDetailSheet({required this.row, required this.columns, this.canDelete = false, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (ctx, scroll) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: scroll,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                StatusBadge(status: row['status'] ?? 'pending'),
                const Spacer(),
                Text(
                  row['date'] ?? '',
                  style: const TextStyle(fontSize: 13, color: AppColors.textMuted, fontFamily: 'Poppins'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...columns.map((c) {
              final val = row[c.key]?.toString() ?? '';
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        c.label,
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontFamily: 'Poppins'),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        c.isCurrency ? 'KES ${_fmt(double.tryParse(val) ?? 0)}' : val,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark, fontFamily: 'Poppins'),
                      ),
                    ),
                  ],
                ),
              );
            }),
            if (row['rejectionReason'] != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentRed.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentRed.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_rounded, color: AppColors.accentRed, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        row['rejectionReason'],
                        style: const TextStyle(fontSize: 12, color: AppColors.accentRed, fontFamily: 'Poppins'),
                      ),
                    ),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _fmt(double v) => v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}K' : v.toStringAsFixed(0);
}

