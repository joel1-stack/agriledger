class ModuleSheetConfig {
  static final Map<String, Map<String, Map<String, List<Map<String, dynamic>>>>> configs = {

    // ═══════════════════════════════════════════════════════════
    // POULTRY
    // ═══════════════════════════════════════════════════════════
    'poultry': {
      'layers': {
        'feed': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'qty', 'label': 'Qty (kg)', 'type': 'number', 'width': 80, 'sum': true},
          {'key': 'feed_type', 'label': 'Feed Type', 'type': 'select', 'options': ['Grower', 'Layer', 'Starter'], 'width': 100},
          {'key': 'cost_per_kg', 'label': 'Cost/kg', 'type': 'currency', 'width': 80},
          {'key': 'total', 'label': 'Total', 'type': 'formula', 'formula': 'qty * cost_per_kg', 'width': 90, 'sum': true},
          {'key': 'flock_count', 'label': 'Birds', 'type': 'number', 'width': 60},
          {'key': 'notes', 'label': 'Notes', 'type': 'text', 'width': 120},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'mortality': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'dead', 'label': 'Dead', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'cause', 'label': 'Cause', 'type': 'select', 'options': ['Disease', 'Predator', 'Heat', 'Unknown'], 'width': 90},
          {'key': 'culled', 'label': 'Culled', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'remaining', 'label': 'Remaining', 'type': 'formula', 'formula': 'prev_remaining - dead - culled', 'width': 80},
          {'key': 'photo', 'label': 'Photo', 'type': 'image', 'width': 60},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'eggs': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'total', 'label': 'Total Eggs', 'type': 'number', 'width': 80, 'sum': true},
          {'key': 'broken', 'label': 'Broken', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'small', 'label': 'Small', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'medium', 'label': 'Medium', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'large', 'label': 'Large', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'trays', 'label': 'Trays', 'type': 'formula', 'formula': 'total / 30', 'width': 60, 'sum': true},
          {'key': 'percent_prod', 'label': '% Prod', 'type': 'formula', 'formula': '(total / flock_count) * 100', 'width': 70},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'sales': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'trays', 'label': 'Trays', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'price_per_tray', 'label': 'Price/Tray', 'type': 'currency', 'width': 90},
          {'key': 'total', 'label': 'Total', 'type': 'formula', 'formula': 'trays * price_per_tray', 'width': 100, 'sum': true},
          {'key': 'buyer', 'label': 'Buyer', 'type': 'text', 'width': 100},
          {'key': 'paid', 'label': 'Paid', 'type': 'select', 'options': ['Yes', 'No', 'Partial'], 'width': 70},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
      'broilers': {
        'feed': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'qty', 'label': 'Qty (kg)', 'type': 'number', 'width': 80, 'sum': true},
          {'key': 'feed_type', 'label': 'Type', 'type': 'select', 'options': ['Starter', 'Grower', 'Finisher'], 'width': 90},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'fcr', 'label': 'FCR', 'type': 'formula', 'formula': 'cumulative_feed / weight_gain', 'width': 60},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'mortality': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'dead', 'label': 'Dead', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'cause', 'label': 'Cause', 'type': 'select', 'options': ['Disease', 'Predator', 'Heat', 'Unknown'], 'width': 90},
          {'key': 'remaining', 'label': 'Remaining', 'type': 'formula', 'formula': 'prev - dead', 'width': 80},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'weight': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'sample', 'label': 'Sample', 'type': 'number', 'width': 70},
          {'key': 'avg_weight', 'label': 'Avg (kg)', 'type': 'decimal', 'width': 80},
          {'key': 'uniformity', 'label': 'Uniformity %', 'type': 'number', 'width': 80},
          {'key': 'target', 'label': 'Target', 'type': 'decimal', 'width': 70},
          {'key': 'variance', 'label': 'Variance', 'type': 'formula', 'formula': 'avg_weight - target', 'width': 70},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'sales': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'birds', 'label': 'Birds', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'total_weight', 'label': 'Weight (kg)', 'type': 'decimal', 'width': 90, 'sum': true},
          {'key': 'price_per_kg', 'label': 'Price/kg', 'type': 'currency', 'width': 80},
          {'key': 'total', 'label': 'Total', 'type': 'formula', 'formula': 'total_weight * price_per_kg', 'width': 100, 'sum': true},
          {'key': 'buyer', 'label': 'Buyer', 'type': 'text', 'width': 100},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
      'kienyeji': {
        'feed': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'qty', 'label': 'Qty', 'type': 'number', 'width': 70, 'sum': true},
          {'key': 'type', 'label': 'Type', 'type': 'select', 'options': ['Commercial', 'Scavenge', 'Mixed'], 'width': 100},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'mortality': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'dead', 'label': 'Dead', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'cause', 'label': 'Cause', 'type': 'select', 'options': ['Disease', 'Predator', 'Theft', 'Unknown'], 'width': 90},
          {'key': 'remaining', 'label': 'Remaining', 'type': 'formula', 'formula': 'prev - dead', 'width': 80},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'eggs': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'collected', 'label': 'Collected', 'type': 'number', 'width': 80, 'sum': true},
          {'key': 'broken', 'label': 'Broken', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'trays', 'label': 'Trays', 'type': 'formula', 'formula': 'collected / 30', 'width': 60},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'sales': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'eggs', 'label': 'Eggs', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'price', 'label': 'Price', 'type': 'currency', 'width': 80},
          {'key': 'total', 'label': 'Total', 'type': 'formula', 'formula': 'eggs * price', 'width': 90, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
    },

    // ═══════════════════════════════════════════════════════════
    // DAIRY
    // ═══════════════════════════════════════════════════════════
    'dairy': {
      'cows': {
        'milk': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'cow_id', 'label': 'Cow ID', 'type': 'text', 'width': 80},
          {'key': 'morning', 'label': 'Morning (L)', 'type': 'decimal', 'width': 90, 'sum': true},
          {'key': 'evening', 'label': 'Evening (L)', 'type': 'decimal', 'width': 90, 'sum': true},
          {'key': 'total', 'label': 'Total (L)', 'type': 'formula', 'formula': 'morning + evening', 'width': 90, 'sum': true},
          {'key': 'quality', 'label': 'Quality', 'type': 'select', 'options': ['A', 'B', 'C'], 'width': 70},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'feed': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'qty', 'label': 'Qty (kg)', 'type': 'decimal', 'width': 80, 'sum': true},
          {'key': 'type', 'label': 'Type', 'type': 'select', 'options': ['Napier', 'Dairy Meal', 'Minerals'], 'width': 100},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'vet': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'cow_id', 'label': 'Cow ID', 'type': 'text', 'width': 80},
          {'key': 'treatment', 'label': 'Treatment', 'type': 'text', 'width': 100},
          {'key': 'medicine', 'label': 'Medicine', 'type': 'text', 'width': 100},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'next_date', 'label': 'Next Date', 'type': 'date', 'width': 90},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'sales': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'litres', 'label': 'Litres', 'type': 'decimal', 'width': 70, 'sum': true},
          {'key': 'price_per_litre', 'label': 'Price/L', 'type': 'currency', 'width': 80},
          {'key': 'total', 'label': 'Total', 'type': 'formula', 'formula': 'litres * price_per_litre', 'width': 100, 'sum': true},
          {'key': 'buyer', 'label': 'Buyer', 'type': 'text', 'width': 100},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
    },

    // ═══════════════════════════════════════════════════════════
    // CROPS
    // ═══════════════════════════════════════════════════════════
    'crops': {
      'maize': {
        'planting': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'plot', 'label': 'Plot', 'type': 'text', 'width': 80},
          {'key': 'seed_type', 'label': 'Seed', 'type': 'select', 'options': ['SC Duma', 'PH 4', 'DH 02'], 'width': 90},
          {'key': 'qty', 'label': 'Qty (kg)', 'type': 'decimal', 'width': 80, 'sum': true},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'fertilizer': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'plot', 'label': 'Plot', 'type': 'text', 'width': 80},
          {'key': 'type', 'label': 'Type', 'type': 'select', 'options': ['DAP', 'CAN', 'Urea'], 'width': 80},
          {'key': 'qty', 'label': 'Qty (kg)', 'type': 'decimal', 'width': 80, 'sum': true},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'harvest': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'plot', 'label': 'Plot', 'type': 'text', 'width': 80},
          {'key': 'bags', 'label': 'Bags (90kg)', 'type': 'number', 'width': 90, 'sum': true},
          {'key': 'quality', 'label': 'Quality', 'type': 'select', 'options': ['Grade 1', 'Grade 2', 'Grade 3'], 'width': 90},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'sales': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'bags', 'label': 'Bags', 'type': 'number', 'width': 70, 'sum': true},
          {'key': 'price_per_bag', 'label': 'Price/Bag', 'type': 'currency', 'width': 90},
          {'key': 'total', 'label': 'Total', 'type': 'formula', 'formula': 'bags * price_per_bag', 'width': 100, 'sum': true},
          {'key': 'buyer', 'label': 'Buyer', 'type': 'text', 'width': 100},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
      'beans': {
        'planting': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'plot', 'label': 'Plot', 'type': 'text', 'width': 80},
          {'key': 'qty', 'label': 'Qty (kg)', 'type': 'decimal', 'width': 80, 'sum': true},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'harvest': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'plot', 'label': 'Plot', 'type': 'text', 'width': 80},
          {'key': 'bags', 'label': 'Bags', 'type': 'number', 'width': 70, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'sales': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'bags', 'label': 'Bags', 'type': 'number', 'width': 70, 'sum': true},
          {'key': 'price', 'label': 'Price', 'type': 'currency', 'width': 80},
          {'key': 'total', 'label': 'Total', 'type': 'formula', 'formula': 'bags * price', 'width': 90, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
    },

    // ═══════════════════════════════════════════════════════════
    // LIVESTOCK
    // ═══════════════════════════════════════════════════════════
    'livestock': {
      'goats': {
        'feed': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'qty', 'label': 'Qty (kg)', 'type': 'decimal', 'width': 80, 'sum': true},
          {'key': 'type', 'label': 'Type', 'type': 'select', 'options': ['Hay', 'Concentrate', 'Minerals'], 'width': 100},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'health': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'animal_id', 'label': 'Animal ID', 'type': 'text', 'width': 80},
          {'key': 'treatment', 'label': 'Treatment', 'type': 'text', 'width': 100},
          {'key': 'medicine', 'label': 'Medicine', 'type': 'text', 'width': 100},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'next_date', 'label': 'Next Date', 'type': 'date', 'width': 90},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'breeding': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'animal_id', 'label': 'Animal ID', 'type': 'text', 'width': 80},
          {'key': 'partner_id', 'label': 'Partner ID', 'type': 'text', 'width': 80},
          {'key': 'notes', 'label': 'Notes', 'type': 'text', 'width': 120},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'weight': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'sample', 'label': 'Sample', 'type': 'number', 'width': 70},
          {'key': 'avg_weight', 'label': 'Avg (kg)', 'type': 'decimal', 'width': 80},
          {'key': 'target', 'label': 'Target', 'type': 'decimal', 'width': 70},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'sales': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'animals', 'label': 'Animals', 'type': 'number', 'width': 70, 'sum': true},
          {'key': 'weight', 'label': 'Weight (kg)', 'type': 'decimal', 'width': 80, 'sum': true},
          {'key': 'price_per_kg', 'label': 'Price/kg', 'type': 'currency', 'width': 80},
          {'key': 'total', 'label': 'Total', 'type': 'formula', 'formula': 'weight * price_per_kg', 'width': 90, 'sum': true},
          {'key': 'buyer', 'label': 'Buyer', 'type': 'text', 'width': 100},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
      'sheep': {
        'feed': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'qty', 'label': 'Qty (kg)', 'type': 'decimal', 'width': 80, 'sum': true},
          {'key': 'type', 'label': 'Type', 'type': 'select', 'options': ['Hay', 'Concentrate', 'Pasture'], 'width': 100},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'health': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'animal_id', 'label': 'Animal ID', 'type': 'text', 'width': 80},
          {'key': 'treatment', 'label': 'Treatment', 'type': 'text', 'width': 100},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'sales': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'animals', 'label': 'Animals', 'type': 'number', 'width': 70, 'sum': true},
          {'key': 'price_per_head', 'label': 'Price/Head', 'type': 'currency', 'width': 90},
          {'key': 'total', 'label': 'Total', 'type': 'formula', 'formula': 'animals * price_per_head', 'width': 90, 'sum': true},
          {'key': 'buyer', 'label': 'Buyer', 'type': 'text', 'width': 100},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
      'pigs': {
        'feed': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'qty', 'label': 'Qty (kg)', 'type': 'decimal', 'width': 80, 'sum': true},
          {'key': 'type', 'label': 'Type', 'type': 'select', 'options': ['Starter', 'Grower', 'Finisher'], 'width': 100},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'health': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'animal_id', 'label': 'Animal ID', 'type': 'text', 'width': 80},
          {'key': 'treatment', 'label': 'Treatment', 'type': 'text', 'width': 100},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'next_date', 'label': 'Next Date', 'type': 'date', 'width': 90},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'breeding': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'sow_id', 'label': 'Sow ID', 'type': 'text', 'width': 80},
          {'key': 'boar_id', 'label': 'Boar ID', 'type': 'text', 'width': 80},
          {'key': 'service_date', 'label': 'Service Date', 'type': 'date', 'width': 90},
          {'key': 'expected_farrow', 'label': 'Due Date', 'type': 'date', 'width': 90},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'sales': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'pigs', 'label': 'Pigs', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'avg_weight', 'label': 'Avg (kg)', 'type': 'decimal', 'width': 70},
          {'key': 'price_per_kg', 'label': 'Price/kg', 'type': 'currency', 'width': 80},
          {'key': 'total', 'label': 'Total', 'type': 'formula', 'formula': 'pigs * avg_weight * price_per_kg', 'width': 100, 'sum': true},
          {'key': 'buyer', 'label': 'Buyer', 'type': 'text', 'width': 100},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
    },

    // ═══════════════════════════════════════════════════════════
    // PROPERTY
    // ═══════════════════════════════════════════════════════════
    'property': {
      'rental': {
        'rent': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'unit', 'label': 'Unit', 'type': 'text', 'width': 80},
          {'key': 'tenant', 'label': 'Tenant', 'type': 'text', 'width': 100},
          {'key': 'amount', 'label': 'Amount', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'paid', 'label': 'Paid', 'type': 'select', 'options': ['Yes', 'No', 'Partial'], 'width': 70},
          {'key': 'balance', 'label': 'Balance', 'type': 'currency', 'width': 90},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'maintenance': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'unit', 'label': 'Unit', 'type': 'text', 'width': 80},
          {'key': 'issue', 'label': 'Issue', 'type': 'text', 'width': 120},
          {'key': 'contractor', 'label': 'Contractor', 'type': 'text', 'width': 100},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
    },

    // ═══════════════════════════════════════════════════════════
    // TRANSPORT
    // ═══════════════════════════════════════════════════════════
    'transport': {
      'trucks': {
        'trips': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'vehicle', 'label': 'Vehicle', 'type': 'text', 'width': 90},
          {'key': 'route', 'label': 'Route', 'type': 'text', 'width': 100},
          {'key': 'cargo', 'label': 'Cargo', 'type': 'text', 'width': 100},
          {'key': 'income', 'label': 'Income', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'expenses', 'label': 'Expenses', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'profit', 'label': 'Profit', 'type': 'formula', 'formula': 'income - expenses', 'width': 90, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'fuel': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'vehicle', 'label': 'Vehicle', 'type': 'text', 'width': 90},
          {'key': 'litres', 'label': 'Litres', 'type': 'decimal', 'width': 70, 'sum': true},
          {'key': 'price_per_litre', 'label': 'Price/L', 'type': 'currency', 'width': 80},
          {'key': 'total', 'label': 'Total', 'type': 'formula', 'formula': 'litres * price_per_litre', 'width': 90, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'maintenance': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'vehicle', 'label': 'Vehicle', 'type': 'text', 'width': 90},
          {'key': 'issue', 'label': 'Issue', 'type': 'text', 'width': 120},
          {'key': 'cost', 'label': 'Cost', 'type': 'currency', 'width': 80, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
    },

    // ═══════════════════════════════════════════════════════════
    // CASHBOOK
    // ═══════════════════════════════════════════════════════════
    'cashbook': {
      'income': {
        'daily_entries': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'ref', 'label': 'Ref', 'type': 'text', 'width': 70},
          {'key': 'description', 'label': 'Description', 'type': 'text', 'width': 150},
          {'key': 'account', 'label': 'Account', 'type': 'select', 'options': ['Cash', 'Bank', 'Mpesa'], 'width': 90},
          {'key': 'debit', 'label': 'Debit', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'credit', 'label': 'Credit', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'balance', 'label': 'Balance', 'type': 'formula', 'formula': 'prev + debit - credit', 'width': 100},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'bank_reconciliation': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'description', 'label': 'Description', 'type': 'text', 'width': 150},
          {'key': 'bank_balance', 'label': 'Bank', 'type': 'currency', 'width': 90},
          {'key': 'book_balance', 'label': 'Book', 'type': 'currency', 'width': 90},
          {'key': 'difference', 'label': 'Diff', 'type': 'formula', 'formula': 'bank_balance - book_balance', 'width': 80},
          {'key': 'reconciled', 'label': 'Reconciled', 'type': 'select', 'options': ['Yes', 'No'], 'width': 90},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
      'expense': {
        'daily_entries': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'ref', 'label': 'Ref', 'type': 'text', 'width': 70},
          {'key': 'description', 'label': 'Description', 'type': 'text', 'width': 150},
          {'key': 'account', 'label': 'Account', 'type': 'select', 'options': ['Cash', 'Bank', 'Mpesa'], 'width': 90},
          {'key': 'debit', 'label': 'Debit', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'credit', 'label': 'Credit', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'balance', 'label': 'Balance', 'type': 'formula', 'formula': 'prev + debit - credit', 'width': 100},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'bank_reconciliation': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'description', 'label': 'Description', 'type': 'text', 'width': 150},
          {'key': 'bank_balance', 'label': 'Bank', 'type': 'currency', 'width': 90},
          {'key': 'book_balance', 'label': 'Book', 'type': 'currency', 'width': 90},
          {'key': 'difference', 'label': 'Diff', 'type': 'formula', 'formula': 'bank_balance - book_balance', 'width': 80},
          {'key': 'reconciled', 'label': 'Reconciled', 'type': 'select', 'options': ['Yes', 'No'], 'width': 90},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
    },

    // ═══════════════════════════════════════════════════════════
    // INVENTORY
    // ═══════════════════════════════════════════════════════════
    'inventory': {
      'general': {
        'stock_card': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'item', 'label': 'Item', 'type': 'text', 'width': 120},
          {'key': 'sku', 'label': 'SKU', 'type': 'text', 'width': 80},
          {'key': 'in', 'label': 'In', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'out', 'label': 'Out', 'type': 'number', 'width': 60, 'sum': true},
          {'key': 'balance', 'label': 'Balance', 'type': 'formula', 'formula': 'prev + in - out', 'width': 70},
          {'key': 'unit_cost', 'label': 'Unit Cost', 'type': 'currency', 'width': 80},
          {'key': 'total_value', 'label': 'Value', 'type': 'formula', 'formula': 'balance * unit_cost', 'width': 90, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'reorder': [
          {'key': 'item', 'label': 'Item', 'type': 'text', 'width': 120},
          {'key': 'current', 'label': 'Current', 'type': 'number', 'width': 70},
          {'key': 'reorder_level', 'label': 'Reorder Lvl', 'type': 'number', 'width': 80},
          {'key': 'reorder_qty', 'label': 'Reorder Qty', 'type': 'number', 'width': 90},
          {'key': 'supplier', 'label': 'Supplier', 'type': 'text', 'width': 100},
          {'key': 'last_order', 'label': 'Last Order', 'type': 'date', 'width': 90},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
    },

    // ═══════════════════════════════════════════════════════════
    // JOURNAL
    // ═══════════════════════════════════════════════════════════
    'journal': {
      'general_ledger': {
        'debits': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'ref', 'label': 'Ref', 'type': 'text', 'width': 70},
          {'key': 'description', 'label': 'Description', 'type': 'text', 'width': 150},
          {'key': 'account', 'label': 'Account', 'type': 'text', 'width': 100},
          {'key': 'debit', 'label': 'Debit', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'credit', 'label': 'Credit', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'balanced', 'label': 'Balanced', 'type': 'select', 'options': ['Yes', 'No'], 'width': 80},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'credits': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'ref', 'label': 'Ref', 'type': 'text', 'width': 70},
          {'key': 'description', 'label': 'Description', 'type': 'text', 'width': 150},
          {'key': 'account', 'label': 'Account', 'type': 'text', 'width': 100},
          {'key': 'credit', 'label': 'Credit', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'debit', 'label': 'Debit', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'balanced', 'label': 'Balanced', 'type': 'select', 'options': ['Yes', 'No'], 'width': 80},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'balances': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'ref', 'label': 'Ref', 'type': 'text', 'width': 70},
          {'key': 'description', 'label': 'Description', 'type': 'text', 'width': 150},
          {'key': 'total_debit', 'label': 'Total Debit', 'type': 'currency', 'width': 100, 'sum': true},
          {'key': 'total_credit', 'label': 'Total Credit', 'type': 'currency', 'width': 100, 'sum': true},
          {'key': 'difference', 'label': 'Difference', 'type': 'formula', 'formula': 'total_debit - total_credit', 'width': 90},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
      'adjustments': {
        'debits': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'ref', 'label': 'Ref', 'type': 'text', 'width': 70},
          {'key': 'description', 'label': 'Description', 'type': 'text', 'width': 150},
          {'key': 'account', 'label': 'Account', 'type': 'text', 'width': 100},
          {'key': 'debit', 'label': 'Debit', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'credit', 'label': 'Credit', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'balanced', 'label': 'Balanced', 'type': 'select', 'options': ['Yes', 'No'], 'width': 80},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'credits': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'ref', 'label': 'Ref', 'type': 'text', 'width': 70},
          {'key': 'description', 'label': 'Description', 'type': 'text', 'width': 150},
          {'key': 'account', 'label': 'Account', 'type': 'text', 'width': 100},
          {'key': 'credit', 'label': 'Credit', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'debit', 'label': 'Debit', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'balanced', 'label': 'Balanced', 'type': 'select', 'options': ['Yes', 'No'], 'width': 80},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'balances': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'ref', 'label': 'Ref', 'type': 'text', 'width': 70},
          {'key': 'description', 'label': 'Description', 'type': 'text', 'width': 150},
          {'key': 'total_debit', 'label': 'Total Debit', 'type': 'currency', 'width': 100, 'sum': true},
          {'key': 'total_credit', 'label': 'Total Credit', 'type': 'currency', 'width': 100, 'sum': true},
          {'key': 'difference', 'label': 'Difference', 'type': 'formula', 'formula': 'total_debit - total_credit', 'width': 90},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
    },

    // ═══════════════════════════════════════════════════════════
    // CONTRACTS
    // ═══════════════════════════════════════════════════════════
    'contracts': {
      'projects': {
        'milestones': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'project', 'label': 'Project', 'type': 'text', 'width': 120},
          {'key': 'milestone', 'label': 'Milestone', 'type': 'text', 'width': 120},
          {'key': 'progress', 'label': 'Progress %', 'type': 'number', 'width': 80},
          {'key': 'amount', 'label': 'Amount', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'payments': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'project', 'label': 'Project', 'type': 'text', 'width': 120},
          {'key': 'amount', 'label': 'Amount', 'type': 'currency', 'width': 90, 'sum': true},
          {'key': 'paid_by', 'label': 'Paid By', 'type': 'text', 'width': 100},
          {'key': 'method', 'label': 'Method', 'type': 'select', 'options': ['Cash', 'Bank', 'Mpesa', 'Cheque'], 'width': 80},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
        'progress': [
          {'key': 'date', 'label': 'Date', 'type': 'date', 'width': 80},
          {'key': 'project', 'label': 'Project', 'type': 'text', 'width': 120},
          {'key': 'notes', 'label': 'Notes', 'type': 'text', 'width': 150},
          {'key': 'percent', 'label': 'Percent', 'type': 'number', 'width': 70},
          {'key': 'status', 'label': 'Status', 'type': 'status', 'width': 80},
        ],
      },
    },
  };
}
