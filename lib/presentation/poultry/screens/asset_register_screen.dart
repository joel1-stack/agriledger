import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/poultry_constants.dart';
import '../../../state/poultry/poultry_provider.dart';

class AssetRegisterScreen extends StatelessWidget {
  const AssetRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);
    final assets = provider.assets;

    return Scaffold(
      appBar: AppBar(title: const Text('\u{1F3D7}\ufe0f Asset Register')),
      body: ListView.builder(
        itemCount: assets.length,
        itemBuilder: (context, index) {
          final a = assets[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(a.assetName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                'Purchased: ${a.datePurchased.toString().substring(0, 10)} | Cost: KES ${a.purchaseCost.toStringAsFixed(2)} | Life: ${a.usefulLifeYears}yrs',
                style: const TextStyle(fontSize: 11),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('BV: KES ${a.currentBookValue.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  Text('Dep: KES ${a.annualDepreciation.toStringAsFixed(2)}', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  Text('${a.condition}', style: TextStyle(fontSize: 11, color: a.condition == 'Good' ? AppColors.primaryGreen : AppColors.accentAmber)),
                ],
              ),
              onTap: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
