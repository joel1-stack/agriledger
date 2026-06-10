import 'package:cloud_firestore/cloud_firestore.dart';

class Unit {
  final String id;
  final String module;
  final String subType;
  final String name;
  final String code;
  final String location;
  final int capacity;
  final int currentCount;
  final String status;
  final List<String> assignedWorkers;
  final String? managerId;
  final String businessUnitId;
  final DateTime createdAt;

  Unit({
    required this.id,
    required this.module,
    required this.subType,
    required this.name,
    this.code = '',
    this.location = '',
    this.capacity = 0,
    this.currentCount = 0,
    this.status = 'active',
    this.assignedWorkers = const [],
    this.managerId,
    this.businessUnitId = '',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'module': module,
    'subType': subType,
    'name': name,
    'code': code,
    'location': location,
    'capacity': capacity,
    'currentCount': currentCount,
    'status': status,
    'assignedWorkers': assignedWorkers,
    'managerId': managerId,
    'businessUnitId': businessUnitId,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory Unit.fromMap(String id, Map<String, dynamic> m) => Unit(
    id: id,
    module: m['module'] ?? '',
    subType: m['subType'] ?? '',
    name: m['name'] ?? '',
    code: m['code'] ?? '',
    location: m['location'] ?? '',
    capacity: m['capacity'] ?? 0,
    currentCount: m['currentCount'] ?? 0,
    status: m['status'] ?? 'active',
    assignedWorkers: List<String>.from(m['assignedWorkers'] ?? []),
    managerId: m['managerId'],
    businessUnitId: m['businessUnitId'] ?? '',
    createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}
