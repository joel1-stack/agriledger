import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();

  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;
  AuthStatus _status = AuthStatus.unknown;

  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  String get userId => _firebaseUser?.uid ?? '';
  String get userEmail => _firebaseUser?.email ?? '';
  String get displayName => _userModel?.name ?? _firebaseUser?.displayName ?? 'User';
  String get userRole => _userModel?.role ?? 'worker';
  bool get isSuperAdmin => _userModel?.isSuperAdmin ?? false;
  bool get isManager => _userModel?.isManager ?? false;
  bool get isWorker => _userModel?.isWorker ?? false;
  bool get canAddEdit => _userModel?.canAddEdit ?? false;
  bool get canApprove => _userModel?.canApprove ?? false;
  AuthProvider() {
    _authRepo.authStateChanges.listen((user) async {
      _firebaseUser = user;
      if (user != null) {
        _status = AuthStatus.authenticated;
        await _loadUserData(user.uid);
      } else {
        _status = AuthStatus.unauthenticated;
        _userModel = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      _userModel = await _authRepo.getUserData(uid);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true; _error = null; notifyListeners();
    try {
      await _authRepo.signInWithEmailAndPassword(email, password);
      _isLoading = false; notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _handleAuthError(e);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false; notifyListeners();
    return false;
  }

  Future<bool> signUp(String email, String password, String name, {String role = 'general'}) async {
    _isLoading = true; _error = null; notifyListeners();
    try {
      await _authRepo.createUserWithEmailAndPassword(email, password, name, role: role);
      _isLoading = false; notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _handleAuthError(e);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false; notifyListeners();
    return false;
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
    _firebaseUser = null;
    _userModel = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() { _error = null; notifyListeners(); }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found': return 'No user found with this email';
      case 'wrong-password': return 'Incorrect password';
      case 'invalid-credential': return 'Invalid email or password';
      case 'email-already-in-use': return 'An account already exists with this email';
      case 'weak-password': return 'Password should be at least 6 characters';
      case 'invalid-email': return 'Please enter a valid email address';
      default: return e.message ?? 'An error occurred';
    }
  }
}
