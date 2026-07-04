class ApiEndpoints {
  ApiEndpoints._();

  /// Base URL
  /// Android Emulator:
  /// static const String baseUrl = "http://10.0.2.2:8000/api";

  /// Real Device:
  static const String baseUrl = "http://192.168.0.184:8000/api";

  /// Production
  // static const String baseUrl = "http://192.168.1.100:8000/api";

  // ============================
  // Authentication
  // ============================

  static const String register = "/register";
  static const String login = "/login";
  static const String logout = "/logout";

  static const String verifyEmail = "/verify-email";
  static const String resendOtp = "/resend-verification";

  static const String forgotPassword = "/forgot-password";
  static const String resetPassword = "/reset-password";

  static const String profile = "/profile";
  static const String changePassword = "/change-password";
  static const String refreshToken = "/refresh-token";

  // ============================
  // Employee
  // ============================

  static const String attendance = "/attendance";

  static const String leaveRequest = "/leave-request";

  static const String payroll = "/payroll";

  // ============================
  // Admin
  // ============================

  static const String employees = "/employees";

  static const String departments = "/departments";
}