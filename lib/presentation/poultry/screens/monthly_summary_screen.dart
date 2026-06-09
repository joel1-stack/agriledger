import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/poultry_constants.dart';
import '../../../state/poultry/poultry_provider.dart';

import '../widgets/poultry_drawer.dart';
class MonthlySummaryScreen extends StatelessWidget {
  const MonthlySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoultryProvider>(context);
    final summaries = provider.monthlySummaries;

    double tEgg = 0, tBird = 0, tOther = 0, tInc = 0;
    double tFeed = 0, tVet = 0, tLab = 0, tHous = 0, tOh = 0, tExp = 0;
    double tNet = 0, tMar = 0;
    int count = 0;

    for (final s in summaries) {
      tEgg += s.eggIncome; tBird += s.birdSales; tOther += s.otherIncome;
      tInc += s.totalIncome; tFeed += s.feedCost; tVet += s.vetCost;
      tLab += s.labour; tHous += s.housing; tOh += s.overheads;
      tExp += s.totalExpenses; tNet += s.netPL; tMar += s.marginPercent;
      count++;
    }

    final avgMar = count > 0 ? tMar / count : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('\u{1F4C5} Monthly Summary')),
      drawer: const PoultryDrawer(),
      body: ListView(
        children: [
          _buildHeaderRow(),
          ...summaries.map((s) => _buildRow(s.month, s.eggIncome, s.birdSales, s.otherIncome, s.totalIncome, s.feedCost, s.vetCost, s.labour, s.housing, s.overheads, s.totalExpenses, s.netPL, s.marginPercent)),
          const Divider(thickness: 2),
          _buildRow('ANNUAL', tEgg, tBird, tOther, tInc, tFeed, tVet, tLab, tHous, tOh, tExp, tNet, avgMar, isTotal: true),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: AppColors.primaryGreen.withOpacity(0.1),
      child: const SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 70, child: Text('Month', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
            SizedBox(width: 55, child: Text('Egg', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
            SizedBox(width: 55, child: Text('Bird', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
            SizedBox(width: 55, child: Text('Other', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
            SizedBox(width: 60, child: Text('T.Inc', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
            SizedBox(width: 55, child: Text('Feed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
            SizedBox(width: 55, child: Text('Vet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
            SizedBox(width: 55, child: Text('Lab', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
            SizedBox(width: 55, child: Text('Hous', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
            SizedBox(width: 60, child: Text('Oh', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
            SizedBox(width: 60, child: Text('T.Exp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
            SizedBox(width: 60, child: Text('Net', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
            SizedBox(width: 55, child: Text('Mar%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String month, double egg, double bird, double other, double tInc, double feed, double vet, double lab, double hous, double oh, double tExp, double net, double mar, {bool isTotal = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: isTotal ? AppColors.textDark.withOpacity(0.05) : null,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 70, child: Text(month, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: 10))),
            SizedBox(width: 55, child: Text(egg.toStringAsFixed(0), style: const TextStyle(fontSize: 10))),
            SizedBox(width: 55, child: Text(bird.toStringAsFixed(0), style: const TextStyle(fontSize: 10))),
            SizedBox(width: 55, child: Text(other.toStringAsFixed(0), style: const TextStyle(fontSize: 10))),
            SizedBox(width: 60, child: Text(tInc.toStringAsFixed(0), style: const TextStyle(fontSize: 10))),
            SizedBox(width: 55, child: Text(feed.toStringAsFixed(0), style: const TextStyle(fontSize: 10))),
            SizedBox(width: 55, child: Text(vet.toStringAsFixed(0), style: const TextStyle(fontSize: 10))),
            SizedBox(width: 55, child: Text(lab.toStringAsFixed(0), style: const TextStyle(fontSize: 10))),
            SizedBox(width: 55, child: Text(hous.toStringAsFixed(0), style: const TextStyle(fontSize: 10))),
            SizedBox(width: 60, child: Text(oh.toStringAsFixed(0), style: const TextStyle(fontSize: 10))),
            SizedBox(width: 60, child: Text(tExp.toStringAsFixed(0), style: const TextStyle(fontSize: 10))),
            SizedBox(width: 60, child: Text(net.toStringAsFixed(0), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: net >= 0 ? AppColors.primaryGreen : AppColors.accentRed))),
            SizedBox(width: 55, child: Text('${mar.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 10))),
          ],
        ),
      ),
    );
  }
}

