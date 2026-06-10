import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/complete_module_config.dart';
import '../../../data/models/daily_record_model.dart';
import '../../../services/complete_records_service.dart';
import '../../../state/auth/auth_provider.dart';
import '../widgets/status_badge.dart';

/// Complete Manager Dashboard - Unified approval queue for all modules
class CompleteManagerDashboard extends StatefulWidget {
  const CompleteManagerDashboard({super.key});

  @override
  State<CompleteManagerDashboard> createState() =>
      _CompleteManagerDashboardState();
}

class _CompleteManagerDashboardState extends State<CompleteManagerDashboard>
    with SingleTickerProviderStateMixin {
  final _service = CompleteRecordsService();
  late TabController _tabController;
  String _selectedModule = '';
  Map<String, int> _pendingCounts = {};

  @override
  void initState() {
    super.initState();
    _loadPendingCounts();
    _tabController = TabController(
      length: ModuleSheetConfig.getAllModules().length + 1,
      vsync: this,
    );
  }

  void _loadPendingCounts() async {
    final counts = await _service.getPendingCountByModule();
    setState(() => _pendingCounts = counts);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modules = ModuleSheetConfig.getAllModules();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Queue'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(
              text: _buildTabLabel(
                'All',
                _pendingCounts.values.fold(0, (a, b) => a + b),
              ),
            ),
            ...modules.map(
              (module) => Tab(
                text: _buildTabLabel(
                  ModuleSheetConfig.getModuleIcon(module),
                  _pendingCounts[module] ?? 0,
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Modules Tab
          _buildAllModulesView(modules),
          // Individual Module Tabs
          ...modules.map((module) => _buildModuleView(module)),
        ],
      ),
    );
  }

  String _buildTabLabel(String label, int count) {
    if (count == 0) return label;
    return '$label ($count)';
  }

  Widget _buildAllModulesView(List<String> modules) {
    return StreamBuilder<List<DailyRecord>>(
      stream: _service.getPendingRecords(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No pending records',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        final records = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: records.length,
          itemBuilder: (context, index) =>
              _buildRecordCard(context, records[index]),
        );
      },
    );
  }

  Widget _buildModuleView(String module) {
    return StreamBuilder<List<DailyRecord>>(
      stream: _service.getModuleRecords(module),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No records for ${ModuleSheetConfig.getModuleName(module)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        final records = snapshot.data!
            .where((r) => r.status == 'pending')
            .toList();

        if (records.isEmpty) {
          return Center(
            child: Text(
              'No pending records',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: records.length,
          itemBuilder: (context, index) =>
              _buildRecordCard(context, records[index]),
        );
      },
    );
  }

  Widget _buildRecordCard(BuildContext context, DailyRecord record) {
    final config = ModuleSheetConfig.getModuleConfig(record.module);
    final moduleColor = Color(ModuleSheetConfig.getModuleColor(record.module));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: moduleColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            ModuleSheetConfig.getModuleIcon(record.module),
            style: const TextStyle(fontSize: 24),
          ),
        ),
        title: Text(
          '${record.module.toUpperCase()} - ${record.sheetType}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unit: ${record.unitId}'),
            Text('Date: ${DateFormat.yMd().format(record.date)}'),
            if (record.recordedByName != null)
              Text('By: ${record.recordedByName}'),
          ],
        ),
        trailing: StatusBadge(status: record.status),
        onTap: () => _showApprovalDetail(context, record),
      ),
    );
  }

  void _showApprovalDetail(BuildContext context, DailyRecord record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ApprovalDetailSheet(record: record),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadPendingCounts();
    }
  }
}

class _ApprovalDetailSheet extends StatefulWidget {
  final DailyRecord record;

  const _ApprovalDetailSheet({required this.record});

  @override
  State<_ApprovalDetailSheet> createState() => _ApprovalDetailSheetState();
}

class _ApprovalDetailSheetState extends State<_ApprovalDetailSheet> {
  final _reasonController = TextEditingController();
  final _service = CompleteRecordsService();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final config = ModuleSheetConfig.getModuleConfig(widget.record.module);
    final moduleColor = Color(
      ModuleSheetConfig.getModuleColor(widget.record.module),
    );
    final columns = ModuleSheetConfig.getColumns(
      widget.record.module,
      widget.record.subType,
      widget.record.sheetType,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: moduleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ModuleSheetConfig.getModuleIcon(widget.record.module),
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.record.module.toUpperCase(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.record.sheetType,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: widget.record.status),
              ],
            ),
            const SizedBox(height: 24),

            // Record Metadata
            _buildInfoRow('Unit:', widget.record.unitId),
            _buildInfoRow('Date:', DateFormat.yMd().format(widget.record.date)),
            if (widget.record.recordedByName != null)
              _buildInfoRow('Submitted by:', widget.record.recordedByName!),
            const SizedBox(height: 16),

            // Record Data
            Text(
              'Data',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columns.isNotEmpty
                    ? columns.map((col) {
                        final key = col['key'] as String;
                        final label = col['label'] as String;
                        final value = widget.record.data[key];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                value?.toString() ?? 'N/A',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                    : [
                        ...widget.record.data.entries.map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text(e.key), Text(e.value.toString())],
                            ),
                          ),
                        ),
                      ],
              ),
            ),
            const SizedBox(height: 24),

            // Approval Actions
            if (widget.record.isPending) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isProcessing
                          ? null
                          : () => _approve(context, auth.userId),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isProcessing ? null : _showRejectDialog,
                      icon: const Icon(Icons.cancel),
                      label: const Text('Reject'),
                    ),
                  ),
                ],
              ),
            ] else if (widget.record.isRejected) ...[
              const SizedBox(height: 16),
              Text(
                'Rejection Reason',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.record.rejectionReason ?? 'No reason provided',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  void _approve(BuildContext context, String managerId) async {
    setState(() => _isProcessing = true);
    try {
      await _service.approveRecord(widget.record.id, managerId);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Record approved')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showRejectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Record'),
        content: TextField(
          controller: _reasonController,
          decoration: const InputDecoration(
            hintText: 'Enter rejection reason',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _reject(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _reject(BuildContext context) async {
    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a rejection reason')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    setState(() => _isProcessing = true);

    try {
      await _service.rejectRecord(
        widget.record.id,
        auth.userId,
        _reasonController.text,
      );
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('❌ Record rejected')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}
