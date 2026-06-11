import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/module_config.dart';
import '../../../core/utils/role_guard.dart';
import '../../../services/sync_service.dart';
import '../../../state/daily_record/daily_record_provider.dart';
import '../../../state/auth/auth_provider.dart';

const _moduleImages = {
  'poultry': 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=600&q=80',
  'dairy': 'https://images.unsplash.com/photo-1564135625714-0e0a2e1b39f9?auto=format&fit=crop&w=600&q=80',
  'crops': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=600&q=80',
  'livestock': 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=600&q=80',
  'property': 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&w=600&q=80',
  'transport': 'https://images.unsplash.com/photo-1519003722824-194d4455a60c?auto=format&fit=crop&w=600&q=80',
  'cashbook': 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&w=600&q=80',
  'inventory': 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=600&q=80',
  'journal': 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?auto=format&fit=crop&w=600&q=80',
  'contracts': 'https://images.unsplash.com/photo-1507925921958-8a62f3d1a50d?auto=format&fit=crop&w=600&q=80',
};

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

class _AddRecordSheetState extends State<AddRecordSheet> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;
  late Map<String, String> _dropdownValues;
  late String _date;
  bool _submitting = false;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnim;

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
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) { c.dispose(); }
    _slideController.dispose();
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
    final imgUrl = _moduleImages[widget.module] ?? _moduleImages['crops']!;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFB),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                          child: SizedBox(
                            height: 200,
                            child: Image.network(imgUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: modInfo.color)),
                          ),
                        ),
                        Positioned(
                          top: 16, right: 16,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), shape: BoxShape.circle, border: Border.all(color: Colors.white.withValues(alpha: 0.4))),
                              child: const Icon(Icons.close, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20, left: 20, right: 20,
                          child: SlideTransition(
                            position: _slideAnim,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_capitalize(widget.sheetKey), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'Poppins', shadows: [Shadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 3)), Shadow(color: Colors.black26, blurRadius: 24, offset: Offset(0, 6))])),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.circle, size: 8, color: Colors.white),
                                          const SizedBox(width: 6),
                                          Text('${modInfo.label} • ${_capitalize(widget.subType)}', style: const TextStyle(fontSize: 13, color: Colors.white, fontFamily: 'Poppins', shadows: [Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2)), Shadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 4))])),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Column(
                        children: columns.map((col) {
                          if (col.toLowerCase() == 'date') {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: TextFormField(
                                controller: _controllers[col],
                                decoration: _input(col, Icons.calendar_today_rounded, modInfo.color),
                                readOnly: true,
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2024),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setState(() { _controllers[col]!.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}'; });
                                  }
                                },
                              ),
                            );
                          }
                          if (_isDropdown(col)) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: DropdownButtonFormField<String>(
                                initialValue: _dropdownValues[col],
                                decoration: _input(col, Icons.arrow_drop_down_rounded, modInfo.color),
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
                            padding: const EdgeInsets.only(bottom: 14),
                            child: TextFormField(
                              controller: _controllers[col],
                              decoration: _input(col, isNumeric ? Icons.numbers_rounded : Icons.text_fields_rounded, modInfo.color),
                              keyboardType: isNumeric ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
                              inputFormatters: isNumeric ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))] : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<bool>(
                      future: SyncService().isOnline(),
                      builder: (ctx, snap) {
                        if (snap.data == false) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.amber.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.wifi_off_rounded, size: 18, color: Colors.amber.shade800),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text('You are offline — record will sync when connected', style: TextStyle(color: Colors.amber.shade900, fontSize: 12, fontFamily: 'Poppins'))),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity, height: 56,
                        child: ElevatedButton(
                          onPressed: isEditable && !_submitting ? _submit : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: modInfo.color,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: modInfo.color.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _submitting
                              ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle_rounded, size: 20),
                                    const SizedBox(width: 8),
                                    Text('Add ${_capitalize(widget.sheetKey)} Record', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _input(String label, IconData icon, Color color) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
      hintText: 'Enter $label',
      hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey.shade400),
      prefixIcon: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 18, color: color),
      ),
      filled: true,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: color, width: 2)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
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
    final modInfo = ModuleConfig.getModule(widget.module);
    final sheetLabel = _capitalize(widget.sheetKey);
    final modLabel = modInfo.label;

    try {
      if (online) {
        await provider.addRecord(data);
      } else {
        await SyncService().queueRecord(data);
      }
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Icon(online ? Icons.check_circle_rounded : Icons.cloud_done_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(online ? '$sheetLabel recorded for $modLabel' : '$sheetLabel saved offline — will sync later', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13))),
            ],
          ),
          backgroundColor: online ? modInfo.color : Colors.amber.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          duration: const Duration(seconds: 3),
        ));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text('Failed: ${e.toString().substring(0, 80)}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13))),
            ],
          ),
          backgroundColor: AppColors.accentRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ));
      }
    }
  }

  String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
