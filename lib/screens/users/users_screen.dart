import 'package:flutter/material.dart';
import '../../data/users_data.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios (Admin)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateUserScreen()),
              ),
              child: const Text('Crear Usuario'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ViewUsersScreen()),
              ),
              child: const Text('Ver Usuarios'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserHistoryScreen()),
              ),
              child: const Text('Historial Usuarios'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------- Crear Usuario ----------------------
class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _rolCtrl = TextEditingController();

  void guardarUsuario() {
    if (_formKey.currentState?.validate() ?? false) {
      final nuevoUsuario = {
        'nombre': _nombreCtrl.text,
        'rol': _rolCtrl.text,
        'fecha': DateTime.now().toString(),
      };
      usuarios.add(nuevoUsuario);

      // Guardar en historial
      historialUsuarios.add({
        'accion': 'Usuario creado',
        'usuario': _nombreCtrl.text,
        'fecha': DateTime.now().toString(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario creado exitosamente')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Ingrese nombre' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _rolCtrl,
                decoration: const InputDecoration(labelText: 'Rol'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Ingrese rol' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: guardarUsuario,
                child: const Text('Guardar Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------- Ver Usuarios ----------------------
class ViewUsersScreen extends StatelessWidget {
  const ViewUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios Registrados')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: usuarios.isEmpty
            ? const Center(child: Text('No hay usuarios registrados.'))
            : ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final u = usuarios[index];
                  return Card(
                    child: ListTile(
                      title: Text(u['nombre']),
                      subtitle: Text('Rol: ${u['rol']}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// ---------------------- Historial Usuarios ----------------------
class UserHistoryScreen extends StatelessWidget {
  const UserHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Usuarios')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: historialUsuarios.isEmpty
            ? const Center(child: Text('No hay historial registrado.'))
            : ListView.builder(
                itemCount: historialUsuarios.length,
                itemBuilder: (context, index) {
                  final h = historialUsuarios[index];
                  return Card(
                    child: ListTile(
                      title: Text(h['accion']),
                      subtitle: Text(
                          'Usuario: ${h['usuario']}\nFecha: ${h['fecha']}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
