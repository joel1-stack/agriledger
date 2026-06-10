import 'package:flutter/material.dart';

class ModuleInfo {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final List<String> subTypes;
  final Map<String, List<String>> sheets;

  const ModuleInfo({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.subTypes,
    required this.sheets,
  });
}

class ModuleConfig {
  static const Map<String, ModuleInfo> modules = {
    'poultry': ModuleInfo(
      id: 'poultry',
      label: 'Poultry',
      icon: Icons.pets_rounded,
      color: Color(0xFF3B82F6),
      subTypes: ['layers', 'broilers', 'kienyeji'],
      sheets: {
        'feed': ['Date', 'Qty (kg)', 'Feed Type', 'Cost/kg', 'Total', 'Flock Count', 'Notes', 'Status'],
        'mortality': ['Date', 'Dead', 'Cause', 'Culled', 'Remaining', 'Photo', 'Status'],
        'eggs': ['Date', 'Total Eggs', 'Broken', 'Small', 'Medium', 'Large', 'Trays', '% Prod', 'Status'],
        'weight': ['Date', 'Sample', 'Avg (kg)', 'Uniformity', 'Target', 'Variance', 'Status'],
        'vet': ['Date', 'Treatment', 'Medicine', 'Cost', 'Next Date', 'Status'],
        'sales': ['Date', 'Trays/Birds', 'Price', 'Total', 'Buyer', 'Paid', 'Status'],
      },
    ),
    'dairy': ModuleInfo(
      id: 'dairy',
      label: 'Dairy',
      icon: Icons.agriculture_rounded,
      color: Color(0xFF10B981),
      subTypes: ['cows'],
      sheets: {
        'milk': ['Date', 'Cow ID', 'Morning (L)', 'Evening (L)', 'Total (L)', 'Quality', 'Status'],
        'feed': ['Date', 'Qty (kg)', 'Type', 'Cost', 'Status'],
        'vet': ['Date', 'Treatment', 'Medicine', 'Cost', 'Next Date', 'Status'],
        'breeding': ['Date', 'Cow ID', 'Partner ID', 'Method', 'Notes', 'Status'],
        'sales': ['Date', 'Litres', 'Price/L', 'Total', 'Buyer', 'Status'],
      },
    ),
    'crops': ModuleInfo(
      id: 'crops',
      label: 'Crops',
      icon: Icons.eco_rounded,
      color: Color(0xFFF59E0B),
      subTypes: ['maize', 'beans', 'vegetables'],
      sheets: {
        'planting': ['Date', 'Plot', 'Seed Type', 'Qty (kg)', 'Cost', 'Status'],
        'fertilizer': ['Date', 'Plot', 'Type', 'Qty', 'Cost', 'Status'],
        'pest_control': ['Date', 'Plot', 'Pesticide', 'Qty', 'Cost', 'Status'],
        'harvest': ['Date', 'Plot', 'Qty (bags)', 'Quality', 'Status'],
        'sales': ['Date', 'Bags', 'Price/Bag', 'Total', 'Buyer', 'Status'],
      },
    ),
    'livestock': ModuleInfo(
      id: 'livestock',
      label: 'Livestock',
      icon: Icons.ramp_left_rounded,
      color: Color(0xFFEF4444),
      subTypes: ['goats', 'sheep', 'pigs'],
      sheets: {
        'feed': ['Date', 'Qty (kg)', 'Type', 'Cost', 'Status'],
        'health': ['Date', 'Animal ID', 'Treatment', 'Medicine', 'Cost', 'Next Date', 'Status'],
        'breeding': ['Date', 'Animal ID', 'Partner ID', 'Notes', 'Status'],
        'weight': ['Date', 'Sample', 'Avg (kg)', 'Uniformity', 'Target', 'Status'],
        'sales': ['Date', 'Animals', 'Weight', 'Price/kg', 'Total', 'Buyer', 'Status'],
      },
    ),
    'property': ModuleInfo(
      id: 'property',
      label: 'Property',
      icon: Icons.home_work_rounded,
      color: Color(0xFF8B5CF6),
      subTypes: ['rental', 'commercial'],
      sheets: {
        'rent': ['Date', 'Unit', 'Tenant', 'Amount', 'Paid', 'Balance', 'Status'],
        'maintenance': ['Date', 'Unit', 'Issue', 'Contractor', 'Cost', 'Status'],
        'expenses': ['Date', 'Category', 'Amount', 'Notes', 'Status'],
      },
    ),
    'transport': ModuleInfo(
      id: 'transport',
      label: 'Transport',
      icon: Icons.local_shipping_rounded,
      color: Color(0xFF06B6D4),
      subTypes: ['trucks', 'boda', 'tractor'],
      sheets: {
        'trips': ['Date', 'Vehicle', 'Route', 'Cargo', 'Income', 'Expenses', 'Profit', 'Status'],
        'fuel': ['Date', 'Vehicle', 'Litres', 'Price/L', 'Total', 'Status'],
        'maintenance': ['Date', 'Vehicle', 'Issue', 'Cost', 'Mechanic', 'Status'],
        'expenses': ['Date', 'Vehicle', 'Category', 'Amount', 'Notes', 'Status'],
      },
    ),
    'cashbook': ModuleInfo(
      id: 'cashbook',
      label: 'Cashbook',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF059669),
      subTypes: ['income', 'expense'],
      sheets: {
        'daily_entries': ['Date', 'Ref', 'Description', 'Account', 'Debit', 'Credit', 'Balance', 'Status'],
        'bank_reconciliation': ['Date', 'Description', 'Bank Balance', 'Book Balance', 'Difference', 'Reconciled', 'Status'],
      },
    ),
    'inventory': ModuleInfo(
      id: 'inventory',
      label: 'Inventory',
      icon: Icons.inventory_2_rounded,
      color: Color(0xFF7C3AED),
      subTypes: ['general'],
      sheets: {
        'stock_card': ['Date', 'Item', 'SKU', 'In', 'Out', 'Balance', 'Unit Cost', 'Total Value', 'Status'],
        'movements': ['Date', 'Item', 'Type', 'Qty', 'Cost', 'Total', 'Reference', 'Status'],
        'reorder': ['Item', 'Current', 'Reorder Lvl', 'Reorder Qty', 'Supplier', 'Last Order', 'Status'],
      },
    ),
    'journal': ModuleInfo(
      id: 'journal',
      label: 'Journal',
      icon: Icons.book_rounded,
      color: Color(0xFFDC2626),
      subTypes: ['general_ledger', 'adjustments'],
      sheets: {
        'debits': ['Date', 'Ref', 'Description', 'Account', 'Debit', 'Credit', 'Balanced', 'Status'],
        'credits': ['Date', 'Ref', 'Description', 'Account', 'Credit', 'Debit', 'Balanced', 'Status'],
        'balances': ['Date', 'Ref', 'Description', 'Total Debit', 'Total Credit', 'Difference', 'Status'],
      },
    ),
    'contracts': ModuleInfo(
      id: 'contracts',
      label: 'Contracts',
      icon: Icons.description_rounded,
      color: Color(0xFF0891B2),
      subTypes: ['projects'],
      sheets: {
        'milestones': ['Date', 'Project', 'Milestone', 'Progress %', 'Amount', 'Status'],
        'payments': ['Date', 'Project', 'Amount', 'Paid By', 'Method', 'Status'],
        'progress': ['Date', 'Project', 'Notes', 'Percent', 'Status'],
      },
    ),
  };

  static List<String> get moduleIds => modules.keys.toList();

  static ModuleInfo getModule(String id) => modules[id] ?? modules['poultry']!;

  static List<String> getSheetKeys(String moduleId) {
    final mod = modules[moduleId];
    return mod != null ? mod.sheets.keys.toList() : [];
  }

  static List<String> getSheetColumns(String moduleId, String sheetKey) {
    final mod = modules[moduleId];
    final cols = mod?.sheets[sheetKey];
    return cols ?? ['Date', 'Value', 'Status'];
  }

  static IconData moduleIcon(String moduleId) =>
      modules[moduleId]?.icon ?? Icons.circle;

  static Color moduleColor(String moduleId) =>
      modules[moduleId]?.color ?? const Color(0xFF1B8A3C);

  static String moduleLabel(String moduleId) =>
      modules[moduleId]?.label ?? moduleId;
}
