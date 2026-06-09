class BaseRecord {
  final String id;
  final String flockId;
  final String recordedBy;
  final String? approvedBy;
  final String status; // pending | approved | rejected
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  BaseRecord({
    required this.id,
    required this.flockId,
    required this.recordedBy,
    this.approvedBy,
    this.status = 'pending',
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toBaseMap() => {
    'flockId': flockId,
    'recordedBy': recordedBy,
    'approvedBy': approvedBy,
    'status': status,
    'rejectionReason': rejectionReason,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  BaseRecord copyWithBase({
    String? id,
    String? flockId,
    String? recordedBy,
    String? approvedBy,
    String? status,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BaseRecord(
      id: id ?? this.id,
      flockId: flockId ?? this.flockId,
      recordedBy: recordedBy ?? this.recordedBy,
      approvedBy: approvedBy ?? this.approvedBy,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
