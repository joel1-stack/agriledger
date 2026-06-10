import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../../services/notification_service.dart';

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
  String get userRole => _userModel?.role ?? 'general';
  bool get isSuperAdmin => _userModel?.isSuperAdmin ?? false;
  bool get isViewAdmin => _userModel?.isViewAdmin ?? false;
  bool get isGeneralUser => _userModel?.isGeneralUser ?? false;
  bool get isManager => isViewAdmin || isSuperAdmin;
  bool get canAddEdit => _userModel?.canAddEdit ?? false;
  bool get canApprove => _userModel?.canApprove ?? false;
  bool get canDelete => _userModel?.canDelete ?? false;

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
      final userData = await _authRepo.getUserData(uid);
      if (userData != null) {
        _userModel = userData;
        _status = AuthStatus.authenticated;
        final token = await NotificationService().getToken();
        if (token != null) {
          await _authRepo.updateFcmToken(uid, token);
        }
      } else {
        _error = 'User data not found';
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _error = 'Failed to load user data';
      _status = AuthStatus.unauthenticated;
      debugPrint('AuthProvider._loadUserData error: $e');
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true; _error = null; notifyListeners();
    try {
      await _authRepo.signInWithEmailAndPassword(email, password);
      if (_firebaseUser != null) {
        await _loadUserData(_firebaseUser!.uid);
      }
      _isLoading = false; notifyListeners();
      return _userModel != null;
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
      final cred = await _authRepo.createUserWithEmailAndPassword(email, password, name, role: role);
      _userModel = UserModel(
        id: cred.user!.uid,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );
      _status = AuthStatus.authenticated;
      _firebaseUser = cred.user;
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
