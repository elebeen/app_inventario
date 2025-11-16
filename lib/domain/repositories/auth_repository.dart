import 'dart:convert';
import 'package:registro_productos/core/dio_client.dart';
import 'package:registro_productos/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<User> register(String email, String password);
  Future<void> logout();
  Future<void> tryAutoLogin();
  Future<User> editUser(int id, String email, bool active);
  Future<void> deleteUser(int id);
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
    final response = await _api.post('/auth/login', {'email': email, 'password': password});
    _token = response.data['token'];
    _user = Map<String, dynamic>.from(response.data['usuario']);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setString('usuario', jsonEncode(_user));
    return true;
  }
  
  @override
  Future<User> register(String email, String password) async {
    final response = await _api.post('/auth/', {
      'email': email, 
      'password': password
    });
    return User.fromJson(response.data);
  }
  
  @override
  Future<void> deleteUser(int id) async {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }
  
  @override
  Future<User> editUser(int id, String email, bool active) async {
    // TODO: implement editUser
    throw UnimplementedError();
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
}