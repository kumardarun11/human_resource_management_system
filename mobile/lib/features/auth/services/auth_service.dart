import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/storage/auth_storage.dart';

class AuthService {
  AuthService._();

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> register({
    required String employeeId,
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await ApiClient.post(
      ApiEndpoints.register,
      data: {
        'employee_id': employeeId,
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'role': role,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> verifyEmail({
    required int userId,
    required String otp,
  }) async {
    final response = await ApiClient.post(
      ApiEndpoints.verifyEmail,
      data: {'user_id': userId, 'otp': otp},
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final response = await ApiClient.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String email,
    required String password,
  }) async {
    final response = await ApiClient.post(
      ApiEndpoints.resetPassword,
      data: {
        'token': token,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.post(
      ApiEndpoints.changePassword,
      token: token,
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(ApiEndpoints.profile, token: token);

    return Map<String, dynamic>.from(response.data);
  }

  static Future<void> logout() async {
    final token = await AuthStorage.getToken();

    try {
      if (token != null && token.isNotEmpty) {
        await ApiClient.post(ApiEndpoints.logout, token: token);
      }
    } finally {
      await AuthStorage.clear();
    }
  }
}
