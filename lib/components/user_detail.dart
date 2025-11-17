import 'package:flutter/material.dart';
import 'package:registro_productos/data/models/user_model.dart';

class UserInfo extends StatelessWidget {
  final User user;

  const UserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Código: ${user.email}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        Text(
          'Activo: ${user.activo}',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),

        Text('Rol: \$${user.roles[0].nombre}'),
        const SizedBox(height: 8),
      ],
    );
  }
}
