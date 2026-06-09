import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/poultry_constants.dart';
import '../../../state/poultry/poultry_provider.dart';

class LabourScreen extends StatelessWidget {
  const LabourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);
    final records = provider.labour;

    return Scaffold(
      appBar: AppBar(title: const Text('\u{1F477} Labour & Staffing')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.primaryGreen.withOpacity(0.1),
            child: Center(
              child: Column(
                children: [
                  const Text('Total Labour Cost',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textLight)),
                  const SizedBox(height: 4),
                  Text(
                    'KSh ${provider.totalLabourCost.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: records.isEmpty
                ? const Center(child: Text('No labour records'))
                : ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (_, i) {
                      final r = records[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${r.month}  |  ${r.employeeName}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${r.role}  |  Days: ${r.daysWorked}  |  '
                                'Rate: KSh ${r.dailyRate.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Gross: KSh ${r.grossPay.toStringAsFixed(0)}  |  '
                                'Deductions: KSh ${r.deductions.toStringAsFixed(0)}  |  '
                                'Net: KSh ${r.netPay.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
