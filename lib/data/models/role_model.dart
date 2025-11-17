class Role {
  final int id;
  final String nombre;

  Role({required this.id, required this.nombre});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] ?? 0,
      nombre: json['name'] ?? json['nombre'] ?? '',
    );
  }
}

enum Rol {
  admin_tienda_secundario,
  empleado_tienda
}