import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthController() {
    // Default logged in demo admin user for immediate seamless evaluation
    _currentUser = UserModel(
      id: 'admin_01',
      name: 'Super Admin (B1 Operations)',
      email: 'admin@b1customs.com',
      role: 'Master Admin',
      token: 'jwt_token_b1_admin_secure_key_9921',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    );
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));

    if (email.trim().toLowerCase() == 'admin@b1customs.com' && password == 'admin123') {
      _currentUser = UserModel(
        id: 'admin_01',
        name: 'Super Admin (B1 Operations)',
        email: email.trim(),
        role: 'Master Admin',
        token: 'jwt_token_b1_admin_secure_key_9921',
        createdAt: DateTime.now(),
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } else if (email.contains('@') && password.length >= 6) {
      // Mock login for valid credentials
      _currentUser = UserModel(
        id: 'admin_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@')[0].toUpperCase(),
        email: email.trim(),
        role: 'Staff Admin',
        token: 'jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid admin credentials. Use admin@b1customs.com / admin123';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));

    if (name.isEmpty || !email.contains('@') || password.length < 6) {
      _errorMessage = 'Please provide a valid name, email and password (min 6 chars)';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _currentUser = UserModel(
      id: 'admin_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: email.trim(),
      role: 'Staff Admin',
      token: 'jwt_token_registered_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
