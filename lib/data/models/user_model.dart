import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String role; // super_admin | manager | worker
  final List<String> assignedFlocks;
  final bool isActive;
  final String? phone;
  final String? fcmToken;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.assignedFlocks = const [],
    this.isActive = true,
    this.phone,
    this.fcmToken,
    required this.createdAt,
  });

  bool get isSuperAdmin => role == 'super_admin';
  bool get isManager => role == 'manager';
  bool get isWorker => role == 'worker';
  bool get canAddEdit => isSuperAdmin || isManager || isWorker;
  bool get canApprove => isManager;
  bool get canManageUsers => isSuperAdmin;
  bool get canDelete => isSuperAdmin;

  Map<String, dynamic> toFirestore() => {
    'email': email,
    'name': name,
    'role': role,
    'assignedFlocks': assignedFlocks,
    'isActive': isActive,
    'phone': phone,
    'fcmToken': fcmToken,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      id: doc.id,
      email: m['email'] ?? '',
      name: m['name'] ?? '',
      role: m['role'] ?? 'worker',
      assignedFlocks: List<String>.from(m['assignedFlocks'] ?? []),
      isActive: m['isActive'] ?? true,
      phone: m['phone'],
      fcmToken: m['fcmToken'],
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  UserModel copyWith({
    String? name,
    String? role,
    List<String>? assignedFlocks,
    bool? isActive,
    String? phone,
    String? fcmToken,
  }) =>
      UserModel(
        id: id,
        email: email,
        name: name ?? this.name,
        role: role ?? this.role,
        assignedFlocks: assignedFlocks ?? this.assignedFlocks,
        isActive: isActive ?? this.isActive,
        phone: phone ?? this.phone,
        fcmToken: fcmToken ?? this.fcmToken,
        createdAt: createdAt,
      );
}
