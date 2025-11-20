import 'dart:convert';
import 'package:registro_productos/core/dio_client.dart';
import 'package:registro_productos/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<void> logout();
  Future<bool> tryAutoLogin();
  Future<bool> validateToken();
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
  Future<void> logout() async {
    _token = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('usuario');

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (route) => false // Predicado 'false' elimina todo el historial
    );
  }
  
  @override
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return false;

    try {
      final response = validateToken();
      if (await response == true) {
        _token = prefs.getString('token');
        if (prefs.containsKey('usuario')) {
          _user = jsonDecode(prefs.getString('usuario')!);
        }
        return true;
      }
    } catch (e) {
      await logout();
      return false;
    }
    return false;
  }

  @override
  Future<bool> validateToken() async {
    try {
      final response = await _api.get('/auth/refresh-token');
      if (response.statusCode == 200) {
        print(response.statusCode);
        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}