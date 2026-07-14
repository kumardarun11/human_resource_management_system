import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/storage/auth_storage.dart';

class EmployeeService {
  EmployeeService._();

  static Future<Map<String, dynamic>> getEmployees() async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      ApiEndpoints.employees,
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> getEmployee(int id) async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.get(
      '${ApiEndpoints.employees}/$id',
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> createEmployee({
    required String employeeId,
    required String name,
    required String email,
    required String password,
    String? phone,
    int? departmentId,
    String? designation,
  }) async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.post(
      ApiEndpoints.employees,
      token: token,
      data: {
        'employee_id': employeeId,
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'department_id': departmentId,
        'designation': designation,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> updateEmployee({
    required int id,
    required String employeeId,
    required String name,
    required String email,
    String? phone,
    int? departmentId,
    String? designation,
  }) async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.put(
      '${ApiEndpoints.employees}/$id',
      token: token,
      data: {
        'employee_id': employeeId,
        'name': name,
        'email': email,
        'phone': phone,
        'department_id': departmentId,
        'designation': designation,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<Map<String, dynamic>> deleteEmployee(int id) async {
    final token = await AuthStorage.getToken();

    final response = await ApiClient.delete(
      '${ApiEndpoints.employees}/$id',
      token: token,
    );

    return Map<String, dynamic>.from(response.data);
  }
}