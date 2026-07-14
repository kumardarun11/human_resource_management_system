import 'package:flutter/material.dart';

import 'package:mobile/app/route_names.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/otp_verification_screen.dart';
import '../features/dashboard/employee_dashboard_screen.dart';
import '../features/dashboard/admin_dashboard_screen.dart';
import '../features/profile/employee_profile_screen.dart';
import '../features/attendance/attendance_screen.dart';
import '../features/leave/apply_leave_screen.dart';
import '../features/leave/leave_history_screen.dart';
import '../features/payroll/payroll_screen.dart';
import '../features/payroll/payslip_screen.dart';
import '../features/admin/employees/employee_list_screen.dart';
import '../features/admin/employees/employee_form_screen.dart';
import '../features/admin/departments/department_screen.dart';
import '../features/admin/leave/leave_request_screen.dart';
import '../features/admin/attendance/admin_attendance_screen.dart';
import '../features/admin/payroll/admin_payroll_screen.dart';


class AppRoutes {
  AppRoutes._();

  static const String splash = RouteNames.splash;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

    // Splash
      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

    // Register
      case RouteNames.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );

    // Login
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

    /*// =========================
    // Onboarding
    // =========================
      case RouteNames.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );


    // OTP Verification
      case RouteNames.otpVerification:
        return MaterialPageRoute(
          builder: (_) => const OtpVerificationScreen(),
        );*/
      case RouteNames.otpVerification:
        final args = settings.arguments as Map<String, dynamic>;
      
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            userId: args['user_id'] as int,
            email: args['email'] as String,
          ),
        );

    // Employee Dashboard
    case RouteNames.employeeDashboard:
      return MaterialPageRoute(
        builder: (_) => const EmployeeDashboardScreen(),
      );
    
    // Admin Dashboard
    case RouteNames.adminDashboard:
      return MaterialPageRoute(
        builder: (_) => const AdminDashboardScreen(),
      );

    // Employee Profile
    case RouteNames.employeeProfile:
      return MaterialPageRoute(
        builder: (_) => const EmployeeProfileScreen(),
      );

    // Attendance
    case RouteNames.attendance:
      return MaterialPageRoute(
        builder: (_) => const AttendanceScreen(),
      );

    // Leave
    case RouteNames.applyLeave:
      return MaterialPageRoute(
        builder: (_) => const ApplyLeaveScreen(),
      );

    case RouteNames.leaveHistory:
      return MaterialPageRoute(
        builder: (_) => const LeaveHistoryScreen(),
      );
    
    // Payroll
    case RouteNames.payroll:
      return MaterialPageRoute(
        builder: (_) => const PayrollScreen(),
      );

    case RouteNames.payslip:
      final payrollId = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => PayslipScreen(
          payrollId: payrollId,
        ),
      );
    case RouteNames.employees:
      return MaterialPageRoute(
        builder: (_) => const EmployeeListScreen(),
      );

    case RouteNames.addEmployee:
      return MaterialPageRoute(
        builder: (_) => const EmployeeFormScreen(),
      );

    case RouteNames.editEmployee:
      final employeeId = settings.arguments as int;

      return MaterialPageRoute(
        builder: (_) => EmployeeFormScreen(
          employeeId: employeeId,
        ),
      );

    case RouteNames.departments:
      return MaterialPageRoute(
        builder: (_) => const DepartmentScreen(),
      );

    case RouteNames.leaveRequests:
      return MaterialPageRoute(
        builder: (_) => const LeaveRequestScreen(),
      );
    case RouteNames.adminAttendance:
      return MaterialPageRoute(
        builder: (_) => const AdminAttendanceScreen(),
      );
    
    case RouteNames.adminPayroll:
      return MaterialPageRoute(
        builder: (_) => const AdminPayrollScreen(),
      );
    // Default
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Page Not Found'),
            ),
            body: const Center(
              child: Text(
                '404\nPage Not Found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
    }
  }
}
