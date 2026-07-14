import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';

class AuthService {
    static Future<Map<String, dynamic>> login({
      required String email,
      required String password,
    }) async {
      final response = await ApiClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );
    
      return Map<String, dynamic>.from(response.data);
    }
  AuthService._();

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
      data: {
        'user_id': userId,
        'otp': otp,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }
}