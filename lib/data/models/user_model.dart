import 'package:registro_productos/data/models/role_model.dart';

class User {
  final int id;
  final String email;
  final String passwordHash;
  final bool activo;
  final int tiendaId;
  final List<Role> roles;

  User({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.activo,
    required this.tiendaId,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      passwordHash: json['password_hash'] ?? '',
      activo: json['activo'] ?? false,
      tiendaId: json['tiendaId'] ?? 0,
      roles: json['roles'] != null
          ? (json['roles'] as List)
              .map((item) => Role.fromJson(item))
              .toList()
          : [],
    );
  }
}

class PaginatedUserResponse{
  final List<User> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  PaginatedUserResponse({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginatedUserResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedUserResponse(
      content: json['content'] != null
          ? (json['content'] as List)
              .map((item) => User.fromJson(item))
              .toList()
          : [],
      page: json['page'] ?? 0,
      size: json['size'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrevious: json['hasPrevious'] ?? false
    );
  }
}