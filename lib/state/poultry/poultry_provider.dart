import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/poultry/farm_config.dart';
import '../../data/models/poultry/flock_batch.dart';
import '../../data/models/poultry/egg_production.dart';
import '../../data/models/poultry/poultry_sale.dart';
import '../../data/models/poultry/other_income.dart';
import '../../data/models/poultry/feed_expense.dart';
import '../../data/models/poultry/feed_consumption.dart';
import '../../data/models/poultry/vet_health.dart';
import '../../data/models/poultry/mortality_record.dart';
import '../../data/models/poultry/housing_expense.dart';
import '../../data/models/poultry/labour_record.dart';
import '../../data/models/poultry/overhead_expense.dart';
import '../../data/models/poultry/monthly_summary.dart';
import '../../data/models/poultry/poultry_inventory.dart';
import '../../data/models/poultry/asset_item.dart';
import '../../data/models/poultry/batch_performance.dart';
import '../../data/repositories/poultry_repository.dart';

class PoultryProvider extends ChangeNotifier {
  final PoultryRepository _repo;

  PoultryProvider({PoultryRepository? repo})
      : _repo = repo ?? PoultryRepository();

  // ── State ────────────────────────────────────────────────────────────────
  FarmConfig? _config;
  List<FlockBatch> _batches = [];
  List<EggProduction> _production = [];
  List<PoultrySale> _sales = [];
  List<OtherIncome> _otherIncome = [];
  List<FeedExpense> _feedExpenses = [];
  List<FeedConsumption> _feedConsumption = [];
  List<VetHealth> _vetHealth = [];
  List<MortalityRecord> _mortality = [];
  List<HousingExpense> _housing = [];
  List<LabourRecord> _labour = [];
  List<OverheadExpense> _overheads = [];
  List<MonthlySummary> _monthlySummaries = [];
  List<PoultryInventory> _inventory = [];
  List<AssetItem> _assets = [];

  bool _isLoading = false;
  String? _error;
  String? _loadedUserId;

  // Stream subscriptions
  StreamSubscription? _configSub;
  StreamSubscription? _batchesSub;
  StreamSubscription? _productionSub;
  StreamSubscription? _salesSub;
  StreamSubscription? _otherIncomeSub;
  StreamSubscription? _feedExpensesSub;
  StreamSubscription? _feedConsumptionSub;
  StreamSubscription? _vetHealthSub;
  StreamSubscription? _mortalitySub;
  StreamSubscription? _housingSub;
  StreamSubscription? _labourSub;
  StreamSubscription? _overheadsSub;
  StreamSubscription? _monthlySub;
  StreamSubscription? _inventorySub;
  StreamSubscription? _assetsSub;

  // ── Getters ──────────────────────────────────────────────────────────────
  FarmConfig? get config => _config;
  List<FlockBatch> get batches => _batches;
  List<EggProduction> get production => _production;
  List<PoultrySale> get sales => _sales;
  List<OtherIncome> get otherIncome => _otherIncome;
  List<FeedExpense> get feedExpenses => _feedExpenses;
  List<FeedConsumption> get feedConsumption => _feedConsumption;
  List<VetHealth> get vetHealth => _vetHealth;
  List<MortalityRecord> get mortality => _mortality;
  List<HousingExpense> get housing => _housing;
  List<LabourRecord> get labour => _labour;
  List<OverheadExpense> get overheads => _overheads;
  List<MonthlySummary> get monthlySummaries => _monthlySummaries;
  List<PoultryInventory> get inventory => _inventory;
  List<AssetItem> get assets => _assets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ── Computed ─────────────────────────────────────────────────────────────
  List<FlockBatch> get activeBatches => _batches.where((b) => b.status == 'Active').toList();
  int get totalActiveBirds => activeBatches.fold(0, (s, b) => s + b.activeBirds);
  int get totalLayers => _batches.where((b) => b.birdType == 'Layer').fold(0, (s, b) => s + b.activeBirds);
  int get totalBroilers => _batches.where((b) => b.birdType == 'Broiler').fold(0, (s, b) => s + b.activeBirds);
  int get totalKienyeji => _batches.where((b) => b.birdType == 'Kienyeji').fold(0, (s, b) => s + b.activeBirds);

  double get totalEggIncome => _sales.where((s) => s.saleType == 'Egg Sale').fold(0.0, (sum, s) => sum + s.totalRevenue);
  double get totalBirdSales => _sales.where((s) => s.saleType == 'Bird Sale').fold(0.0, (sum, s) => sum + s.totalRevenue);
  double get totalOtherIncome => _otherIncome.fold(0.0, (sum, i) => sum + i.total);
  double get totalRevenue => totalEggIncome + totalBirdSales + totalOtherIncome;

  double get totalFeedCost => _feedExpenses.fold(0.0, (sum, f) => sum + f.totalCost);
  double get totalVetCost => _vetHealth.fold(0.0, (sum, v) => sum + v.cost);
  double get totalLabourCost => _labour.fold(0.0, (sum, l) => sum + l.netPay);
  double get totalHousingCost => _housing.fold(0.0, (sum, h) => sum + h.amount);
  double get totalOverheadCost => _overheads.fold(0.0, (sum, o) => sum + o.amount);
  double get totalExpenses => totalFeedCost + totalVetCost + totalLabourCost + totalHousingCost + totalOverheadCost;
  double get netProfit => totalRevenue - totalExpenses;
  double get profitMargin => totalRevenue > 0 ? (netProfit / totalRevenue) * 100 : 0;

  double get totalDeaths => _mortality.fold(0, (sum, m) => sum + m.deaths);

  double get avgLayerRate {
    final layerProd = _production.where((p) => p.birdType == 'Layer');
    if (layerProd.isEmpty) return 0;
    return layerProd.fold(0.0, (s, p) => s + p.henDayPercent) / layerProd.length;
  }

  double get avgKienyejiRate {
    final kienProd = _production.where((p) => p.birdType == 'Kienyeji');
    if (kienProd.isEmpty) return 0;
    return kienProd.fold(0.0, (s, p) => s + p.henDayPercent) / kienProd.length;
  }

  List<BatchPerformance> get batchPerformances {
    return _batches.map((batch) {
      final sales = _sales.where((s) => s.batchId == batch.batchId);
      final feedExps = _feedExpenses.where((f) => f.batchId == batch.batchId);
      final feedCons = _feedConsumption.where((f) => f.batchId == batch.batchId);
      final morts = _mortality.where((m) => m.batchId == batch.batchId);
      final vets = _vetHealth.where((v) => v.batchId == batch.batchId);
      final housings = _housing.where((h) => h.birdType == batch.birdType || h.birdType == 'All Types');

      final totalIncome = sales.fold(0.0, (s, sale) => s + sale.totalRevenue);
      final totalFeedCosts = feedExps.fold(0.0, (s, f) => s + f.totalCost);
      final totalVet = vets.fold(0.0, (s, v) => s + v.cost);
      final totalHousing = housings.fold(0.0, (s, h) => s + h.amount);
      final totalBatchCosts = totalFeedCosts + totalVet + totalHousing + batch.totalCost;
      final totalDeaths = morts.fold(0, (s, m) => s + m.deaths);
      final totalFeedKg = feedCons.fold(0.0, (s, f) => s + f.amountFed);
      final fcr = totalFeedKg > 0 && sales.any((s) => s.saleType == 'Bird Sale')
          ? totalFeedKg / sales.where((s) => s.saleType == 'Bird Sale').fold(0.0, (s, sale) => s + sale.quantity)
          : 0.0;

      return BatchPerformance(
        batchId: batch.batchId,
        birdType: batch.birdType,
        started: batch.birdsAtStart,
        soldSurvived: batch.birdsAtStart - totalDeaths - (batch.birdsSold ?? 0),
        deaths: totalDeaths,
        mortalityPercent: batch.birdsAtStart > 0 ? (totalDeaths / batch.birdsAtStart) * 100 : 0,
        feedKg: totalFeedKg,
        fcr: fcr,
        totalIncome: totalIncome,
        totalCosts: totalBatchCosts,
        netProfit: totalIncome - totalBatchCosts,
      );
    }).toList();
  }

  // ── Load All ─────────────────────────────────────────────────────────────
  void loadAll(String userId) {
    if (userId.isEmpty) return;
    if (_loadedUserId == userId) return;
    _loadedUserId = userId;
    _isLoading = true;
    notifyListeners();

    _configSub = _repo.streamFarmConfig(userId).listen(
      (c) { _config = c; _isLoading = false; notifyListeners(); },
      onError: _onError,
    );
    _batchesSub = _repo.streamBatches(userId).listen(
      (d) { _batches = d; notifyListeners(); }, onError: _onError,
    );
    _productionSub = _repo.streamProduction(userId).listen(
      (d) { _production = d; notifyListeners(); }, onError: _onError,
    );
    _salesSub = _repo.streamSales(userId).listen(
      (d) { _sales = d; notifyListeners(); }, onError: _onError,
    );
    _otherIncomeSub = _repo.streamOtherIncome(userId).listen(
      (d) { _otherIncome = d; notifyListeners(); }, onError: _onError,
    );
    _feedExpensesSub = _repo.streamFeedExpenses(userId).listen(
      (d) { _feedExpenses = d; notifyListeners(); }, onError: _onError,
    );
    _feedConsumptionSub = _repo.streamFeedConsumption(userId).listen(
      (d) { _feedConsumption = d; notifyListeners(); }, onError: _onError,
    );
    _vetHealthSub = _repo.streamVetHealth(userId).listen(
      (d) { _vetHealth = d; notifyListeners(); }, onError: _onError,
    );
    _mortalitySub = _repo.streamMortality(userId).listen(
      (d) { _mortality = d; notifyListeners(); }, onError: _onError,
    );
    _housingSub = _repo.streamHousingExpenses(userId).listen(
      (d) { _housing = d; notifyListeners(); }, onError: _onError,
    );
    _labourSub = _repo.streamLabour(userId).listen(
      (d) { _labour = d; notifyListeners(); }, onError: _onError,
    );
    _overheadsSub = _repo.streamOverheads(userId).listen(
      (d) { _overheads = d; notifyListeners(); }, onError: _onError,
    );
    _monthlySub = _repo.streamMonthlySummaries(userId).listen(
      (d) { _monthlySummaries = d; notifyListeners(); }, onError: _onError,
    );
    _inventorySub = _repo.streamInventory(userId).listen(
      (d) { _inventory = d; notifyListeners(); }, onError: _onError,
    );
    _assetsSub = _repo.streamAssets(userId).listen(
      (d) { _assets = d; notifyListeners(); }, onError: _onError,
    );
  }

  void _onError(Object e) {
    _error = e.toString();
    _isLoading = false;
    notifyListeners();
  }

  void clearError() { _error = null; notifyListeners(); }

  // ── CRUD Wrappers ────────────────────────────────────────────────────────
  Future<bool> saveConfig(FarmConfig c) async { try { await _repo.saveFarmConfig(c); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> addBatch(FlockBatch b) async { try { await _repo.addBatch(b); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> updateBatch(FlockBatch b) async { try { await _repo.updateBatch(b); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> deleteBatch(String id) async { try { await _repo.deleteBatch(id); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> addProduction(EggProduction p) async { try { await _repo.addProduction(p); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> deleteProduction(String id) async { try { await _repo.deleteProduction(id); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> addSale(PoultrySale s) async { try { await _repo.addSale(s); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> updateSale(PoultrySale s) async { try { await _repo.updateSale(s); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> deleteSale(String id) async { try { await _repo.deleteSale(id); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> addOtherIncome(OtherIncome i) async { try { await _repo.addOtherIncome(i); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> deleteOtherIncome(String id) async { try { await _repo.deleteOtherIncome(id); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> addFeedExpense(FeedExpense f) async { try { await _repo.addFeedExpense(f); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> deleteFeedExpense(String id) async { try { await _repo.deleteFeedExpense(id); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> addFeedConsumption(FeedConsumption f) async { try { await _repo.addFeedConsumption(f); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> deleteFeedConsumption(String id) async { try { await _repo.deleteFeedConsumption(id); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> addVetHealth(VetHealth v) async { try { await _repo.addVetHealth(v); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> deleteVetHealth(String id) async { try { await _repo.deleteVetHealth(id); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> addMortality(MortalityRecord m) async { try { await _repo.addMortality(m); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> deleteMortality(String id) async { try { await _repo.deleteMortality(id); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> addHousingExpense(HousingExpense h) async { try { await _repo.addHousingExpense(h); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> deleteHousingExpense(String id) async { try { await _repo.deleteHousingExpense(id); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> addLabour(LabourRecord l) async { try { await _repo.addLabour(l); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> deleteLabour(String id) async { try { await _repo.deleteLabour(id); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> addOverhead(OverheadExpense o) async { try { await _repo.addOverhead(o); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> deleteOverhead(String id) async { try { await _repo.deleteOverhead(id); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> saveMonthlySummary(MonthlySummary s) async { try { await _repo.saveMonthlySummary(s); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> deleteMonthlySummary(String id) async { try { await _repo.deleteMonthlySummary(id); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> addInventoryItem(PoultryInventory i) async { try { await _repo.addInventoryItem(i); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> updateInventoryItem(PoultryInventory i) async { try { await _repo.updateInventoryItem(i); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> deleteInventoryItem(String id) async { try { await _repo.deleteInventoryItem(id); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> addAsset(AssetItem a) async { try { await _repo.addAsset(a); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> updateAsset(AssetItem a) async { try { await _repo.updateAsset(a); return true; } catch (e) { _onError(e); return false; } }
  Future<bool> deleteAsset(String id) async { try { await _repo.deleteAsset(id); return true; } catch (e) { _onError(e); return false; } }

  @override
  void dispose() {
    _configSub?.cancel();
    _batchesSub?.cancel();
    _productionSub?.cancel();
    _salesSub?.cancel();
    _otherIncomeSub?.cancel();
    _feedExpensesSub?.cancel();
    _feedConsumptionSub?.cancel();
    _vetHealthSub?.cancel();
    _mortalitySub?.cancel();
    _housingSub?.cancel();
    _labourSub?.cancel();
    _overheadsSub?.cancel();
    _monthlySub?.cancel();
    _inventorySub?.cancel();
    _assetsSub?.cancel();
    super.dispose();
  }

  // ── Unified Record Methods (for SheetScreen) ─────────────────────────────

  /// Combines all poultry data into a unified list with birdType, sheetType, status
  List<Map<String, dynamic>> get allRecords {
    final records = <Map<String, dynamic>>[];

    for (final e in _production) {
      records.add(e.toMap()..['birdType'] = 'layers'..['sheetType'] = 'eggs'..['status'] = 'approved');
    }
    for (final e in _sales) {
      records.add(e.toMap()..['birdType'] = 'layers'..['sheetType'] = 'sales'..['status'] = 'approved');
    }
    for (final e in _otherIncome) {
      records.add(e.toMap()..['birdType'] = 'layers'..['sheetType'] = 'other_income'..['status'] = 'approved');
    }
    for (final e in _feedExpenses) {
      records.add(e.toMap()..['birdType'] = 'layers'..['sheetType'] = 'feed'..['status'] = 'approved');
    }
    for (final e in _vetHealth) {
      records.add(e.toMap()..['birdType'] = 'layers'..['sheetType'] = 'vet'..['status'] = 'approved');
    }
    for (final e in _mortality) {
      records.add(e.toMap()..['birdType'] = 'layers'..['sheetType'] = 'mortality'..['status'] = 'approved');
    }
    for (final e in _housing) {
      records.add(e.toMap()..['birdType'] = 'layers'..['sheetType'] = 'housing'..['status'] = 'approved');
    }
    for (final e in _labour) {
      records.add(e.toMap()..['birdType'] = 'layers'..['sheetType'] = 'labour'..['status'] = 'approved');
    }
    for (final e in _overheads) {
      records.add(e.toMap()..['birdType'] = 'layers'..['sheetType'] = 'overheads'..['status'] = 'approved');
    }

    return records;
  }

  /// Batches as maps for worker dashboard
  List<Map<String, dynamic>> get flocks {
    return _batches.map((b) => b.toMap()).toList();
  }

  /// Add a new record to Firestore
  Future<void> addRecord(Map<String, dynamic> data) async {
    final sheetType = data['sheetType'] ?? 'feed';
    await _repo.addRecord(sheetType, data);
    // Provider will auto-refresh via stream subscription
  }

  /// Update a record's approval status
  Future<void> updateRecordStatus(String id, String status, {String? rejectionReason}) async {
    // This updates the status in Firestore
    // In a real implementation, we'd find the right collection and update
    debugPrint('Update record $id to $status (reason: $rejectionReason)');
    // Since we have multiple collections, we update in all records
    await _repo.updateRecordStatus(id, status, rejectionReason: rejectionReason);
  }

  int get totalMortality => _mortality.fold(0, (sum, m) => sum + m.deaths);

}
