class StockMovement {
  final String id;
  final String inventoryItemId;
  final String type;
  final double quantity;
  final double unitCost;
  final double totalCost;
  final String reference;
  final String reason;
  final String recordedBy;
  final String? approvedBy;
  final String status;

  StockMovement({
    required this.id,
    required this.inventoryItemId,
    required this.type,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
    this.reference = '',
    this.reason = '',
    required this.recordedBy,
    this.approvedBy,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() => {
    'inventoryItemId': inventoryItemId,
    'type': type,
    'quantity': quantity,
    'unitCost': unitCost,
    'totalCost': totalCost,
    'reference': reference,
    'reason': reason,
    'recordedBy': recordedBy,
    'approvedBy': approvedBy,
    'status': status,
  };

  factory StockMovement.fromMap(String id, Map<String, dynamic> m) => StockMovement(
    id: id,
    inventoryItemId: m['inventoryItemId'] ?? '',
    type: m['type'] ?? 'in',
    quantity: (m['quantity'] ?? 0).toDouble(),
    unitCost: (m['unitCost'] ?? 0).toDouble(),
    totalCost: (m['totalCost'] ?? 0).toDouble(),
    reference: m['reference'] ?? '',
    reason: m['reason'] ?? '',
    recordedBy: m['recordedBy'] ?? '',
    approvedBy: m['approvedBy'],
    status: m['status'] ?? 'pending',
  );
}
