import 'package:registro_productos/core/dio_client.dart';
import 'package:registro_productos/data/models/user_model.dart';
import 'package:registro_productos/data/models/role_model.dart';

abstract class UserRepository {
  Future<User> register(String email, String password, Rol rol);
  Future<User> editUser(int id, String email, bool active, Rol rol);
  Future<String> deleteUser(int id);
  Future<User> getUser(int id);
  Future<PaginatedUserResponse> getUsers(int page, int size);
}

class UserRepositoryImpl implements UserRepository {
  final ApiService _api;
  UserRepositoryImpl(this._api);

  @override
  Future<User> register(String email, String password, Rol rol) async {
    try {
      final rolString = rol.name;
      final response = await _api.post('/auth/', {
        'email': email,
        'password': password,
        'rolNombre': rolString
      });

      if (response.data == null) {
        throw Exception('No data received from server');
      }

      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
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
  Future<User> getUser(int id) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<PaginatedUserResponse> getUsers(int page, int size) async {
    final response =  await _api.get('/auth',
        params: {
          'page': page,
          'size': size
        }
    );

    return PaginatedUserResponse.fromJson(response.data);
  }
}