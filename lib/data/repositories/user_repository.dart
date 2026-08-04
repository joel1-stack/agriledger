import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<UserModel>> getUsers() {
    return _db.collection('users').snapshots().map((snap) =>
        snap.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }

  Future<void> updateUserRole(String userId, String role) async {
    await _db.collection('users').doc(userId).update({'role': role});
  }

  Future<void> deleteUser(String userId) async {
    await _db.collection('users').doc(userId).delete();
  }
}
