import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/storage/auth_storage.dart';

class DepartmentService {
  DepartmentService._();

  static Future<Map<String, dynamic>> getDepartments() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      ApiEndpoints.departments,
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> createDepartment({
    required String departmentCode,
    required String departmentName,
    String? email,
    String? phone,
    String? description,
    required String status,
  }) async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.post(
      ApiEndpoints.departments,
      token: token,
      data: {
        'department_code': departmentCode,
        'department_name': departmentName,
        'email': email,
        'phone': phone,
        'description': description,
        'status': status,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> deleteDepartment(int id) async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.delete(
      '${ApiEndpoints.departments}/$id',
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }
}