import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/storage/auth_storage.dart';

class AdminPayrollService {
  AdminPayrollService._();

  static Future<Map<String, dynamic>> getPayrollRecords() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      ApiEndpoints.adminPayroll,
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> getPayrollById(int id) async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      '${ApiEndpoints.adminPayroll}/$id',
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> getEmployees() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(ApiEndpoints.employees, token: token);

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> createPayroll({
    required int userId,
    required String payrollMonth,
    required int payrollYear,
    required double basicSalary,
    double houseAllowance = 0,
    double medicalAllowance = 0,
    double transportAllowance = 0,
    double bonus = 0,
    double overtime = 0,
    double tax = 0,
    double providentFund = 0,
    double otherDeductions = 0,
    required String paymentStatus,
    String? paymentDate,
    String? paymentMethod,
    String? remarks,
  }) async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.post(
      ApiEndpoints.adminPayroll,
      token: token,
      data: {
        'user_id': userId,
        'payroll_month': payrollMonth,
        'payroll_year': payrollYear,
        'basic_salary': basicSalary,
        'house_allowance': houseAllowance,
        'medical_allowance': medicalAllowance,
        'transport_allowance': transportAllowance,
        'bonus': bonus,
        'overtime': overtime,
        'tax': tax,
        'provident_fund': providentFund,
        'other_deductions': otherDeductions,
        'payment_status': paymentStatus,
        if (paymentDate != null) 'payment_date': paymentDate,
        if (paymentMethod != null) 'payment_method': paymentMethod,
        if (remarks != null) 'remarks': remarks,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }
}
