import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:registro_productos/provider/auth_provider.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService(AuthProvider authProvider) {
    _dio.options.baseUrl = dotenv.env['BASE_URL']!;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {'Content-Type': 'application/json'};

    // 🔐 Interceptor: agrega token automáticamente
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (authProvider.token != null) {
          options.headers['x-token'] = authProvider.token;
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        // si el token expira o da 401, puedes desloguear
        if (e.response?.statusCode == 401) {
          authProvider.logout();
        }
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    // return await _dio.get(path, queryParameters: params);
    try {
      return await _dio.get(path, queryParameters: params);
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(path: path),
        data: {'error': e.toString()},
        statusCode: 500,
      );
    }
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, Map<String, dynamic> data) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
