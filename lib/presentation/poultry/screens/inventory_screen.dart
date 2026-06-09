import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/poultry/poultry_provider.dart';

import '../widgets/poultry_drawer.dart';
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);
    final items = provider.inventory;
    final needsReorder = items.where((i) => i.needsReorder).length;

    return Scaffold(
      appBar: AppBar(title: const Text('\u{1F4E6} Inventory & Supplies')),
      drawer: const PoultryDrawer(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: needsReorder > 0 ? AppColors.accentRed.withOpacity(0.1) : AppColors.lightGreen,
            child: Text(
              'Items Needing Reorder: $needsReorder',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: needsReorder > 0 ? AppColors.accentRed : AppColors.primaryGreen,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(item.itemName),
                    subtitle: Text(
                      'Unit: ${item.unit} | Open: ${item.openingStock} | Purch: ${item.purchased} | Used: ${item.used} | Close: ${item.closingStock} | Reorder: ${item.reorderLevel}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: Text(
                      item.needsReorder ? 'REORDER' : 'OK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: item.needsReorder ? AppColors.accentRed : AppColors.primaryGreen,
                      ),
                    ),
                    onTap: () {},
                  ),
                );
              },
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
}


