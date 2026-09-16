import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth;

  late final StreamSubscription<User?> _authSubscription;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthService({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance {
    _user = _auth.currentUser;
    _authSubscription = _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      _errorMessage = null;

      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      _errorMessage = _getErrorMessage(error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      _errorMessage = null;

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      _errorMessage = _getErrorMessage(error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);

    try {
      _errorMessage = null;
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      _errorMessage = _getErrorMessage(error);
    } finally {
      _setLoading(false);
    }
  }

  String _getErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Invalid email address.';

      case 'weak-password':
        return 'The password is too weak.';

      case 'email-already-in-use':
        return 'An account already exists for this email.';

      case 'user-not-found':
        return 'No account found for this email.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';

      default:
        return error.message ?? 'Authentication failed.';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
