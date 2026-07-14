import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/storage/auth_storage.dart';

class AttendanceService {
  AttendanceService._();

  static Future<Map<String, dynamic>> getAttendance() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      ApiEndpoints.attendance,
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> checkIn() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.post(
      '${ApiEndpoints.attendance}/check-in',
      token: token,
      data: {
        'check_in_location': 'Mobile App',
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> checkOut() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.post(
      '${ApiEndpoints.attendance}/check-out',
      token: token,
      data: {
        'check_out_location': 'Mobile App',
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> getHistory() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      '${ApiEndpoints.attendance}/history',
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }
}