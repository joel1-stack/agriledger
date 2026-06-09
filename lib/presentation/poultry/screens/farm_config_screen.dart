import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/poultry/poultry_provider.dart';
import '../../../data/models/poultry/farm_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/poultry_constants.dart';

class FarmConfigScreen extends StatefulWidget {
  const FarmConfigScreen({super.key});

  @override
  State<FarmConfigScreen> createState() => _FarmConfigScreenState();
}

class _FarmConfigScreenState extends State<FarmConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _farmName, _ownerName, _location, _finYear, _currency;
  late TextEditingController _layers, _broilers, _kHens, _kGrowers, _kChicks, _kCockerels;
  late TextEditingController _eggPriceL, _eggPriceK, _broilerKg, _kBirdPrice;
  late TextEditingController _docL, _docB, _docK, _chickMash, _layerMash, _kLayerMash, _kGrowerMash, _bStarter, _bFinisher;
  late TextEditingController _targetL, _targetK, _targetFcrB, _targetFcrK, _maxMort;

  @override
  void initState() {
    super.initState();
    final c = context.read<PoultryProvider>().config;
    _farmName = TextEditingController(text: c?.farmName ?? '');
    _ownerName = TextEditingController(text: c?.ownerName ?? '');
    _location = TextEditingController(text: c?.location ?? '');
    _finYear = TextEditingController(text: c?.financialYearStart ?? '');
    _currency = TextEditingController(text: c?.currency ?? 'KES');
    _layers = TextEditingController(text: c?.commercialLayers.toString() ?? '0');
    _broilers = TextEditingController(text: c?.broilers.toString() ?? '0');
    _kHens = TextEditingController(text: c?.kienyejiHens.toString() ?? '0');
    _kGrowers = TextEditingController(text: c?.kienyejiGrowers.toString() ?? '0');
    _kChicks = TextEditingController(text: c?.kienyejiChicks.toString() ?? '0');
    _kCockerels = TextEditingController(text: c?.kienyejiCockerels.toString() ?? '0');
    _eggPriceL = TextEditingController(text: c?.eggPriceLayers.toString() ?? '0');
    _eggPriceK = TextEditingController(text: c?.eggPriceKienyeji.toString() ?? '0');
    _broilerKg = TextEditingController(text: c?.broilerPricePerKg.toString() ?? '0');
    _kBirdPrice = TextEditingController(text: c?.kienyejiBirdPrice.toString() ?? '0');
    _docL = TextEditingController(text: c?.docPriceLayers.toString() ?? '0');
    _docB = TextEditingController(text: c?.docPriceBroilers.toString() ?? '0');
    _docK = TextEditingController(text: c?.docPriceKienyeji.toString() ?? '0');
    _chickMash = TextEditingController(text: c?.chickMashPrice.toString() ?? '0');
    _layerMash = TextEditingController(text: c?.layerMashPrice.toString() ?? '0');
    _kLayerMash = TextEditingController(text: c?.kienyejiLayerMashPrice.toString() ?? '0');
    _kGrowerMash = TextEditingController(text: c?.kienyejiGrowerMashPrice.toString() ?? '0');
    _bStarter = TextEditingController(text: c?.broilerStarterPrice.toString() ?? '0');
    _bFinisher = TextEditingController(text: c?.broilerFinisherPrice.toString() ?? '0');
    _targetL = TextEditingController(text: c?.targetLayingRateCommercial.toString() ?? '0');
    _targetK = TextEditingController(text: c?.targetLayingRateKienyeji.toString() ?? '0');
    _targetFcrB = TextEditingController(text: c?.targetFcrBroilers.toString() ?? '0');
    _targetFcrK = TextEditingController(text: c?.targetFcrKienyeji.toString() ?? '0');
    _maxMort = TextEditingController(text: c?.maxMortalityRate.toString() ?? '0');
  }

  @override
  void dispose() {
    for (final c in [
      _farmName, _ownerName, _location, _finYear, _currency,
      _layers, _broilers, _kHens, _kGrowers, _kChicks, _kCockerels,
      _eggPriceL, _eggPriceK, _broilerKg, _kBirdPrice,
      _docL, _docB, _docK, _chickMash, _layerMash, _kLayerMash, _kGrowerMash, _bStarter, _bFinisher,
      _targetL, _targetK, _targetFcrB, _targetFcrK, _maxMort
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final p = context.read<PoultryProvider>();
    final config = FarmConfig(
      id: p.config?.id ?? '',
      userId: p.config?.userId ?? '',
      farmName: _farmName.text,
      ownerName: _ownerName.text,
      location: _location.text,
      financialYearStart: _finYear.text,
      currency: _currency.text,
      commercialLayers: int.tryParse(_layers.text) ?? 0,
      broilers: int.tryParse(_broilers.text) ?? 0,
      kienyejiHens: int.tryParse(_kHens.text) ?? 0,
      kienyejiGrowers: int.tryParse(_kGrowers.text) ?? 0,
      kienyejiChicks: int.tryParse(_kChicks.text) ?? 0,
      kienyejiCockerels: int.tryParse(_kCockerels.text) ?? 0,
      eggPriceLayers: double.tryParse(_eggPriceL.text) ?? 0,
      eggPriceKienyeji: double.tryParse(_eggPriceK.text) ?? 0,
      broilerPricePerKg: double.tryParse(_broilerKg.text) ?? 0,
      kienyejiBirdPrice: double.tryParse(_kBirdPrice.text) ?? 0,
      docPriceLayers: double.tryParse(_docL.text) ?? 0,
      docPriceBroilers: double.tryParse(_docB.text) ?? 0,
      docPriceKienyeji: double.tryParse(_docK.text) ?? 0,
      chickMashPrice: double.tryParse(_chickMash.text) ?? 0,
      layerMashPrice: double.tryParse(_layerMash.text) ?? 0,
      kienyejiLayerMashPrice: double.tryParse(_kLayerMash.text) ?? 0,
      kienyejiGrowerMashPrice: double.tryParse(_kGrowerMash.text) ?? 0,
      broilerStarterPrice: double.tryParse(_bStarter.text) ?? 0,
      broilerFinisherPrice: double.tryParse(_bFinisher.text) ?? 0,
      targetLayingRateCommercial: double.tryParse(_targetL.text) ?? 0,
      targetLayingRateKienyeji: double.tryParse(_targetK.text) ?? 0,
      targetFcrBroilers: double.tryParse(_targetFcrB.text) ?? 0,
      targetFcrKienyeji: double.tryParse(_targetFcrK.text) ?? 0,
      maxMortalityRate: double.tryParse(_maxMort.text) ?? 0,
      createdAt: p.config?.createdAt ?? DateTime.now(),
      lastUpdated: DateTime.now(),
    );
    final ok = await p.saveConfig(config);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Configuration saved' : 'Failed to save')));
      if (ok) Navigator.pop(context);
    }
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
  );

  Widget _field(String label, TextEditingController c, {bool number = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: c,
      keyboardType: number ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      decoration: InputDecoration(labelText: label),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('\u2699\ufe0f Farm Setup')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section('FARM DETAILS'),
            _field('Farm Name', _farmName),
            _field('Owner Name', _ownerName),
            _field('Location', _location),
            _field('Financial Year Start (MM-DD)', _finYear),
            _field('Currency', _currency),
            _section('FLOCK SUMMARY'),
            _field('Commercial Layers', _layers, number: true),
            _field('Broilers', _broilers, number: true),
            _field('Kienyeji Hens', _kHens, number: true),
            _field('Kienyeji Growers', _kGrowers, number: true),
            _field('Kienyeji Chicks', _kChicks, number: true),
            _field('Kienyeji Cockerels', _kCockerels, number: true),
            _section('SELLING PRICES'),
            _field('Egg Price (Layers)', _eggPriceL, number: true),
            _field('Egg Price (Kienyeji)', _eggPriceK, number: true),
            _field('Broiler Price / Kg', _broilerKg, number: true),
            _field('Kienyeji Bird Price', _kBirdPrice, number: true),
            _section('FEED PRICES'),
            _field('DOC Price (Layers)', _docL, number: true),
            _field('DOC Price (Broilers)', _docB, number: true),
            _field('DOC Price (Kienyeji)', _docK, number: true),
            _field('Chick Mash Price', _chickMash, number: true),
            _field('Layer Mash Price', _layerMash, number: true),
            _field('Kienyeji Layer Mash', _kLayerMash, number: true),
            _field('Kienyeji Grower Mash', _kGrowerMash, number: true),
            _field('Broiler Starter', _bStarter, number: true),
            _field('Broiler Finisher', _bFinisher, number: true),
            _section('PERFORMANCE BENCHMARKS'),
            _field('Target Laying Rate (Commercial)%', _targetL, number: true),
            _field('Target Laying Rate (Kienyeji)%', _targetK, number: true),
            _field('Target FCR (Broilers)', _targetFcrB, number: true),
            _field('Target FCR (Kienyeji)', _targetFcrK, number: true),
            _field('Max Mortality Rate %', _maxMort, number: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Save Configuration')),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
