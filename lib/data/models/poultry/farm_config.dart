import 'package:cloud_firestore/cloud_firestore.dart';

class FarmConfig {
  final String id;
  final String userId;
  final String farmName;
  final String ownerName;
  final String location;
  final String financialYearStart;
  final String currency;
  final int commercialLayers;
  final int broilers;
  final int kienyejiHens;
  final int kienyejiGrowers;
  final int kienyejiChicks;
  final int kienyejiCockerels;
  final double eggPriceLayers;
  final double eggPriceKienyeji;
  final double broilerPricePerKg;
  final double kienyejiBirdPrice;
  final double docPriceLayers;
  final double docPriceBroilers;
  final double docPriceKienyeji;
  final double chickMashPrice;
  final double layerMashPrice;
  final double kienyejiLayerMashPrice;
  final double kienyejiGrowerMashPrice;
  final double broilerStarterPrice;
  final double broilerFinisherPrice;
  final double targetLayingRateCommercial;
  final double targetLayingRateKienyeji;
  final double targetFcrBroilers;
  final double targetFcrKienyeji;
  final double maxMortalityRate;
  final DateTime createdAt;
  final DateTime lastUpdated;

  FarmConfig({
    required this.id,
    required this.userId,
    required this.farmName,
    required this.ownerName,
    required this.location,
    required this.financialYearStart,
    this.currency = 'KES',
    this.commercialLayers = 0,
    this.broilers = 0,
    this.kienyejiHens = 0,
    this.kienyejiGrowers = 0,
    this.kienyejiChicks = 0,
    this.kienyejiCockerels = 0,
    this.eggPriceLayers = 0,
    this.eggPriceKienyeji = 0,
    this.broilerPricePerKg = 0,
    this.kienyejiBirdPrice = 0,
    this.docPriceLayers = 0,
    this.docPriceBroilers = 0,
    this.docPriceKienyeji = 0,
    this.chickMashPrice = 0,
    this.layerMashPrice = 0,
    this.kienyejiLayerMashPrice = 0,
    this.kienyejiGrowerMashPrice = 0,
    this.broilerStarterPrice = 0,
    this.broilerFinisherPrice = 0,
    this.targetLayingRateCommercial = 0,
    this.targetLayingRateKienyeji = 0,
    this.targetFcrBroilers = 0,
    this.targetFcrKienyeji = 0,
    this.maxMortalityRate = 0,
    required this.createdAt,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'farmName': farmName,
    'ownerName': ownerName,
    'location': location,
    'financialYearStart': financialYearStart,
    'currency': currency,
    'commercialLayers': commercialLayers,
    'broilers': broilers,
    'kienyejiHens': kienyejiHens,
    'kienyejiGrowers': kienyejiGrowers,
    'kienyejiChicks': kienyejiChicks,
    'kienyejiCockerels': kienyejiCockerels,
    'eggPriceLayers': eggPriceLayers,
    'eggPriceKienyeji': eggPriceKienyeji,
    'broilerPricePerKg': broilerPricePerKg,
    'kienyejiBirdPrice': kienyejiBirdPrice,
    'docPriceLayers': docPriceLayers,
    'docPriceBroilers': docPriceBroilers,
    'docPriceKienyeji': docPriceKienyeji,
    'chickMashPrice': chickMashPrice,
    'layerMashPrice': layerMashPrice,
    'kienyejiLayerMashPrice': kienyejiLayerMashPrice,
    'kienyejiGrowerMashPrice': kienyejiGrowerMashPrice,
    'broilerStarterPrice': broilerStarterPrice,
    'broilerFinisherPrice': broilerFinisherPrice,
    'targetLayingRateCommercial': targetLayingRateCommercial,
    'targetLayingRateKienyeji': targetLayingRateKienyeji,
    'targetFcrBroilers': targetFcrBroilers,
    'targetFcrKienyeji': targetFcrKienyeji,
    'maxMortalityRate': maxMortalityRate,
    'createdAt': Timestamp.fromDate(createdAt),
    'lastUpdated': Timestamp.fromDate(lastUpdated),
  };

  factory FarmConfig.fromMap(String id, Map<String, dynamic> map) => FarmConfig(
    id: id,
    userId: map['userId'] as String,
    farmName: map['farmName'] as String,
    ownerName: map['ownerName'] as String,
    location: map['location'] as String,
    financialYearStart: map['financialYearStart'] as String,
    currency: map['currency'] as String? ?? 'KES',
    commercialLayers: map['commercialLayers'] as int? ?? 0,
    broilers: map['broilers'] as int? ?? 0,
    kienyejiHens: map['kienyejiHens'] as int? ?? 0,
    kienyejiGrowers: map['kienyejiGrowers'] as int? ?? 0,
    kienyejiChicks: map['kienyejiChicks'] as int? ?? 0,
    kienyejiCockerels: map['kienyejiCockerels'] as int? ?? 0,
    eggPriceLayers: (map['eggPriceLayers'] as num?)?.toDouble() ?? 0,
    eggPriceKienyeji: (map['eggPriceKienyeji'] as num?)?.toDouble() ?? 0,
    broilerPricePerKg: (map['broilerPricePerKg'] as num?)?.toDouble() ?? 0,
    kienyejiBirdPrice: (map['kienyejiBirdPrice'] as num?)?.toDouble() ?? 0,
    docPriceLayers: (map['docPriceLayers'] as num?)?.toDouble() ?? 0,
    docPriceBroilers: (map['docPriceBroilers'] as num?)?.toDouble() ?? 0,
    docPriceKienyeji: (map['docPriceKienyeji'] as num?)?.toDouble() ?? 0,
    chickMashPrice: (map['chickMashPrice'] as num?)?.toDouble() ?? 0,
    layerMashPrice: (map['layerMashPrice'] as num?)?.toDouble() ?? 0,
    kienyejiLayerMashPrice: (map['kienyejiLayerMashPrice'] as num?)?.toDouble() ?? 0,
    kienyejiGrowerMashPrice: (map['kienyejiGrowerMashPrice'] as num?)?.toDouble() ?? 0,
    broilerStarterPrice: (map['broilerStarterPrice'] as num?)?.toDouble() ?? 0,
    broilerFinisherPrice: (map['broilerFinisherPrice'] as num?)?.toDouble() ?? 0,
    targetLayingRateCommercial: (map['targetLayingRateCommercial'] as num?)?.toDouble() ?? 0,
    targetLayingRateKienyeji: (map['targetLayingRateKienyeji'] as num?)?.toDouble() ?? 0,
    targetFcrBroilers: (map['targetFcrBroilers'] as num?)?.toDouble() ?? 0,
    targetFcrKienyeji: (map['targetFcrKienyeji'] as num?)?.toDouble() ?? 0,
    maxMortalityRate: (map['maxMortalityRate'] as num?)?.toDouble() ?? 0,
    createdAt: (map['createdAt'] as Timestamp).toDate(),
    lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
  );
}
