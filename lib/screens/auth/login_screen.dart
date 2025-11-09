import 'package:flutter/material.dart';
import '../home/home_screen_con_rol.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inicio de Sesión")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 100, color: Colors.indigo),
              const SizedBox(height: 30),
              TextField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de usuario',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              // Botón de empleado
              ElevatedButton(
                onPressed: () {
                  final nombre = _userController.text.isEmpty
                      ? "Empleado"
                      : _userController.text;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreenConRol(
                        esAdmin: false,
                        nombreUsuario: nombre,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
                child: const Text("Iniciar sesión"),
              ),
              const SizedBox(height: 20),

              // Botón de administrador
              ElevatedButton(
                onPressed: () {
                  final nombre = _userController.text.isEmpty
                      ? "Administrador"
                      : _userController.text;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreenConRol(
                        esAdmin: true,
                        nombreUsuario: nombre,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.orange,
                ),
                child: const Text("Iniciar sesión como administrador"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
