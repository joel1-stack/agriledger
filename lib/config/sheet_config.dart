import 'package:flutter/material.dart';

class SheetColumn {
  final String key;
  final String label;
  final bool isNumeric;
  final bool isCurrency;
  final bool isDate;
  final bool isDropdown;
  final List<String>? dropdownOptions;
  final bool readOnly;
  final double flex;

  const SheetColumn({
    required this.key,
    required this.label,
    this.isNumeric = false,
    this.isCurrency = false,
    this.isDate = false,
    this.isDropdown = false,
    this.dropdownOptions,
    this.readOnly = false,
    this.flex = 1,
  });
}

class SheetConfig {
  final String key;
  final String label;
  final IconData icon;
  final List<SheetColumn> columns;

  const SheetConfig({
    required this.key,
    required this.label,
    required this.icon,
    required this.columns,
  });
}

const List<SheetConfig> layerSheets = [
  SheetConfig(
    key: 'feed',
    label: 'Feed',
    icon: Icons.restaurant_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'feedType', label: 'Feed Type', isDropdown: true, dropdownOptions: ['Chick Mash', 'Grower Mash', 'Layer Mash', 'Starter', 'Finisher'], flex: 1),
      SheetColumn(key: 'qtyKg', label: 'Qty (kg)', isNumeric: true, flex: 1),
      SheetColumn(key: 'costPerKg', label: 'Cost/kg', isCurrency: true, flex: 1),
      SheetColumn(key: 'total', label: 'Total', isCurrency: true, readOnly: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'mortality',
    label: 'Mortality',
    icon: Icons.warning_amber_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'deadCount', label: 'Dead', isNumeric: true, flex: 1),
      SheetColumn(key: 'cause', label: 'Cause', isDropdown: true, dropdownOptions: ['Disease', 'Predator', 'Heat', 'Unknown', 'Injury'], flex: 1),
      SheetColumn(key: 'culled', label: 'Culled', isNumeric: true, flex: 1),
      SheetColumn(key: 'remaining', label: 'Remaining', isNumeric: true, readOnly: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'eggs',
    label: 'Eggs',
    icon: Icons.egg_alt_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'totalEggs', label: 'Total Eggs', isNumeric: true, flex: 1),
      SheetColumn(key: 'broken', label: 'Broken', isNumeric: true, flex: 1),
      SheetColumn(key: 'trays', label: 'Trays', isNumeric: true, readOnly: true, flex: 1),
      SheetColumn(key: 'productionPct', label: '% Prod', isNumeric: true, readOnly: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'vet',
    label: 'Vet',
    icon: Icons.medical_services_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'treatment', label: 'Treatment', flex: 2),
      SheetColumn(key: 'cost', label: 'Cost', isCurrency: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'sales',
    label: 'Sales',
    icon: Icons.payments_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'item', label: 'Item', isDropdown: true, dropdownOptions: ['Eggs (tray)', 'Live Bird', 'Spent Hen'], flex: 1),
      SheetColumn(key: 'qty', label: 'Qty', isNumeric: true, flex: 1),
      SheetColumn(key: 'unitPrice', label: 'Price', isCurrency: true, flex: 1),
      SheetColumn(key: 'total', label: 'Total', isCurrency: true, readOnly: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'labour',
    label: 'Labour',
    icon: Icons.people_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'workerName', label: 'Worker', flex: 1),
      SheetColumn(key: 'task', label: 'Task', flex: 2),
      SheetColumn(key: 'hours', label: 'Hours', isNumeric: true, flex: 1),
      SheetColumn(key: 'rate', label: 'Rate', isCurrency: true, flex: 1),
      SheetColumn(key: 'total', label: 'Total', isCurrency: true, readOnly: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'other_income',
    label: 'Other Inc',
    icon: Icons.attach_money_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'source', label: 'Source', flex: 2),
      SheetColumn(key: 'amount', label: 'Amount', isCurrency: true, flex: 1),
    ],
  ),
];

const List<SheetConfig> broilerSheets = [
  SheetConfig(
    key: 'feed',
    label: 'Feed',
    icon: Icons.restaurant_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'feedType', label: 'Feed Type', isDropdown: true, dropdownOptions: ['Broiler Starter', 'Broiler Finisher', 'Grower'], flex: 1),
      SheetColumn(key: 'qtyKg', label: 'Qty (kg)', isNumeric: true, flex: 1),
      SheetColumn(key: 'costPerKg', label: 'Cost/kg', isCurrency: true, flex: 1),
      SheetColumn(key: 'total', label: 'Total', isCurrency: true, readOnly: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'mortality',
    label: 'Mortality',
    icon: Icons.warning_amber_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'deadCount', label: 'Dead', isNumeric: true, flex: 1),
      SheetColumn(key: 'cause', label: 'Cause', isDropdown: true, dropdownOptions: ['Disease', 'Heat', 'Injury', 'Unknown'], flex: 1),
      SheetColumn(key: 'culled', label: 'Culled', isNumeric: true, flex: 1),
      SheetColumn(key: 'remaining', label: 'Remaining', isNumeric: true, readOnly: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'weight',
    label: 'Weight',
    icon: Icons.monitor_weight_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'sampleSize', label: 'Sample', isNumeric: true, flex: 1),
      SheetColumn(key: 'avgWeight', label: 'Avg (kg)', isNumeric: true, flex: 1),
      SheetColumn(key: 'uniformity', label: 'Uniform %', isNumeric: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'vet',
    label: 'Vet',
    icon: Icons.medical_services_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'treatment', label: 'Treatment', flex: 2),
      SheetColumn(key: 'cost', label: 'Cost', isCurrency: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'sales',
    label: 'Sales',
    icon: Icons.payments_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'birdsSold', label: 'Birds', isNumeric: true, flex: 1),
      SheetColumn(key: 'weightKg', label: 'Wt (kg)', isNumeric: true, flex: 1),
      SheetColumn(key: 'pricePerKg', label: 'Price/kg', isCurrency: true, flex: 1),
      SheetColumn(key: 'total', label: 'Total', isCurrency: true, readOnly: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'housing',
    label: 'Housing',
    icon: Icons.home_repair_service_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'task', label: 'Task', flex: 2),
      SheetColumn(key: 'cost', label: 'Cost', isCurrency: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'overheads',
    label: 'Overheads',
    icon: Icons.build_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'category', label: 'Category', isDropdown: true, dropdownOptions: ['Electricity', 'Water', 'Transport', 'Maintenance', 'Other'], flex: 1),
      SheetColumn(key: 'description', label: 'Description', flex: 2),
      SheetColumn(key: 'amount', label: 'Amount', isCurrency: true, flex: 1),
    ],
  ),
];

const List<SheetConfig> kienyejiSheets = [
  SheetConfig(
    key: 'feed',
    label: 'Feed',
    icon: Icons.restaurant_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'feedType', label: 'Feed Type', isDropdown: true, dropdownOptions: ['Commercial', 'Scavenge', 'Mixed'], flex: 1),
      SheetColumn(key: 'qtyKg', label: 'Qty (kg)', isNumeric: true, flex: 1),
      SheetColumn(key: 'cost', label: 'Cost', isCurrency: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'mortality',
    label: 'Mortality',
    icon: Icons.warning_amber_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'dead', label: 'Dead', isNumeric: true, flex: 1),
      SheetColumn(key: 'predator', label: 'Predator?', isDropdown: true, dropdownOptions: ['Yes', 'No'], flex: 1),
      SheetColumn(key: 'remaining', label: 'Remaining', isNumeric: true, readOnly: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'eggs',
    label: 'Eggs',
    icon: Icons.egg_alt_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'eggsCollected', label: 'Collected', isNumeric: true, flex: 1),
      SheetColumn(key: 'broken', label: 'Broken', isNumeric: true, flex: 1),
      SheetColumn(key: 'trays', label: 'Trays', isNumeric: true, readOnly: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'vet',
    label: 'Vet',
    icon: Icons.medical_services_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'treatment', label: 'Treatment', flex: 2),
      SheetColumn(key: 'cost', label: 'Cost', isCurrency: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'sales',
    label: 'Sales',
    icon: Icons.payments_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'flockName', label: 'Flock', flex: 1),
      SheetColumn(key: 'item', label: 'Item', isDropdown: true, dropdownOptions: ['Eggs (tray)', 'Live Bird'], flex: 1),
      SheetColumn(key: 'qty', label: 'Qty', isNumeric: true, flex: 1),
      SheetColumn(key: 'unitPrice', label: 'Price', isCurrency: true, flex: 1),
      SheetColumn(key: 'total', label: 'Total', isCurrency: true, readOnly: true, flex: 1),
    ],
  ),
  SheetConfig(
    key: 'assets',
    label: 'Assets',
    icon: Icons.business_rounded,
    columns: [
      SheetColumn(key: 'date', label: 'Date', isDate: true, flex: 1),
      SheetColumn(key: 'item', label: 'Item', flex: 2),
      SheetColumn(key: 'qty', label: 'Qty', isNumeric: true, flex: 1),
      SheetColumn(key: 'unitCost', label: 'Unit Cost', isCurrency: true, flex: 1),
      SheetColumn(key: 'total', label: 'Total', isCurrency: true, readOnly: true, flex: 1),
    ],
  ),
];

const Map<String, List<SheetConfig>> allSheets = {
  'layers': layerSheets,
  'broilers': broilerSheets,
  'kienyeji': kienyejiSheets,
};

const List<String> birdTypes = ['layers', 'broilers', 'kienyeji'];

Map<String, IconData> birdTypeIcons = {
  'layers': Icons.egg_alt_rounded,
  'broilers': Icons.set_meal_rounded,
  'kienyeji': Icons.agriculture_rounded,
};

Map<String, Color> birdTypeColors = {
  'layers': const Color(0xFF3B82F6),
  'broilers': const Color(0xFFF97316),
  'kienyeji': const Color(0xFFEAB308),
};
