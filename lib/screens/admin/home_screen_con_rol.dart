import 'package:flutter/material.dart';
import '../employee/employee_home_screen.dart';
import 'select_store_screen.dart';
import '../employee/scan_screen.dart';
import '../auth/login_screen.dart';

class HomeScreenConRol extends StatelessWidget {
  final bool esAdmin;
  final String nombreUsuario;

  const HomeScreenConRol({
    super.key,
    required this.esAdmin,
    required this.nombreUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $nombreUsuario'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar sesión",
            onPressed: () {
              // Volver al login y eliminar rutas anteriores
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.store, size: 120, color: Colors.indigo),
                const SizedBox(height: 40),

                // 👇 Solo visible si es admin
                if (esAdmin)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.admin_panel_settings),
                    label: const Text("Administrador"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SelectStoreScreen()),
                      );
                    },
                  ),
                if (esAdmin) const SizedBox(height: 20),

                // 👇 Disponible para todos
                ElevatedButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text("Empleado"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EmployeeHomeScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Escanear Producto"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScanScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
