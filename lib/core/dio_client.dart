import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio _dio = Dio();
  final String? Function() getToken;

  ApiService(this.getToken) {
    _dio.options.baseUrl = dotenv.env['BASE_URL']!;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = getToken();
          if (token != null) {
            options.headers['x-token'] = token;
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    return await _dio.get(path, queryParameters: params);
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, Map<String, dynamic> data) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> patch(String path, Map<String, dynamic> data) async {
    return await _dio.patch(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
