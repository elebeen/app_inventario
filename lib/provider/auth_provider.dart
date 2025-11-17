import 'package:flutter/foundation.dart';
import 'package:registro_productos/domain/repositories/auth_repository.dart';
import 'package:registro_productos/data/roles.dart';

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

  Future<String> register(String email, String password, Rol rol) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.register(email, password, rol);
      return user.email;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return "Error al crear el usuario $email";
  }

  Future<String> edit(int id, String email, bool active, Rol rol) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.editUser(id, email, active, rol);
      return user.email;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return "Error al editar el usuario $email";
  }

  Future<String> delete(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final msg = await _authRepository.deleteUser(id);
      return msg;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return "Error al eliminar el usuario";
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
}
