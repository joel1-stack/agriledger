import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/module_config.dart';
import '../../../core/utils/role_guard.dart';
import '../../../services/sync_service.dart';
import '../../../state/daily_record/daily_record_provider.dart';
import '../../../state/auth/auth_provider.dart';

class AddRecordSheet extends StatefulWidget {
  final String module;
  final String subType;
  final String sheetKey;
  final List<String> columns;
  final String? unitId;

  const AddRecordSheet({
    super.key,
    required this.module,
    required this.subType,
    required this.sheetKey,
    required this.columns,
    this.unitId,
  });

  @override
  State<AddRecordSheet> createState() => _AddRecordSheetState();
}

class _AddRecordSheetState extends State<AddRecordSheet> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;
  late Map<String, String> _dropdownValues;
  late String _date;

  @override
  void initState() {
    super.initState();
    _date = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
    _controllers = {};
    _dropdownValues = {};
    for (final col in widget.columns) {
      if (col.toLowerCase() == 'date') {
        _controllers[col] = TextEditingController(text: _date);
      } else if (_isDropdown(col)) {
        _dropdownValues[col] = _dropdownOptions(col).first;
      } else {
        _controllers[col] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) { c.dispose(); }
    super.dispose();
  }

  bool _isDropdown(String col) {
    final colLower = col.toLowerCase();
    final dropCols = ['type', 'cause', 'item', 'category', 'method', 'quality', 'unit', 'condition', 'status'];
    return dropCols.any((d) => colLower.contains(d)) && !colLower.contains('date');
  }

  List<String> _dropdownOptions(String col) {
    final colLower = col.toLowerCase();
    if (colLower.contains('cause') || colLower.contains('reason')) return ['Disease', 'Predator', 'Heat', 'Injury', 'Unknown'];
    if (colLower.contains('quality')) return ['Grade A', 'Grade B', 'Grade C'];
    if (colLower.contains('condition')) return ['Good', 'Fair', 'Poor'];
    if (colLower.contains('method')) return ['AI', 'Natural'];
    if (colLower.contains('type')) return ['Type A', 'Type B', 'Type C'];
    if (colLower.contains('category')) return ['General', 'Specific'];
    if (colLower.contains('status')) return ['Active', 'Inactive'];
    return ['Option 1', 'Option 2'];
  }

  @override
  Widget build(BuildContext context) {
    final columns = widget.columns;
    final isEditable = context.canAddEdit;
    final modInfo = ModuleConfig.getModule(widget.module);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.textMuted.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: modInfo.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(modInfo.icon, color: modInfo.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add ${_capitalize(widget.sheetKey)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Poppins', color: AppColors.textDark)),
                      Text('${modInfo.label} • ${_capitalize(widget.subType)}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontFamily: 'Poppins')),
                    ],
                  ),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: columns.length + 1,
                  itemBuilder: (_, i) {
                    if (i == columns.length) {
                      return Column(
                        children: [
                          FutureBuilder<bool>(
                            future: SyncService().isOnline(),
                            builder: (ctx, snap) {
                              if (snap.data == false) {
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Icon(Icons.cloud_off, size: 16, color: Colors.amber.shade800),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text('Offline — saved locally, will sync later', style: TextStyle(color: Colors.amber.shade900, fontSize: 12, fontFamily: 'Poppins'))),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          SizedBox(
                            width: double.infinity, height: 52,
                            child: ElevatedButton(
                              onPressed: isEditable ? _submit : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text('Submit Record', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                            ),
                          ),
                        ],
                      );
                    }

                    final col = columns[i];
                    if (col.toLowerCase() == 'date') {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: _controllers[col],
                          decoration: _input(col, Icons.calendar_today_rounded),
                          readOnly: true,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2024),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              _controllers[col]!.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                            }
                          },
                        ),
                      );
                    }

                    if (_isDropdown(col)) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DropdownButtonFormField<String>(
                          initialValue: _dropdownValues[col],
                          decoration: _input(col, Icons.arrow_drop_down_rounded),
                          items: _dropdownOptions(col).map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontFamily: 'Poppins')))).toList(),
                          onChanged: (v) => setState(() => _dropdownValues[col] = v ?? ''),
                        ),
                      );
                    }

                    final isNumeric = col.toLowerCase().contains('qty') || col.toLowerCase().contains('kg') ||
                        col.toLowerCase().contains('cost') || col.toLowerCase().contains('price') ||
                        col.toLowerCase().contains('amount') || col.toLowerCase().contains('total') ||
                        col.toLowerCase().contains('rate') || col.toLowerCase().contains('litres') ||
                        col.toLowerCase().contains('hours') || col.toLowerCase().contains('sample');

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        controller: _controllers[col],
                        decoration: _input(col, isNumeric ? Icons.numbers_rounded : Icons.text_fields_rounded),
                        keyboardType: isNumeric ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
                        inputFormatters: isNumeric ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))] : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
      prefixIcon: Icon(icon, size: 18),
      filled: true,
      fillColor: AppColors.backgroundGrey,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<DailyRecordProvider>();
    final auth = context.read<AuthProvider>();

    final fields = <String, dynamic>{};
    for (final col in widget.columns) {
      if (_isDropdown(col)) {
        fields[col] = _dropdownValues[col] ?? '';
      } else if (col.toLowerCase().contains('qty') || col.toLowerCase().contains('kg') ||
          col.toLowerCase().contains('cost') || col.toLowerCase().contains('price') ||
          col.toLowerCase().contains('amount') || col.toLowerCase().contains('total') ||
          col.toLowerCase().contains('rate') || col.toLowerCase().contains('litres') ||
          col.toLowerCase().contains('hours') || col.toLowerCase().contains('sample')) {
        fields[col] = double.tryParse(_controllers[col]?.text ?? '') ?? 0;
      } else {
        fields[col] = _controllers[col]?.text ?? '';
      }
    }

    final data = <String, dynamic>{
      'module': widget.module,
      'subType': widget.subType,
      'sheetType': widget.sheetKey,
      'unitId': widget.unitId ?? '',
      'date': _controllers['Date']?.text ?? _date,
      'status': 'pending',
      'recordedBy': auth.userId,
      'recordedByName': auth.displayName,
      'data': fields,
    };

    final online = await SyncService().isOnline();
    if (online) {
      await provider.addRecord(data);
    } else {
      await SyncService().queueRecord(data);
    }
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(online ? 'Record submitted for approval' : 'Saved offline, will sync when connected'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
    }
  }

  String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
