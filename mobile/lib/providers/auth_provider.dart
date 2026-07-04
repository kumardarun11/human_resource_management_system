import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // ============================
  // Loading States
  // ============================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isEmailVerified = false;
  bool get isEmailVerified => _isEmailVerified;

  // ============================
  // User Information
  // ============================

  String? _token;
  String? _userId;
  String? _employeeId;
  String? _name;
  String? _email;
  String? _role;

  String? get token => _token;
  String? get userId => _userId;
  String? get employeeId => _employeeId;
  String? get name => _name;
  String? get email => _email;
  String? get role => _role;

  // ============================
  // Loading
  // ============================

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ============================
  // Login
  // ============================

  void login({
    required String token,
    required String userId,
    required String employeeId,
    required String name,
    required String email,
    required String role,
  }) {
    _token = token;
    _userId = userId;
    _employeeId = employeeId;
    _name = name;
    _email = email;
    _role = role;

    _isLoggedIn = true;

    notifyListeners();
  }

  // ============================
  // Email Verification
  // ============================

  void verifyEmail() {
    _isEmailVerified = true;
    notifyListeners();
  }

  // ============================
  // Logout
  // ============================

  void logout() {
    _token = null;
    _userId = null;
    _employeeId = null;
    _name = null;
    _email = null;
    _role = null;

    _isLoggedIn = false;
    _isEmailVerified = false;

    notifyListeners();
  }

  // ============================
  // Update Profile
  // ============================

  void updateProfile({
    required String name,
    required String email,
  }) {
    _name = name;
    _email = email;

    notifyListeners();
  }

  // ============================
  // Check Role
  // ============================

  bool get isAdmin => _role == 'admin';

  bool get isEmployee => _role == 'employee';
}