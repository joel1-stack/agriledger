import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String role; // 'general', 'viewAdmin', 'superAdmin'
  final DateTime createdAt;
  final String? farmUnit;
  final String? phone;
  final String? photoUrl;

  UserModel({required this.id, required this.email, required this.name, required this.role, required this.createdAt, this.farmUnit, this.phone, this.photoUrl});

  bool get isSuperAdmin => role == 'superAdmin';
  bool get isViewAdmin => role == 'viewAdmin';
  bool get isGeneralUser => role == 'general';
  bool get isAdmin => isSuperAdmin || isViewAdmin;
  bool get isViewer => isViewAdmin || isSuperAdmin;

  Map<String, dynamic> toFirestore() => {
    'email': email, 'name': name, 'role': role, 'createdAt': Timestamp.fromDate(createdAt),
    'farmUnit': farmUnit, 'phone': phone, 'photoUrl': photoUrl,
  };

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      id: doc.id, email: m['email'] ?? '', name: m['name'] ?? '', role: m['role'] ?? 'general',
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      farmUnit: m['farmUnit'], phone: m['phone'], photoUrl: m['photoUrl'],
    );
  }

  UserModel copyWith({String? name, String? role, String? farmUnit, String? phone, String? photoUrl}) =>
    UserModel(id: id, email: email, name: name ?? this.name, role: role ?? this.role, createdAt: createdAt,
      farmUnit: farmUnit ?? this.farmUnit, phone: phone ?? this.phone, photoUrl: photoUrl ?? this.photoUrl);
}
