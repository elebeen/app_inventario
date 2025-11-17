import 'dart:convert';
import 'package:registro_productos/core/dio_client.dart';
import 'package:registro_productos/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:registro_productos/data/models/role_model.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<User> register(String email, String password, Rol rol);
  Future<void> logout();
  Future<void> tryAutoLogin();
  Future<User> editUser(int id, String email, bool active, Rol rol);
  Future<String> deleteUser(int id);
  Future<User> getUser(int id);
  Future<PaginatedUserResponse> getUsers(int page, int size);
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _api;
  AuthRepositoryImpl(this._api);

  String? _token;
  Map<String, dynamic>? _user;

  bool get isAuthenticated => _token != null;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  
  @override
  Future<bool> login(String email, String password) async {
    final response = await _api.post('/auth/login', {
      'email': email,
      'password': password
    });

    _token = response.data['token'];
    _user = Map<String, dynamic>.from(response.data['usuario']);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setString('usuario', jsonEncode(_user));

    return true;
  }
  
  @override
  Future<User> register(String email, String password, Rol rol) async {
    final rolString = rol.name;
    final response = await _api.post('/auth/', {
      'email': email, 
      'password': password,
      'rolNombre': rolString
    });

    return User.fromJson(response.data);
  }
  
  @override
  Future<String> deleteUser(int id) async {
    final response = await _api.delete('/auth/$id');

    return response.data['msg'];
  }
  
  @override
  Future<User> editUser(int id, String email, bool active, Rol rol) async {
    final rolString = rol.name;
    final response = await _api.put('/auth/$id', {
      'email': email,
      'active': active,
      'rol': rolString
    });

    return User.fromJson(response.data);
  }
  
  @override
  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('usuario');
  }
  
  @override
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return;

    _token = prefs.getString('token');
    if (prefs.containsKey('usuario')) {
      _user = jsonDecode(prefs.getString('usuario')!);
    }
  }

  @override
  Future<User> getUser(int id) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<PaginatedUserResponse> getUsers(int page, int size) async {
    final response =  await _api.get('/auth/',
      params: {
        'page': page,
        'size': size
      }
    );

    return PaginatedUserResponse.fromJson(response.data);
  }
}