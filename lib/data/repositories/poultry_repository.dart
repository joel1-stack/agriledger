import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/poultry/farm_config.dart';
import '../models/poultry/flock_batch.dart';
import '../models/poultry/egg_production.dart';
import '../models/poultry/poultry_sale.dart';
import '../models/poultry/other_income.dart';
import '../models/poultry/feed_expense.dart';
import '../models/poultry/feed_consumption.dart';
import '../models/poultry/vet_health.dart';
import '../models/poultry/mortality_record.dart';
import '../models/poultry/housing_expense.dart';
import '../models/poultry/labour_record.dart';
import '../models/poultry/overhead_expense.dart';
import '../models/poultry/monthly_summary.dart';
import '../models/poultry/poultry_inventory.dart';
import '../models/poultry/asset_item.dart';

class PoultryRepository {
  final FirebaseFirestore _db;

  PoultryRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  // ── Farm Config ──────────────────────────────────────────────────────────
  Stream<FarmConfig?> streamFarmConfig(String userId) {
    return _db.collection('poultryFarmConfig').doc(userId).snapshots().map(
      (snap) => snap.exists ? FarmConfig.fromMap(snap.id, snap.data()!) : null,
    );
  }

  Future<void> saveFarmConfig(FarmConfig config) async {
    await _db.collection('poultryFarmConfig').doc(config.userId).set(config.toMap());
  }

  // ── Flock Batches ────────────────────────────────────────────────────────
  Stream<List<FlockBatch>> streamBatches(String userId) {
    return _db
        .collection('poultryBatches')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => FlockBatch.fromMap(d.id, d.data())).toList());
  }

  Future<void> addBatch(FlockBatch batch) =>
      _db.collection('poultryBatches').doc(batch.id).set(batch.toMap());

  Future<void> updateBatch(FlockBatch batch) =>
      _db.collection('poultryBatches').doc(batch.id).update(batch.toMap());

  Future<void> deleteBatch(String id) =>
      _db.collection('poultryBatches').doc(id).delete();

  // ── Egg Production ──────────────────────────────────────────────────────
  Stream<List<EggProduction>> streamProduction(String userId) {
    return _db
        .collection('poultryProduction')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => EggProduction.fromMap(d.id, d.data())).toList());
  }

  Future<void> addProduction(EggProduction record) =>
      _db.collection('poultryProduction').doc(record.id).set(record.toMap());

  Future<void> deleteProduction(String id) =>
      _db.collection('poultryProduction').doc(id).delete();

  // ── Sales ────────────────────────────────────────────────────────────────
  Stream<List<PoultrySale>> streamSales(String userId) {
    return _db
        .collection('poultrySales')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => PoultrySale.fromMap(d.id, d.data())).toList());
  }

  Future<void> addSale(PoultrySale sale) =>
      _db.collection('poultrySales').doc(sale.id).set(sale.toMap());

  Future<void> updateSale(PoultrySale sale) =>
      _db.collection('poultrySales').doc(sale.id).update(sale.toMap());

  Future<void> deleteSale(String id) =>
      _db.collection('poultrySales').doc(id).delete();

  // ── Other Income ─────────────────────────────────────────────────────────
  Stream<List<OtherIncome>> streamOtherIncome(String userId) {
    return _db
        .collection('poultryOtherIncome')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => OtherIncome.fromMap(d.id, d.data())).toList());
  }

  Future<void> addOtherIncome(OtherIncome income) =>
      _db.collection('poultryOtherIncome').doc(income.id).set(income.toMap());

  Future<void> deleteOtherIncome(String id) =>
      _db.collection('poultryOtherIncome').doc(id).delete();

  // ── Feed Expenses ────────────────────────────────────────────────────────
  Stream<List<FeedExpense>> streamFeedExpenses(String userId) {
    return _db
        .collection('poultryFeedExpenses')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => FeedExpense.fromMap(d.id, d.data())).toList());
  }

  Future<void> addFeedExpense(FeedExpense expense) =>
      _db.collection('poultryFeedExpenses').doc(expense.id).set(expense.toMap());

  Future<void> deleteFeedExpense(String id) =>
      _db.collection('poultryFeedExpenses').doc(id).delete();

  // ── Feed Consumption ─────────────────────────────────────────────────────
  Stream<List<FeedConsumption>> streamFeedConsumption(String userId) {
    return _db
        .collection('poultryFeedConsumption')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => FeedConsumption.fromMap(d.id, d.data())).toList());
  }

  Future<void> addFeedConsumption(FeedConsumption record) =>
      _db.collection('poultryFeedConsumption').doc(record.id).set(record.toMap());

  Future<void> deleteFeedConsumption(String id) =>
      _db.collection('poultryFeedConsumption').doc(id).delete();

  // ── Vet & Health ─────────────────────────────────────────────────────────
  Stream<List<VetHealth>> streamVetHealth(String userId) {
    return _db
        .collection('poultryVetHealth')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => VetHealth.fromMap(d.id, d.data())).toList());
  }

  Future<void> addVetHealth(VetHealth record) =>
      _db.collection('poultryVetHealth').doc(record.id).set(record.toMap());

  Future<void> deleteVetHealth(String id) =>
      _db.collection('poultryVetHealth').doc(id).delete();

  // ── Mortality ────────────────────────────────────────────────────────────
  Stream<List<MortalityRecord>> streamMortality(String userId) {
    return _db
        .collection('poultryMortality')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => MortalityRecord.fromMap(d.id, d.data())).toList());
  }

  Future<void> addMortality(MortalityRecord record) =>
      _db.collection('poultryMortality').doc(record.id).set(record.toMap());

  Future<void> deleteMortality(String id) =>
      _db.collection('poultryMortality').doc(id).delete();

  // ── Housing Expenses ─────────────────────────────────────────────────────
  Stream<List<HousingExpense>> streamHousingExpenses(String userId) {
    return _db
        .collection('poultryHousing')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => HousingExpense.fromMap(d.id, d.data())).toList());
  }

  Future<void> addHousingExpense(HousingExpense expense) =>
      _db.collection('poultryHousing').doc(expense.id).set(expense.toMap());

  Future<void> deleteHousingExpense(String id) =>
      _db.collection('poultryHousing').doc(id).delete();

  // ── Labour ───────────────────────────────────────────────────────────────
  Stream<List<LabourRecord>> streamLabour(String userId) {
    return _db
        .collection('poultryLabour')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => LabourRecord.fromMap(d.id, d.data())).toList());
  }

  Future<void> addLabour(LabourRecord record) =>
      _db.collection('poultryLabour').doc(record.id).set(record.toMap());

  Future<void> deleteLabour(String id) =>
      _db.collection('poultryLabour').doc(id).delete();

  // ── Overheads ────────────────────────────────────────────────────────────
  Stream<List<OverheadExpense>> streamOverheads(String userId) {
    return _db
        .collection('poultryOverheads')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => OverheadExpense.fromMap(d.id, d.data())).toList());
  }

  Future<void> addOverhead(OverheadExpense expense) =>
      _db.collection('poultryOverheads').doc(expense.id).set(expense.toMap());

  Future<void> deleteOverhead(String id) =>
      _db.collection('poultryOverheads').doc(id).delete();

  // ── Monthly Summary ──────────────────────────────────────────────────────
  Stream<List<MonthlySummary>> streamMonthlySummaries(String userId) {
    return _db
        .collection('poultryMonthlySummary')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => MonthlySummary.fromMap(d.id, d.data())).toList());
  }

  Future<void> saveMonthlySummary(MonthlySummary summary) =>
      _db.collection('poultryMonthlySummary').doc(summary.id).set(summary.toMap());

  Future<void> deleteMonthlySummary(String id) =>
      _db.collection('poultryMonthlySummary').doc(id).delete();

  // ── Inventory ────────────────────────────────────────────────────────────
  Stream<List<PoultryInventory>> streamInventory(String userId) {
    return _db
        .collection('poultryInventory')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs.map((d) => PoultryInventory.fromMap(d.id, d.data())).toList());
  }

  Future<void> addInventoryItem(PoultryInventory item) =>
      _db.collection('poultryInventory').doc(item.id).set(item.toMap());

  Future<void> updateInventoryItem(PoultryInventory item) =>
      _db.collection('poultryInventory').doc(item.id).update(item.toMap());

  Future<void> deleteInventoryItem(String id) =>
      _db.collection('poultryInventory').doc(id).delete();

  // ── Assets ───────────────────────────────────────────────────────────────
  Stream<List<AssetItem>> streamAssets(String userId) {
    return _db
        .collection('poultryAssets')
        .where('userId', isEqualTo: userId)
        .orderBy('datePurchased', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => AssetItem.fromMap(d.id, d.data())).toList());
  }

  Future<void> addAsset(AssetItem asset) =>
      _db.collection('poultryAssets').doc(asset.id).set(asset.toMap());

  Future<void> updateAsset(AssetItem asset) =>
      _db.collection('poultryAssets').doc(asset.id).update(asset.toMap());

  Future<void> deleteAsset(String id) =>
      _db.collection('poultryAssets').doc(id).delete();

  // ── Dynamic Record Methods (for SheetScreen) ────────────────────────────

  static const Map<String, String> _sheetCollections = {
    'feed': 'poultryFeedExpenses',
    'mortality': 'poultryMortality',
    'eggs': 'poultryProduction',
    'weight': 'poultryProduction',
    'vet': 'poultryVetHealth',
    'sales': 'poultrySales',
    'labour': 'poultryLabour',
    'housing': 'poultryHousing',
    'overheads': 'poultryOverheads',
    'other_income': 'poultryOtherIncome',
    'inventory': 'poultryInventory',
    'assets': 'poultryAssets',
  };

  Future<void> addRecord(String sheetType, Map<String, dynamic> data) async {
    final collection = _sheetCollections[sheetType] ?? 'poultryFeedExpenses';
    final ref = _db.collection(collection).doc();
    data['id'] = ref.id;
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await ref.set(data);
  }

  Future<void> updateRecordStatus(String id, String status, {String? rejectionReason}) async {
    final batch = _db.batch();
    for (final col in _sheetCollections.values.toSet()) {
      final ref = _db.collection(col).doc(id);
      batch.update(ref, {
        'status': status,
        if (rejectionReason != null) 'rejectionReason': rejectionReason,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }
}
