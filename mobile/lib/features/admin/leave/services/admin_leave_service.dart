import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/storage/auth_storage.dart';

class AdminLeaveService {
  AdminLeaveService._();

  static Future<Map<String, dynamic>> getLeaveRequests() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      ApiEndpoints.leaveRequest,
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> approveLeave(int id) async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.put(
      '${ApiEndpoints.leaveRequest}/approve/$id',
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> rejectLeave(int id) async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.put(
      '${ApiEndpoints.leaveRequest}/reject/$id',
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }
}