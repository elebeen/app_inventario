import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/provider/auth_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final name = (user?['email'] ?? '').toString().split('@')[0];
    final email = user?['email'] ?? '';
    final rol = user?['roles'][0] ?? '';
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mi perfil'),
          ),
          Text(name),
          const Divider(),
          Text(email),
          const Divider(),
          Text(rol),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {
              auth.logout();
            },
          ),
        ],
      ),
    );
  }
}