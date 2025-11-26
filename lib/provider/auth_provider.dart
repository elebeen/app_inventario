import 'package:flutter/foundation.dart';
import 'package:registro_productos/domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepositoryImpl _authRepository;
  AuthProvider(this._authRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _authRepository.isAuthenticated;
  String? get token => _authRepository.token;
  Map<String, dynamic>? get user => _authRepository.user;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.login(email, password);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _authRepository.logout();
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    await _authRepository.tryAutoLogin();
    notifyListeners();
  }

  void updateRepository(AuthRepositoryImpl repo) {
    // Solo actualiza si es necesario (dependencia hot reload)
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
