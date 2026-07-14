import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/storage/auth_storage.dart';

class DashboardService {
  DashboardService._();

  static Future<Map<String, dynamic>> getEmployeeDashboard() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      ApiEndpoints.employeeDashboard,
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> getAdminDashboard() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      ApiEndpoints.adminDashboard,
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }
}