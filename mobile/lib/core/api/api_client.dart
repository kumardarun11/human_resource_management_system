import 'package:dio/dio.dart';

import 'dio_client.dart';

class ApiClient {
  ApiClient._();

  static Future<Response> get(
      String url, {
        Map<String, dynamic>? query,
        String? token,
      }) async {
    return DioClient.dio.get(
      url,
      queryParameters: query,
      options: Options(
        headers: {
          if (token != null)
            'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  static Future<Response> post(
      String url, {
        dynamic data,
        String? token,
      }) async {
    return DioClient.dio.post(
      url,
      data: data,
      options: Options(
        headers: {
          if (token != null)
            'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  static Future<Response> put(
      String url, {
        dynamic data,
        String? token,
      }) async {
    return DioClient.dio.put(
      url,
      data: data,
      options: Options(
        headers: {
          if (token != null)
            'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  static Future<Response> delete(
      String url, {
        String? token,
      }) async {
    return DioClient.dio.delete(
      url,
      options: Options(
        headers: {
          if (token != null)
            'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}