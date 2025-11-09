import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _user;

  bool get isAuthenticated => _token != null;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;

  final String _baseUrl = dotenv.env['BASE_URL']!;

  Future<bool> login(String email, String password) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        '$_baseUrl/auth/login',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      _token = response.data['token'];
      _user = response.data['usuario'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);

      notifyListeners();
      return true;
    } on DioException catch (e) {
      debugPrint('Login error: ${e.response?.data}');
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return;
    _token = prefs.getString('token');
    notifyListeners();
  }
}
