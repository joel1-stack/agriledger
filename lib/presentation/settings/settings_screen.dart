import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../state/auth/auth_provider.dart';
import '../poultry/widgets/poultry_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _farmNameCtrl = TextEditingController(text: 'Green Valley Farm');
  String _currency = 'KES';
  final _layerMashCtrl = TextEditingController(text: '3200');
  final _growerCtrl = TextEditingController(text: '3100');
  final _starterCtrl = TextEditingController(text: '3300');
  final _mortalityThresholdCtrl = TextEditingController(text: '2');
  final _lowStockCtrl = TextEditingController(text: '10');
  final _tempHighCtrl = TextEditingController(text: '27');

  @override
  void dispose() {
    _farmNameCtrl.dispose();
    _layerMashCtrl.dispose();
    _growerCtrl.dispose();
    _starterCtrl.dispose();
    _mortalityThresholdCtrl.dispose();
    _lowStockCtrl.dispose();
    _tempHighCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isSuperAdmin) {
      return Scaffold(
        backgroundColor: AppColors.backgroundGrey,
        appBar: AppBar(title: const Text('Settings')),
        drawer: const PoultryDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_rounded, size: 64, color: AppColors.textMuted.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              const Text('Settings are managed by Super Admin', style: TextStyle(fontSize: 16, color: AppColors.textMuted)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(title: const Text('Farm Settings')),
      drawer: const PoultryDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader('Farm Details'),
            const SizedBox(height: 8),
            _buildField('Farm Name', _farmNameCtrl, Icons.agriculture_rounded),
            const SizedBox(height: 12),
            _buildDropdown('Currency', _currency, ['KES', 'USD', 'UGX', 'TZS'], (v) => setState(() => _currency = v ?? 'KES')),

            const SizedBox(height: 24),
            _SectionHeader('Default Feed Costs (per bag)'),
            const SizedBox(height: 8),
            _buildField('Layer Mash', _layerMashCtrl, Icons.restaurant_rounded),
            const SizedBox(height: 12),
            _buildField('Grower Mash', _growerCtrl, Icons.restaurant_rounded),
            const SizedBox(height: 12),
            _buildField('Starter', _starterCtrl, Icons.restaurant_rounded),

            const SizedBox(height: 24),
            _SectionHeader('Alert Thresholds'),
            const SizedBox(height: 8),
            _buildField('Mortality %', _mortalityThresholdCtrl, Icons.warning_amber_rounded),
            const SizedBox(height: 12),
            _buildField('Low Stock (bags)', _lowStockCtrl, Icons.inventory_2_rounded),
            const SizedBox(height: 12),
            _buildField('Temperature High (°C)', _tempHighCtrl, Icons.thermostat_rounded),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings saved'), backgroundColor: AppColors.primaryGreen),
                  );
                },
                icon: const Icon(Icons.save_rounded),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon) {
    return TextField(
      controller: ctrl,
      keyboardType: label.contains('%') || label.contains('bags') || label.contains('°C') || label.contains('Mash') || label.contains('Starter')
          ? TextInputType.number
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
        prefixIcon: Icon(icon, size: 18),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
        prefixIcon: const Icon(Icons.attach_money_rounded, size: 18),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontFamily: 'Poppins')))).toList(),
      onChanged: onChanged,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: AppColors.textDark));
  }
}
