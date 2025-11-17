import 'package:flutter/foundation.dart';
import 'package:registro_productos/data/models/user_model.dart';
import 'package:registro_productos/domain/repositories/auth_repository.dart';
import 'package:registro_productos/data/models/role_model.dart';
import '../domain/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepositoryImpl _userRepository;
  UserProvider(this._userRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _hasMore = true;
  bool get hasMore => _hasMore;
  int _page = 0;
  final int _size = 20;

  final PaginatedUserResponse _usersResponse = PaginatedUserResponse(
    content: [],
    page: 1,
    size: 10,
    totalElements: 0,
    totalPages: 0,
    hasNext: false,
    hasPrevious: false,
  );
  PaginatedUserResponse get userResponse => _usersResponse;

  Future<String> register(String email, String password, Rol rol) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _userRepository.register(email, password, rol);
      return user.email;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return "Error al crear el usuario $email";
  }

  Future<void> fetchUsers() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final resp = await _userRepository.getUsers(_page, _size);

      _usersResponse.content.addAll(resp.content);

      if (resp.content.length < _size) {
        _hasMore = false;
      }

      _page++;
      _errorMessage = null;

    } catch (e) {
      _errorMessage = e.toString() + "provider";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String> edit(int id, String email, bool active, Rol rol) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _userRepository.editUser(id, email, active, rol);
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
      final msg = await _userRepository.deleteUser(id);
      return msg;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return "Error al eliminar el usuario";
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
