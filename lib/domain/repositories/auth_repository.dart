import 'package:dio/dio.dart';
import 'package:registro_productos/data/models/user_model.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);
  
  @override
  Future<User> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    return User.fromJson(response.data);
  }
}