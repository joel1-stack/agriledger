class BirdType {
  static const String layer = 'Layer';
  static const String broiler = 'Broiler';
  static const String kienyeji = 'Kienyeji';
  static const String all = 'All Types';
  static List<String> get values => [layer, broiler, kienyeji];
}

class SaleType {
  static const String eggSale = 'Egg Sale';
  static const String birdSale = 'Bird Sale';
  static List<String> get values => [eggSale, birdSale];
}

class PaymentStatus {
  static const String paid = 'Paid';
  static const String pending = 'Pending';
  static const String partial = 'Partial';
  static List<String> get values => [paid, pending, partial];
}

class BatchStatus {
  static const String active = 'Active';
  static const String closed = 'Closed';
  static List<String> get values => [active, closed];
}

class FeedType {
  static const String chickMash = 'Chick Mash';
  static const String layerMash = 'Layer Mash';
  static const String kienyejiLayerMash = 'Kienyeji Layer Mash';
  static const String kienyejiGrowerMash = 'Kienyeji Grower Mash';
  static const String broilerStarter = 'Broiler Starter';
  static const String broilerFinisher = 'Broiler Finisher';
  static List<String> get values => [chickMash, layerMash, kienyejiLayerMash, kienyejiGrowerMash, broilerStarter, broilerFinisher];
}

class IncomeCategory {
  static const String manureSale = 'Manure Sale';
  static const String spentHenSale = 'Spent Hen Sale';
  static const String subsidyGrant = 'Subsidy / Grant';
  static const String chickSale = 'Chick Sale';
  static List<String> get values => [manureSale, spentHenSale, subsidyGrant, chickSale];
}

class HousingCategory {
  static const String drinkers = 'Drinkers';
  static const String feeders = 'Feeders';
  static const String cages = 'Cages';
  static const String brooderEquipment = 'Brooder Equipment';
  static const String litterSawdust = 'Litter / Sawdust';
  static const String fencing = 'Fencing';
  static const String predatorProofing = 'Predator Proofing';
  static const String eggTrays = 'Egg Trays';
  static const String disinfectant = 'Disinfectant';
  static List<String> get values => [drinkers, feeders, cages, brooderEquipment, litterSawdust, fencing, predatorProofing, eggTrays, disinfectant];
}

class OverheadCategory {
  static const String water = 'Water Bill';
  static const String electricity = 'Electricity';
  static const String fuel = 'Fuel';
  static const String equipmentRepair = 'Equipment Repair';
  static const String insurance = 'Insurance';
  static List<String> get values => [water, electricity, fuel, equipmentRepair, insurance];
}

class AssetCondition {
  static const String good = 'Good';
  static const String fair = 'Fair';
  static const String poor = 'Poor';
  static const String needsReplacement = 'Needs Replacement';
  static List<String> get values => [good, fair, poor, needsReplacement];
}

class Months {
  static const List<String> values = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
}
