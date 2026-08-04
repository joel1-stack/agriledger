import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepo = UserRepository();

  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _error;

  StreamSubscription<List<UserModel>>? _usersSubscription;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadUsers() {
    _usersSubscription?.cancel();
    _usersSubscription = _userRepo.getUsers().listen(
      (users) {
        _users = users;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  Future<bool> updateUserRole(String userId, String role) async {
    try {
      await _userRepo.updateUserRole(userId, role);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      await _userRepo.deleteUser(userId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _usersSubscription?.cancel();
    super.dispose();
  }
}
