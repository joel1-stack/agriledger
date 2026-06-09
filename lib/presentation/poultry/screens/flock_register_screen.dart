import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/poultry/poultry_provider.dart';
import '../../../data/models/poultry/flock_batch.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/poultry_constants.dart';

import '../widgets/poultry_drawer.dart';
class FlockRegisterScreen extends StatelessWidget {
  const FlockRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);
    final batches = provider.batches;

    return Scaffold(
      appBar: AppBar(title: const Text('\U0001f414 Flock Register')),
      drawer: const PoultryDrawer(),
      body: Column(
        children: [
          _buildSummary(provider),
          Expanded(
            child: batches.isEmpty
                ? const Center(child: Text('No batches yet', style: TextStyle(color: AppColors.textMuted)))
                : ListView.builder(
                    itemCount: batches.length,
                    itemBuilder: (_, i) => _batchTile(context, batches[i]),
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

  Widget _buildSummary(PoultryProvider p) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.mintGreen,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _sumItem('Active Batches', '${p.activeBatches.length}', Icons.batch_prediction),
          _sumItem('Total Active', '${p.totalActiveBirds}', Icons.pets),
          _sumItem('Layers', '${p.totalLayers}', Icons.egg),
          _sumItem('Broilers', '${p.totalBroilers}', Icons.restaurant),
          _sumItem('Kienyeji', '${p.totalKienyeji}', Icons.agriculture),
        ],
      ),
    );
  }

  Widget _sumItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
      ],
    );
  }

  Widget _batchTile(BuildContext context, FlockBatch b) {
    final Color typeColor;
    switch (b.birdType) {
      case 'Layer': typeColor = AppColors.accentAmber; break;
      case 'Broiler': typeColor = AppColors.accentOrange; break;
      case 'Kienyeji': typeColor = AppColors.accentTeal; break;
      default: typeColor = AppColors.textMuted;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: typeColor.withOpacity(0.2), child: Icon(Icons.pets, color: typeColor)),
        title: Text(b.batchId, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${b.breed}  |  ${b.birdType}  |  Start: ${b.birdsAtStart}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: b.status == 'Active' ? AppColors.lightGreen : AppColors.backgroundGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(b.status, style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: b.status == 'Active' ? AppColors.primaryGreen : AppColors.textMuted,
          )),
        ),
        onTap: () {},
        onLongPress: () => _deleteDialog(context, b),
      ),
    );
  }

  void _deleteDialog(BuildContext context, FlockBatch b) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Batch'),
        content: Text('Delete batch ${b.batchId}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<PoultryProvider>().deleteBatch(b.batchId);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.accentRed)),
          ),
        ],
      ),
    );
  }
}

