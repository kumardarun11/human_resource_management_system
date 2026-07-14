import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/storage/auth_storage.dart';

class PayrollService {
  PayrollService._();

  static Future<Map<String, dynamic>> getPayroll() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      ApiEndpoints.payroll,
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> getPayrollById(int id) async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      '${ApiEndpoints.payroll}/$id',
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }
}