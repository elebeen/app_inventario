import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/components/app_bar.dart';
import 'package:registro_productos/data/models/user_model.dart';
import 'package:registro_productos/provider/auth_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Ajustes',),
      body: FutureBuilder<User?>(
        // Llama a la función para cargar el usuario
        future: auth.loadUserFromPrefs(),
        builder: (context, snapshot) {
          // 1. Manejo del estado de Carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Manejo de Errores o Sin Datos
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los datos: ${snapshot.error}'));
          }
          
          final user = snapshot.data;
          
          if (user == null) {
            return const Center(
              child: Text(
                'No hay sesión iniciada o datos de usuario.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // 3. Mostrar los Datos del Usuario
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.person, color: Colors.blueAccent),
                title: Text('Información del Usuario', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('ID'),
                subtitle: Text('${user.id}'),
              ),
              ListTile(
                title: const Text('Email'),
                subtitle: Text(user.email),
              ),
              ListTile(
                title: const Text('ID de Tienda'),
                subtitle: Text('${user.tiendaId}'),
              ),
              ListTile(
                title: const Text('Estado (Activo)'),
                subtitle: Text(user.activo ? 'Sí' : 'No'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.security, color: Colors.orange),
                title: const Text('Roles Asignados', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.roles.map((r) => r.nombre).join(', ')), // Asumiendo que Role tiene una propiedad 'name'
              ),
              // Puedes mostrar el hash de la contraseña (solo por referencia), 
              // pero no es recomendable en una vista de usuario final.
              /*
              ListTile(
                title: const Text('Password Hash'),
                subtitle: Text(user.passwordHash),
              ),
              */
            ],
          );
        },
      ),
    );
  }
}