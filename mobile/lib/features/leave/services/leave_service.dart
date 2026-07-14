import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/storage/auth_storage.dart';

class LeaveService {
  LeaveService._();

  static Future<Map<String, dynamic>> applyLeave({
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
  }) async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.post(
      ApiEndpoints.leaveRequest,
      token: token,
      data: {
        'leave_type': leaveType,
        'from_date': fromDate,
        'to_date': toDate,
        'reason': reason,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> getLeaves() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      ApiEndpoints.leaveRequest,
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }
}