class ApiEndpoints {
  ApiEndpoints._();

  
  // Base URL
  /// Production
  static const String baseUrl = "https://hrms-backend-z20g.onrender.com/api";
  

  /// Android Emulator
  //static const String baseUrl = "http://10.0.2.2:8000/api";

  /// Real Android Device
  /// PC and phone must be on the same network.
  // static const String baseUrl = "http://192.168.1.7:8000/api";

  /// Production
  // static const String baseUrl = "https://your-domain.com/api";

  
  // Authentication
  

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

  
  // Dashboard
  

  static const String employeeDashboard = "/dashboard/employee";
  static const String adminDashboard = "/dashboard/admin";

  
  // Employee Profile
  

  static const String employeeProfile = "/employee/profile";

  
  // Attendance
  

  static const String attendance = "/attendance";
  static const String adminAttendance = "/attendance";

  
  // Leave Management
  

  static const String leaveRequest = "/leave";

  
  // Payroll
  

  static const String payroll = "/payroll";
  static const String adminPayroll = "/payroll";

  
  // Admin - Employee Management
  

  static const String employees = "/employees";

  
  // Admin - Department Management
  

  static const String departments = "/departments";
}