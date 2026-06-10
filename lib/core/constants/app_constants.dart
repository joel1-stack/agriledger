// ...existing code...

class ModuleConfig {
  static final Map<String, Map<String, dynamic>> configs = {
    'poultry': {
      'subTypes': ['layers', 'broilers', 'kienyeji'],
      'sheets': {
        'feed': ['Date', 'Qty (kg)', 'Type', 'Cost/kg', 'Total', 'Status'],
        'mortality': ['Date', 'Dead', 'Cause', 'Culled', 'Remaining', 'Status'],
        'eggs': ['Date', 'Total', 'Broken', 'Trays', '% Prod', 'Status'],
        'weight': [
          'Date',
          'Sample',
          'Avg (kg)',
          'Uniformity',
          'Target',
          'Status',
        ],
        'vet': ['Date', 'Vaccine', 'Medicine', 'Dosage', 'Cost', 'Status'],
        'sales': ['Date', 'Qty', 'Price', 'Buyer', 'Total', 'Paid', 'Status'],
        'labour': [
          'Date',
          'Worker',
          'Task',
          'Hours',
          'Rate',
          'Total',
          'Status',
        ],
        'housing': ['Date', 'House', 'Cleaning', 'Disinfect', 'Cost', 'Status'],
        'assets': ['Date', 'Item', 'Qty', 'Cost', 'Condition', 'Status'],
        'overheads': ['Date', 'Category', 'Amount', 'Status'],
        'other_income': ['Date', 'Source', 'Amount', 'Notes', 'Status'],
      },
    },
    'dairy': {
      'subTypes': ['cows'],
      'sheets': {
        'milk': [
          'Date',
          'Cow ID',
          'Morning (L)',
          'Evening (L)',
          'Total (L)',
          'Quality',
          'Status',
        ],
        'feed': ['Date', 'Qty (kg)', 'Type', 'Cost', 'Status'],
        'vet': ['Date', 'Treatment', 'Medicine', 'Cost', 'Next Date', 'Status'],
        'breeding': ['Date', 'Cow ID', 'Bull ID', 'Method', 'Notes', 'Status'],
        'sales': ['Date', 'Litres', 'Price/L', 'Buyer', 'Total', 'Status'],
      },
    },
    'crops': {
      'subTypes': ['maize', 'beans', 'vegetables'],
      'sheets': {
        'planting': ['Date', 'Plot', 'Seed Type', 'Qty (kg)', 'Cost', 'Status'],
        'fertilizer': ['Date', 'Plot', 'Type', 'Qty', 'Cost', 'Status'],
        'pest_control': ['Date', 'Plot', 'Pesticide', 'Qty', 'Cost', 'Status'],
        'harvest': ['Date', 'Plot', 'Qty (bags)', 'Quality', 'Status'],
        'sales': [
          'Date',
          'Qty (bags)',
          'Price/bag',
          'Buyer',
          'Total',
          'Status',
        ],
      },
    },
    'livestock': {
      'subTypes': ['goats', 'sheep', 'pigs'],
      'sheets': {
        'feed': ['Date', 'Qty (kg)', 'Type', 'Cost', 'Status'],
        'health': ['Date', 'Animal ID', 'Treatment', 'Cost', 'Status'],
        'breeding': ['Date', 'Animal ID', 'Partner ID', 'Notes', 'Status'],
        'weight': ['Date', 'Sample', 'Avg (kg)', 'Status'],
        'sales': ['Date', 'Animals', 'Weight', 'Price/kg', 'Total', 'Status'],
      },
    },
    'property': {
      'subTypes': ['rental', 'commercial'],
      'sheets': {
        'rent': ['Date', 'Unit', 'Tenant', 'Amount', 'Paid', 'Status'],
        'maintenance': [
          'Date',
          'Unit',
          'Issue',
          'Cost',
          'Contractor',
          'Status',
        ],
        'expenses': ['Date', 'Category', 'Amount', 'Status'],
      },
    },
    'transport': {
      'subTypes': ['trucks', 'boda', 'tractor'],
      'sheets': {
        'trips': ['Date', 'Vehicle', 'Route', 'Cargo', 'Income', 'Status'],
        'fuel': ['Date', 'Vehicle', 'Litres', 'Cost/L', 'Total', 'Status'],
        'maintenance': ['Date', 'Vehicle', 'Issue', 'Cost', 'Status'],
        'expenses': ['Date', 'Category', 'Amount', 'Status'],
      },
    },
    'contracts': {
      'subTypes': ['projects'],
      'sheets': {
        'milestones': ['Date', 'Milestone', 'Progress', 'Amount', 'Status'],
        'payments': ['Date', 'Amount', 'PaidBy', 'Method', 'Status'],
        'progress': ['Date', 'Notes', 'Percent', 'Status'],
        'expenses': ['Date', 'Category', 'Amount', 'Notes', 'Status'],
      },
    },
  };
}

// ...existing code...
