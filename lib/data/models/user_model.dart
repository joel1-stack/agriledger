import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final List<String> assignedUnits;
  final List<String> moduleAccess;
  final bool isActive;
  final String? phone;
  final String? fcmToken;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.assignedUnits = const [],
    this.moduleAccess = const [],
    this.isActive = true,
    this.phone,
    this.fcmToken,
    required this.createdAt,
  });

  bool get isSuperAdmin => role == 'superAdmin';
  bool get isViewAdmin => role == 'viewAdmin';
  bool get isGeneralUser => role == 'general';
  bool get isManager => isViewAdmin || isSuperAdmin;
  bool get canAddEdit => isSuperAdmin || isViewAdmin || isGeneralUser;
  bool get canApprove => isViewAdmin || isSuperAdmin;
  bool get canManageUsers => isSuperAdmin;
  bool get canDelete => isSuperAdmin;

  Map<String, dynamic> toFirestore() => {
    'email': email,
    'name': name,
    'role': role,
    'assignedUnits': assignedUnits,
    'moduleAccess': moduleAccess,
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
      role: m['role'] ?? 'general',
      assignedUnits: List<String>.from(m['assignedUnits'] ?? []),
      moduleAccess: List<String>.from(m['moduleAccess'] ?? []),
      isActive: m['isActive'] ?? true,
      phone: m['phone'],
      fcmToken: m['fcmToken'],
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  UserModel copyWith({
    String? name,
    String? role,
    List<String>? assignedUnits,
    List<String>? moduleAccess,
    bool? isActive,
    String? phone,
    String? fcmToken,
  }) =>
      UserModel(
        id: id,
        email: email,
        name: name ?? this.name,
        role: role ?? this.role,
        assignedUnits: assignedUnits ?? this.assignedUnits,
        moduleAccess: moduleAccess ?? this.moduleAccess,
        isActive: isActive ?? this.isActive,
        phone: phone ?? this.phone,
        fcmToken: fcmToken ?? this.fcmToken,
        createdAt: createdAt,
      );
}
