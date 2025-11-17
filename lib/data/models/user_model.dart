import 'package:registro_productos/data/models/role_model.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final Role roles;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      roles: (json['roles'] as List<dynamic>)
          .map((role) => Role.fromJson(role))
          .toList()[0],
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
      content: (json['content'] as List)
          .map((item) => User.fromJson(item))
          .toList(),
      page: json['page'],
      size: json['size'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      hasNext: json['hasNext'],
      hasPrevious: json['hasPrevious']
    );
  }
}