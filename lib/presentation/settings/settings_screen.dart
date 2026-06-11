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
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(backgroundColor: const Color(0xFF1B8A3C), foregroundColor: Colors.white, elevation: 0, title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins'))),
        drawer: const PoultryDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF94A3B8).withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(Icons.lock_rounded, size: 48, color: const Color(0xFF94A3B8).withValues(alpha: 0.5)),
              ),
              const SizedBox(height: 16),
              const Text('Settings are managed by Super Admin', style: TextStyle(fontSize: 16, color: Color(0xFF94A3B8), fontFamily: 'Poppins')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(backgroundColor: const Color(0xFF1B8A3C), foregroundColor: Colors.white, elevation: 0, title: const Text('Farm Settings', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins'))),
      drawer: const PoultryDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?auto=format&fit=crop&w=600&q=80'), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
                    Image.asset("assets/images/3D Logo 'sam k' with Nature tru one .png", width: 50, height: 50, errorBuilder: (_, __, ___) => const Icon(Icons.settings_rounded, size: 40, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Farm Configuration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Poppins')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _section('Farm Details', Icons.agriculture_rounded, const Color(0xFF10B981)),
            const SizedBox(height: 8),
            _field('Farm Name', _farmNameCtrl, Icons.agriculture_rounded),
            const SizedBox(height: 12),
            _dropdown('Currency', _currency, ['KES', 'USD', 'UGX', 'TZS'], (v) => setState(() => _currency = v ?? 'KES')),
            const SizedBox(height: 24),
            _section('Feed Costs (per bag)', Icons.restaurant_rounded, const Color(0xFFF59E0B)),
            const SizedBox(height: 8),
            _field('Layer Mash', _layerMashCtrl, Icons.restaurant_rounded),
            const SizedBox(height: 12),
            _field('Grower Mash', _growerCtrl, Icons.restaurant_rounded),
            const SizedBox(height: 12),
            _field('Starter', _starterCtrl, Icons.restaurant_rounded),
            const SizedBox(height: 24),
            _section('Alerts', Icons.notifications_active_rounded, const Color(0xFFEF4444)),
            const SizedBox(height: 8),
            _field('Mortality Threshold (%)', _mortalityThresholdCtrl, Icons.warning_rounded),
            const SizedBox(height: 12),
            _field('Low Stock (bags)', _lowStockCtrl, Icons.inventory_2_rounded),
            const SizedBox(height: 12),
            _field('High Temp (°C)', _tempHighCtrl, Icons.thermostat_rounded),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Row(children: [Icon(Icons.check_circle_rounded, color: Colors.white, size: 20), SizedBox(width: 10), Expanded(child: Text('Settings saved', style: TextStyle(fontFamily: 'Poppins', fontSize: 13)))]),
                    backgroundColor: const Color(0xFF1B8A3C), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ));
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B8A3C), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 4),
                child: const Text('Save Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, IconData icon, Color color) {
    return Row(children: [
      Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 16, color: color)),
      const SizedBox(width: 8),
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, fontFamily: 'Poppins', color: Color(0xFF0F172A))),
    ]);
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label, labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF64748B)),
        filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF1B8A3C), width: 2)),
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label, labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
        prefixIcon: const Icon(Icons.attach_money_rounded, size: 18, color: Color(0xFF64748B)),
        filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)),
      ),
      items: items.map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontFamily: 'Poppins')))).toList(),
      onChanged: onChanged,
    );
  }
}
