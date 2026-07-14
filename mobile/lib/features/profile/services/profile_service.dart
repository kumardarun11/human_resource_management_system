import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/storage/auth_storage.dart';

class ProfileService {
  ProfileService._();

  static Future<Map<String, dynamic>> getProfile() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      ApiEndpoints.employeeProfile,
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }
}