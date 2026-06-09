import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

import '../widgets/poultry_drawer.dart';
class UserManualScreen extends StatelessWidget {
  const UserManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('\u{1F4D6} User Manual')),
      drawer: const PoultryDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Section('Color Coding Legend', [
            'Blue cells = Input fields (enter your data here)',
            'Black cells = Formulas (auto-calculated)',
            'Green cells = Cross-sheet references',
            'Yellow cells = Configuration settings',
          ]),
          SizedBox(height: 12),
          _Section('Bird Type Labels', [
            'Blue = Layers (egg production)',
            'Orange = Broilers (meat production)',
            'Amber = Kienyeji (indigenous, dual-purpose)',
          ]),
          SizedBox(height: 12),
          _Section('Getting Started', [
            '1. Go to Setup and enter your Farm Configuration details',
            '2. Add your first Flock Batch under Batches',
            '3. Record daily data: feeding, egg collection, mortality',
            '4. Track sales and expenses as they occur',
            '5. Review reports on Dashboard and Monthly Summary',
          ]),
          SizedBox(height: 12),
          _Section('Daily Recording Workflow', [
            'Morning: Record feed consumption & mortality',
            'Afternoon: Collect eggs & record production',
            'Evening: Log any sales, vet visits, or expenses',
            'End of day: Verify inventory levels if needed',
          ]),
          SizedBox(height: 12),
          _Section('Month-End Process', [
            'Verify all daily records are complete',
            'Reconcile inventory counts',
            'Run Monthly Summary to auto-calculate totals',
            'Review P&L for the month',
            'Plan next month based on performance data',
          ]),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<String> items;
  const _Section(this.title, this.items);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(item, style: const TextStyle(fontSize: 13, color: AppColors.textMedium)),
            )),
          ],
        ),
      ),
    );
  }
}


