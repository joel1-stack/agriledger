/// Complete Module & Sheet Configuration for all Agri-Ledger modules
/// Defines columns, data types, and validation rules for each sheet

class ModuleSheetConfig {
  /// Master configuration for all modules and their sheets
  static final Map<String, dynamic> moduleConfigs = {
    // ═══════════════════════════════════════════════════════════════════════
    // POULTRY MODULE
    // ═══════════════════════════════════════════════════════════════════════
    'poultry': {
      'name': 'Poultry',
      'icon': '🐔',
      'color': 0xFF3B82F6, // Blue
      'subTypes': ['layers', 'broilers', 'kienyeji'],
      'sheets': {
        'layers': {
          'feed': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'qty_kg',
              'label': 'Qty (kg)',
              'type': 'decimal',
              'width': 80,
              'sum': true,
            },
            {
              'key': 'feed_type',
              'label': 'Feed Type',
              'type': 'select',
              'options': ['Grower', 'Layer', 'Starter'],
              'width': 100,
            },
            {
              'key': 'cost_per_kg',
              'label': 'Cost/kg',
              'type': 'currency',
              'width': 80,
            },
            {
              'key': 'total',
              'label': 'Total',
              'type': 'formula',
              'formula': 'qty_kg * cost_per_kg',
              'width': 90,
              'sum': true,
            },
            {'key': 'notes', 'label': 'Notes', 'type': 'text', 'width': 120},
          ],
          'mortality': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'dead',
              'label': 'Dead',
              'type': 'number',
              'width': 60,
              'sum': true,
            },
            {
              'key': 'cause',
              'label': 'Cause',
              'type': 'select',
              'options': ['Disease', 'Predator', 'Heat', 'Unknown'],
              'width': 100,
            },
            {
              'key': 'culled',
              'label': 'Culled',
              'type': 'number',
              'width': 60,
              'sum': true,
            },
            {
              'key': 'remaining',
              'label': 'Remaining',
              'type': 'number',
              'width': 80,
            },
          ],
          'eggs': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'total',
              'label': 'Total',
              'type': 'number',
              'width': 80,
              'sum': true,
            },
            {
              'key': 'broken',
              'label': 'Broken',
              'type': 'number',
              'width': 70,
              'sum': true,
            },
            {
              'key': 'small',
              'label': 'Small',
              'type': 'number',
              'width': 70,
              'sum': true,
            },
            {
              'key': 'medium',
              'label': 'Medium',
              'type': 'number',
              'width': 70,
              'sum': true,
            },
            {
              'key': 'large',
              'label': 'Large',
              'type': 'number',
              'width': 70,
              'sum': true,
            },
            {
              'key': 'trays',
              'label': 'Trays',
              'type': 'formula',
              'formula': 'total / 30',
              'width': 60,
            },
          ],
          'weight': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'sample', 'label': 'Sample', 'type': 'number', 'width': 70},
            {
              'key': 'avg_weight',
              'label': 'Avg (kg)',
              'type': 'decimal',
              'width': 80,
            },
            {
              'key': 'uniformity',
              'label': 'Uniformity %',
              'type': 'number',
              'width': 90,
            },
            {
              'key': 'target',
              'label': 'Target',
              'type': 'decimal',
              'width': 70,
            },
          ],
          'vet': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'treatment',
              'label': 'Treatment',
              'type': 'text',
              'width': 100,
            },
            {
              'key': 'medicine',
              'label': 'Medicine',
              'type': 'text',
              'width': 100,
            },
            {'key': 'dosage', 'label': 'Dosage', 'type': 'text', 'width': 80},
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 80,
              'sum': true,
            },
          ],
          'sales': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'trays',
              'label': 'Trays',
              'type': 'number',
              'width': 70,
              'sum': true,
            },
            {
              'key': 'price_per_tray',
              'label': 'Price/Tray',
              'type': 'currency',
              'width': 100,
            },
            {
              'key': 'total',
              'label': 'Total',
              'type': 'formula',
              'formula': 'trays * price_per_tray',
              'width': 100,
              'sum': true,
            },
            {'key': 'buyer', 'label': 'Buyer', 'type': 'text', 'width': 100},
            {
              'key': 'paid',
              'label': 'Paid',
              'type': 'select',
              'options': ['Yes', 'No', 'Partial'],
              'width': 70,
            },
          ],
        },
        'broilers': {
          'feed': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'qty_kg',
              'label': 'Qty (kg)',
              'type': 'decimal',
              'width': 80,
              'sum': true,
            },
            {
              'key': 'feed_type',
              'label': 'Type',
              'type': 'select',
              'options': ['Starter', 'Grower', 'Finisher'],
              'width': 100,
            },
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 80,
              'sum': true,
            },
            {'key': 'fcr', 'label': 'FCR', 'type': 'decimal', 'width': 60},
          ],
          'mortality': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'dead',
              'label': 'Dead',
              'type': 'number',
              'width': 70,
              'sum': true,
            },
            {
              'key': 'cause',
              'label': 'Cause',
              'type': 'select',
              'options': ['Disease', 'Predator', 'Heat', 'Unknown'],
              'width': 100,
            },
            {
              'key': 'remaining',
              'label': 'Remaining',
              'type': 'number',
              'width': 80,
            },
          ],
          'weight': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'sample', 'label': 'Sample', 'type': 'number', 'width': 70},
            {
              'key': 'avg_weight',
              'label': 'Avg (kg)',
              'type': 'decimal',
              'width': 80,
            },
            {
              'key': 'uniformity',
              'label': 'Uniformity %',
              'type': 'number',
              'width': 90,
            },
            {
              'key': 'target',
              'label': 'Target',
              'type': 'decimal',
              'width': 70,
            },
          ],
          'sales': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'birds',
              'label': 'Birds',
              'type': 'number',
              'width': 70,
              'sum': true,
            },
            {
              'key': 'total_weight',
              'label': 'Weight (kg)',
              'type': 'decimal',
              'width': 100,
              'sum': true,
            },
            {
              'key': 'price_per_kg',
              'label': 'Price/kg',
              'type': 'currency',
              'width': 90,
            },
            {
              'key': 'total',
              'label': 'Total',
              'type': 'formula',
              'formula': 'total_weight * price_per_kg',
              'width': 100,
              'sum': true,
            },
            {'key': 'buyer', 'label': 'Buyer', 'type': 'text', 'width': 100},
          ],
        },
        'kienyeji': {
          'feed': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'qty',
              'label': 'Qty',
              'type': 'decimal',
              'width': 70,
              'sum': true,
            },
            {
              'key': 'type',
              'label': 'Type',
              'type': 'select',
              'options': ['Commercial', 'Scavenge', 'Mixed'],
              'width': 100,
            },
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 80,
              'sum': true,
            },
          ],
          'mortality': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'dead',
              'label': 'Dead',
              'type': 'number',
              'width': 70,
              'sum': true,
            },
            {
              'key': 'cause',
              'label': 'Cause',
              'type': 'select',
              'options': ['Disease', 'Predator', 'Theft', 'Unknown'],
              'width': 100,
            },
            {
              'key': 'remaining',
              'label': 'Remaining',
              'type': 'number',
              'width': 80,
            },
          ],
          'eggs': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'collected',
              'label': 'Collected',
              'type': 'number',
              'width': 90,
              'sum': true,
            },
            {
              'key': 'broken',
              'label': 'Broken',
              'type': 'number',
              'width': 70,
              'sum': true,
            },
            {
              'key': 'trays',
              'label': 'Trays',
              'type': 'formula',
              'formula': 'collected / 30',
              'width': 70,
            },
          ],
          'sales': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'eggs',
              'label': 'Eggs',
              'type': 'number',
              'width': 70,
              'sum': true,
            },
            {'key': 'price', 'label': 'Price', 'type': 'currency', 'width': 80},
            {
              'key': 'total',
              'label': 'Total',
              'type': 'formula',
              'formula': 'eggs * price',
              'width': 90,
              'sum': true,
            },
          ],
        },
      },
    },

    // ═══════════════════════════════════════════════════════════════════════
    // DAIRY MODULE
    // ═══════════════════════════════════════════════════════════════════════
    'dairy': {
      'name': 'Dairy',
      'icon': '🐄',
      'color': 0xFFEF4444, // Red
      'subTypes': ['cows'],
      'sheets': {
        'cows': {
          'milk': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'cow_id', 'label': 'Cow ID', 'type': 'text', 'width': 80},
            {
              'key': 'morning',
              'label': 'Morning (L)',
              'type': 'decimal',
              'width': 90,
              'sum': true,
            },
            {
              'key': 'evening',
              'label': 'Evening (L)',
              'type': 'decimal',
              'width': 90,
              'sum': true,
            },
            {
              'key': 'total',
              'label': 'Total (L)',
              'type': 'formula',
              'formula': 'morning + evening',
              'width': 100,
              'sum': true,
            },
            {
              'key': 'quality',
              'label': 'Quality',
              'type': 'select',
              'options': ['A', 'B', 'C'],
              'width': 70,
            },
          ],
          'feed': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'qty_kg',
              'label': 'Qty (kg)',
              'type': 'decimal',
              'width': 80,
              'sum': true,
            },
            {
              'key': 'type',
              'label': 'Type',
              'type': 'select',
              'options': ['Napier', 'Dairy Meal', 'Minerals'],
              'width': 100,
            },
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 80,
              'sum': true,
            },
          ],
          'vet': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'cow_id', 'label': 'Cow ID', 'type': 'text', 'width': 80},
            {
              'key': 'treatment',
              'label': 'Treatment',
              'type': 'text',
              'width': 100,
            },
            {
              'key': 'medicine',
              'label': 'Medicine',
              'type': 'text',
              'width': 100,
            },
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 80,
              'sum': true,
            },
          ],
          'breeding': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'cow_id', 'label': 'Cow ID', 'type': 'text', 'width': 80},
            {'key': 'bull_id', 'label': 'Bull ID', 'type': 'text', 'width': 80},
            {
              'key': 'method',
              'label': 'Method',
              'type': 'select',
              'options': ['Natural', 'AI'],
              'width': 80,
            },
            {'key': 'notes', 'label': 'Notes', 'type': 'text', 'width': 120},
          ],
          'sales': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'litres',
              'label': 'Litres',
              'type': 'decimal',
              'width': 80,
              'sum': true,
            },
            {
              'key': 'price_per_litre',
              'label': 'Price/L',
              'type': 'currency',
              'width': 100,
            },
            {
              'key': 'total',
              'label': 'Total',
              'type': 'formula',
              'formula': 'litres * price_per_litre',
              'width': 100,
              'sum': true,
            },
            {'key': 'buyer', 'label': 'Buyer', 'type': 'text', 'width': 100},
          ],
        },
      },
    },

    // ═══════════════════════════════════════════════════════════════════════
    // CROPS MODULE
    // ═══════════════════════════════════════════════════════════════════════
    'crops': {
      'name': 'Crops',
      'icon': '🌾',
      'color': 0xFFF59E0B, // Amber
      'subTypes': ['maize', 'beans', 'vegetables'],
      'sheets': {
        'maize': {
          'planting': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'plot', 'label': 'Plot', 'type': 'text', 'width': 80},
            {
              'key': 'seed_type',
              'label': 'Seed',
              'type': 'select',
              'options': ['SC Duma', 'PH 4', 'DH 02'],
              'width': 100,
            },
            {
              'key': 'qty_kg',
              'label': 'Qty (kg)',
              'type': 'decimal',
              'width': 80,
              'sum': true,
            },
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 80,
              'sum': true,
            },
          ],
          'fertilizer': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'plot', 'label': 'Plot', 'type': 'text', 'width': 80},
            {
              'key': 'type',
              'label': 'Type',
              'type': 'select',
              'options': ['DAP', 'CAN', 'Urea'],
              'width': 80,
            },
            {
              'key': 'qty_kg',
              'label': 'Qty (kg)',
              'type': 'decimal',
              'width': 80,
              'sum': true,
            },
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 80,
              'sum': true,
            },
          ],
          'pest_control': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'plot', 'label': 'Plot', 'type': 'text', 'width': 80},
            {
              'key': 'pesticide',
              'label': 'Pesticide',
              'type': 'text',
              'width': 100,
            },
            {'key': 'qty', 'label': 'Qty', 'type': 'decimal', 'width': 70},
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 80,
              'sum': true,
            },
          ],
          'harvest': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'plot', 'label': 'Plot', 'type': 'text', 'width': 80},
            {
              'key': 'bags',
              'label': 'Bags (90kg)',
              'type': 'number',
              'width': 100,
              'sum': true,
            },
            {
              'key': 'quality',
              'label': 'Quality',
              'type': 'select',
              'options': ['Grade 1', 'Grade 2', 'Grade 3'],
              'width': 100,
            },
          ],
          'sales': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'bags',
              'label': 'Bags',
              'type': 'number',
              'width': 70,
              'sum': true,
            },
            {
              'key': 'price_per_bag',
              'label': 'Price/Bag',
              'type': 'currency',
              'width': 100,
            },
            {
              'key': 'total',
              'label': 'Total',
              'type': 'formula',
              'formula': 'bags * price_per_bag',
              'width': 100,
              'sum': true,
            },
            {'key': 'buyer', 'label': 'Buyer', 'type': 'text', 'width': 100},
          ],
        },
        'beans': {
          'planting': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'plot', 'label': 'Plot', 'type': 'text', 'width': 80},
            {
              'key': 'qty_kg',
              'label': 'Qty (kg)',
              'type': 'decimal',
              'width': 80,
              'sum': true,
            },
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 80,
              'sum': true,
            },
          ],
          'harvest': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'plot', 'label': 'Plot', 'type': 'text', 'width': 80},
            {
              'key': 'bags',
              'label': 'Bags',
              'type': 'number',
              'width': 80,
              'sum': true,
            },
          ],
          'sales': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'bags',
              'label': 'Bags',
              'type': 'number',
              'width': 80,
              'sum': true,
            },
            {'key': 'price', 'label': 'Price', 'type': 'currency', 'width': 80},
            {
              'key': 'total',
              'label': 'Total',
              'type': 'formula',
              'formula': 'bags * price',
              'width': 100,
              'sum': true,
            },
          ],
        },
      },
    },

    // ═══════════════════════════════════════════════════════════════════════
    // LIVESTOCK MODULE
    // ═══════════════════════════════════════════════════════════════════════
    'livestock': {
      'name': 'Livestock',
      'icon': '🐑',
      'color': 0xFF8B5CF6, // Purple
      'subTypes': ['goats', 'sheep', 'pigs'],
      'sheets': {
        'goats': {
          'feed': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'qty_kg',
              'label': 'Qty (kg)',
              'type': 'decimal',
              'width': 80,
              'sum': true,
            },
            {'key': 'type', 'label': 'Type', 'type': 'text', 'width': 100},
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 80,
              'sum': true,
            },
          ],
          'health': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'animal_id',
              'label': 'Animal ID',
              'type': 'text',
              'width': 90,
            },
            {
              'key': 'treatment',
              'label': 'Treatment',
              'type': 'text',
              'width': 100,
            },
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 80,
              'sum': true,
            },
          ],
          'breeding': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'animal_id',
              'label': 'Animal ID',
              'type': 'text',
              'width': 90,
            },
            {
              'key': 'partner_id',
              'label': 'Partner ID',
              'type': 'text',
              'width': 90,
            },
            {'key': 'notes', 'label': 'Notes', 'type': 'text', 'width': 120},
          ],
          'sales': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'animals',
              'label': 'Animals',
              'type': 'number',
              'width': 80,
              'sum': true,
            },
            {'key': 'price', 'label': 'Price', 'type': 'currency', 'width': 80},
            {
              'key': 'total',
              'label': 'Total',
              'type': 'formula',
              'formula': 'animals * price',
              'width': 100,
              'sum': true,
            },
          ],
        },
        'sheep': {
          'feed': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'qty_kg',
              'label': 'Qty (kg)',
              'type': 'decimal',
              'width': 80,
              'sum': true,
            },
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 80,
              'sum': true,
            },
          ],
          'health': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'treatment',
              'label': 'Treatment',
              'type': 'text',
              'width': 100,
            },
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 80,
              'sum': true,
            },
          ],
          'sales': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'animals',
              'label': 'Animals',
              'type': 'number',
              'width': 80,
              'sum': true,
            },
            {
              'key': 'total',
              'label': 'Total',
              'type': 'currency',
              'width': 100,
              'sum': true,
            },
          ],
        },
      },
    },

    // ═══════════════════════════════════════════════════════════════════════
    // INVENTORY MODULE
    // ═══════════════════════════════════════════════════════════════════════
    'inventory': {
      'name': 'Inventory',
      'icon': '📦',
      'color': 0xFF06B6D4, // Cyan
      'subTypes': ['general'],
      'sheets': {
        'general': {
          'stock_card': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'item', 'label': 'Item', 'type': 'text', 'width': 120},
            {'key': 'sku', 'label': 'SKU', 'type': 'text', 'width': 90},
            {
              'key': 'in_qty',
              'label': 'In',
              'type': 'number',
              'width': 70,
              'sum': true,
            },
            {
              'key': 'out_qty',
              'label': 'Out',
              'type': 'number',
              'width': 70,
              'sum': true,
            },
            {
              'key': 'balance',
              'label': 'Balance',
              'type': 'number',
              'width': 80,
            },
            {
              'key': 'unit_cost',
              'label': 'Unit Cost',
              'type': 'currency',
              'width': 90,
            },
            {
              'key': 'value',
              'label': 'Value',
              'type': 'currency',
              'width': 100,
              'sum': true,
            },
          ],
          'reorder': [
            {'key': 'item', 'label': 'Item', 'type': 'text', 'width': 120},
            {
              'key': 'current',
              'label': 'Current',
              'type': 'number',
              'width': 80,
            },
            {
              'key': 'reorder_level',
              'label': 'Reorder Lvl',
              'type': 'number',
              'width': 100,
            },
            {
              'key': 'reorder_qty',
              'label': 'Reorder Qty',
              'type': 'number',
              'width': 100,
            },
            {
              'key': 'supplier',
              'label': 'Supplier',
              'type': 'text',
              'width': 100,
            },
          ],
        },
      },
    },

    // ═══════════════════════════════════════════════════════════════════════
    // CASHBOOK MODULE
    // ═══════════════════════════════════════════════════════════════════════
    'cashbook': {
      'name': 'Cashbook',
      'icon': '💰',
      'color': 0xFF10B981, // Green
      'subTypes': ['general'],
      'sheets': {
        'general': {
          'journal': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'ref', 'label': 'Reference', 'type': 'text', 'width': 80},
            {
              'key': 'description',
              'label': 'Description',
              'type': 'text',
              'width': 150,
            },
            {
              'key': 'account',
              'label': 'Account',
              'type': 'select',
              'options': ['Cash', 'Bank', 'Mpesa'],
              'width': 100,
            },
            {
              'key': 'debit',
              'label': 'Debit',
              'type': 'currency',
              'width': 90,
              'sum': true,
            },
            {
              'key': 'credit',
              'label': 'Credit',
              'type': 'currency',
              'width': 90,
              'sum': true,
            },
            {
              'key': 'balance',
              'label': 'Balance',
              'type': 'currency',
              'width': 100,
            },
          ],
          'bank_recon': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {
              'key': 'description',
              'label': 'Description',
              'type': 'text',
              'width': 150,
            },
            {
              'key': 'bank_balance',
              'label': 'Bank',
              'type': 'currency',
              'width': 100,
            },
            {
              'key': 'book_balance',
              'label': 'Book',
              'type': 'currency',
              'width': 100,
            },
            {
              'key': 'difference',
              'label': 'Difference',
              'type': 'currency',
              'width': 100,
            },
            {
              'key': 'reconciled',
              'label': 'Reconciled',
              'type': 'select',
              'options': ['Yes', 'No'],
              'width': 100,
            },
          ],
        },
      },
    },

    // ═══════════════════════════════════════════════════════════════════════
    // PROPERTY MODULE
    // ═══════════════════════════════════════════════════════════════════════
    'property': {
      'name': 'Property',
      'icon': '🏠',
      'color': 0xFFA78BFA, // Purple-light
      'subTypes': ['rental', 'commercial'],
      'sheets': {
        'rental': {
          'rent': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'unit', 'label': 'Unit', 'type': 'text', 'width': 80},
            {'key': 'tenant', 'label': 'Tenant', 'type': 'text', 'width': 100},
            {
              'key': 'amount',
              'label': 'Amount',
              'type': 'currency',
              'width': 100,
              'sum': true,
            },
            {
              'key': 'paid',
              'label': 'Paid',
              'type': 'select',
              'options': ['Yes', 'No', 'Partial'],
              'width': 80,
            },
          ],
          'maintenance': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'unit', 'label': 'Unit', 'type': 'text', 'width': 80},
            {'key': 'issue', 'label': 'Issue', 'type': 'text', 'width': 120},
            {
              'key': 'contractor',
              'label': 'Contractor',
              'type': 'text',
              'width': 100,
            },
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 100,
              'sum': true,
            },
          ],
        },
      },
    },

    // ═══════════════════════════════════════════════════════════════════════
    // TRANSPORT MODULE
    // ═══════════════════════════════════════════════════════════════════════
    'transport': {
      'name': 'Transport',
      'icon': '🚛',
      'color': 0xFF0EA5E9, // Sky
      'subTypes': ['trucks', 'boda', 'tractor'],
      'sheets': {
        'trucks': {
          'trips': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'vehicle', 'label': 'Vehicle', 'type': 'text', 'width': 90},
            {'key': 'route', 'label': 'Route', 'type': 'text', 'width': 100},
            {'key': 'cargo', 'label': 'Cargo', 'type': 'text', 'width': 100},
            {
              'key': 'income',
              'label': 'Income',
              'type': 'currency',
              'width': 100,
              'sum': true,
            },
            {
              'key': 'expenses',
              'label': 'Expenses',
              'type': 'currency',
              'width': 100,
              'sum': true,
            },
            {
              'key': 'profit',
              'label': 'Profit',
              'type': 'formula',
              'formula': 'income - expenses',
              'width': 100,
              'sum': true,
            },
          ],
          'fuel': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'vehicle', 'label': 'Vehicle', 'type': 'text', 'width': 90},
            {
              'key': 'litres',
              'label': 'Litres',
              'type': 'decimal',
              'width': 80,
              'sum': true,
            },
            {
              'key': 'price_per_litre',
              'label': 'Price/L',
              'type': 'currency',
              'width': 100,
            },
            {
              'key': 'total',
              'label': 'Total',
              'type': 'formula',
              'formula': 'litres * price_per_litre',
              'width': 100,
              'sum': true,
            },
          ],
          'maintenance': [
            {
              'key': 'date',
              'label': 'Date',
              'type': 'date',
              'width': 80,
              'required': true,
            },
            {'key': 'vehicle', 'label': 'Vehicle', 'type': 'text', 'width': 90},
            {'key': 'issue', 'label': 'Issue', 'type': 'text', 'width': 120},
            {
              'key': 'cost',
              'label': 'Cost',
              'type': 'currency',
              'width': 100,
              'sum': true,
            },
          ],
        },
      },
    },
  };

  /// Get all module names
  static List<String> getAllModules() =>
      moduleConfigs.keys.cast<String>().toList();

  /// Get module config
  static Map<String, dynamic>? getModuleConfig(String module) =>
      moduleConfigs[module] as Map<String, dynamic>?;

  /// Get sub-types for a module
  static List<String> getSubTypes(String module) {
    final config = getModuleConfig(module);
    return config != null ? List<String>.from(config['subTypes'] ?? []) : [];
  }

  /// Get sheets for a module and subtype
  static List<String> getSheets(String module, String subType) {
    final config = getModuleConfig(module);
    final sheets = config?['sheets'] as Map?;
    final subTypeConfig = sheets?[subType] as Map?;
    return subTypeConfig?.keys.cast<String>().toList() ?? [];
  }

  /// Get columns for a sheet
  static List<Map<String, dynamic>> getColumns(
    String module,
    String subType,
    String sheet,
  ) {
    final config = getModuleConfig(module);
    final sheets = config?['sheets'] as Map?;
    final subTypeConfig = sheets?[subType] as Map?;
    final sheetConfig = subTypeConfig?[sheet] as List?;
    return sheetConfig?.cast<Map<String, dynamic>>() ?? [];
  }

  /// Get module metadata
  static String getModuleName(String module) =>
      getModuleConfig(module)?['name'] ?? module;

  static String getModuleIcon(String module) =>
      getModuleConfig(module)?['icon'] ?? '📦';

  static int getModuleColor(String module) =>
      getModuleConfig(module)?['color'] ?? 0xFF000000;
}
