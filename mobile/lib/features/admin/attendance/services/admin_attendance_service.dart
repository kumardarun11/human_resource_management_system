import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/storage/auth_storage.dart';

class AdminAttendanceService {
  AdminAttendanceService._();

  static Future<Map<String, dynamic>> getAttendanceRecords() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      ApiEndpoints.adminAttendance,
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }
}