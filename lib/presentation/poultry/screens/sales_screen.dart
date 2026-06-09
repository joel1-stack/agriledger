import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/poultry/poultry_provider.dart';
import '../../../data/models/poultry/poultry_sale.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/poultry_constants.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('\U0001f4b5 Sales Tracker')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.mintGreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _sumItem('Total Revenue', 'KES ${provider.totalRevenue.toStringAsFixed(0)}'),
                _sumItem('Egg Income', 'KES ${provider.totalEggIncome.toStringAsFixed(0)}'),
                _sumItem('Bird Sales', 'KES ${provider.totalBirdSales.toStringAsFixed(0)}'),
              ],
            ),
          ),
          Expanded(
            child: provider.sales.isEmpty
                ? const Center(child: Text('No sales yet', style: TextStyle(color: AppColors.textMuted)))
                : ListView.builder(
                    itemCount: provider.sales.length,
                    itemBuilder: (_, i) => _saleTile(context, provider.sales[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _sumItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
      ],
    );
  }

  Widget _saleTile(BuildContext context, PoultrySale s) {
    final dateStr = '${s.date.day}/${s.date.month}/${s.date.year}';
    final Color paymentColor;
    switch (s.paymentStatus) {
      case 'Paid': paymentColor = AppColors.primaryGreen; break;
      case 'Pending': paymentColor = AppColors.accentAmber; break;
      case 'Partial': paymentColor = AppColors.accentRed; break;
      default: paymentColor = AppColors.textMuted;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: s.saleType == 'Egg Sale' ? AppColors.accentAmber.withOpacity(0.2) : AppColors.accentOrange.withOpacity(0.2),
          child: Icon(s.saleType == 'Egg Sale' ? Icons.egg : Icons.sell, color: s.saleType == 'Egg Sale' ? AppColors.accentAmber : AppColors.accentOrange),
        ),
        title: Text('$dateStr - ${s.saleType}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(
          '${s.birdType}  |  ${s.quantity} x KES ${s.unitPrice.toStringAsFixed(0)}  |  ${s.buyer}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('KES ${s.totalRevenue.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: paymentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(s.paymentStatus, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: paymentColor)),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
