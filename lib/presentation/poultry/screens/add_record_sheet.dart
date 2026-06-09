import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/role_guard.dart';
import '../../../state/poultry/poultry_provider.dart';
import '../../../config/sheet_config.dart';

class AddRecordSheet extends StatefulWidget {
  final String birdType;
  final SheetConfig sheetConfig;
  final String? flockId;

  const AddRecordSheet({
    super.key,
    required this.birdType,
    required this.sheetConfig,
    this.flockId,
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
    for (final c in widget.sheetConfig.columns) {
      if (c.isDate) {
        _controllers[c.key] = TextEditingController(text: _date);
      } else if (c.isDropdown && c.dropdownOptions != null && c.dropdownOptions!.isNotEmpty) {
        _dropdownValues[c.key] = c.dropdownOptions!.first;
      } else {
        _controllers[c.key] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final columns = widget.sheetConfig.columns;
    final isEditable = context.canAddEdit;

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
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.sheetConfig.icon, color: AppColors.primaryGreen, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add ${widget.sheetConfig.label}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins',
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        _capitalize(widget.birdType),
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
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
                  itemCount: columns.length + 1, // +1 for submit button
                  itemBuilder: (_, i) {
                    if (i == columns.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isEditable ? _submit : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text(
                              'Submit Record',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
                            ),
                          ),
                        ),
                      );
                    }

                    final col = columns[i];
                    if (col.isDate) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: _controllers[col.key],
                          decoration: _input(col.label, Icons.calendar_today_rounded),
                          readOnly: true,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2024),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              _controllers[col.key]!.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                            }
                          },
                        ),
                      );
                    }

                    if (col.isDropdown && col.dropdownOptions != null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DropdownButtonFormField<String>(
                          value: _dropdownValues[col.key],
                          decoration: _input(col.label, Icons.arrow_drop_down_rounded),
                          items: col.dropdownOptions!.map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontFamily: 'Poppins')))).toList(),
                          onChanged: (v) => setState(() => _dropdownValues[col.key] = v ?? ''),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        controller: _controllers[col.key],
                        decoration: _input(col.label, col.isNumeric ? Icons.numbers_rounded : Icons.text_fields_rounded),
                        keyboardType: col.isNumeric ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
                        readOnly: col.readOnly,
                        inputFormatters: col.isNumeric ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))] : null,
                        onChanged: col.readOnly ? null : (_) => _autoCalculate(),
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  void _autoCalculate() {
    final qtyCtrl = _controllers['qtyKg'] ?? _controllers['qty'] ?? _controllers['birdsSold'] ?? _controllers['eggsCollected'];
    final priceCtrl = _controllers['costPerKg'] ?? _controllers['unitPrice'] ?? _controllers['pricePerKg'] ?? _controllers['rate'] ?? _controllers['unitCost'];
    final totalCtrl = _controllers['total'];
    final traysCtrl = _controllers['trays'];
    const eggsPerTray = 30;

    if (totalCtrl != null && qtyCtrl != null && priceCtrl != null) {
      final qty = double.tryParse(qtyCtrl.text) ?? 0;
      final price = double.tryParse(priceCtrl.text) ?? 0;
      totalCtrl.text = (qty * price).toStringAsFixed(0);
    }

    if (traysCtrl != null) {
      final eggsCtrl = _controllers['totalEggs'] ?? _controllers['eggsCollected'];
      if (eggsCtrl != null) {
        final eggs = double.tryParse(eggsCtrl.text) ?? 0;
        traysCtrl.text = (eggs / eggsPerTray).toStringAsFixed(1);
      }
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final poultry = context.read<PoultryProvider>();
    final data = <String, dynamic>{
      'birdType': widget.birdType,
      'sheetType': widget.sheetConfig.key,
      'flockId': widget.flockId ?? '',
      'date': _controllers['date']?.text ?? _date,
      'status': 'pending',
    };
    for (final col in widget.sheetConfig.columns) {
      if (col.isDropdown) {
        data[col.key] = _dropdownValues[col.key] ?? '';
      } else if (col.isNumeric) {
        data[col.key] = double.tryParse(_controllers[col.key]?.text ?? '') ?? 0;
      } else {
        data[col.key] = _controllers[col.key]?.text ?? '';
      }
    }
    // Auto-calculate totals
    _autoCalculateFields(data);

    await poultry.addRecord(data);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record submitted for approval'), backgroundColor: AppColors.primaryGreen),
      );
    }
  }

  void _autoCalculateFields(Map<String, dynamic> data) {
    final qty = (data['qtyKg'] ?? data['qty'] ?? data['birdsSold'] ?? data['eggsCollected'] ?? 0) as num;
    final price = (data['costPerKg'] ?? data['unitPrice'] ?? data['pricePerKg'] ?? data['rate'] ?? data['unitCost'] ?? 0) as num;
    if (qty is num && price is num) {
      data['total'] = qty * price;
    }
    final eggs = (data['totalEggs'] ?? data['eggsCollected'] ?? 0) as num;
    if (eggs is num && eggs > 0) {
      data['trays'] = eggs / 30;
    }
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
