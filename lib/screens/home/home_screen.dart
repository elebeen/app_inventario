import 'package:flutter/material.dart';
import '../admin/select_store_screen.dart'; // <-- nueva pantalla
import '../employee/employee_home_screen.dart';
import '../employee/scan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bienvenido")),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.store, size: 120, color: Colors.indigo),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text("Administrador"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () {
                    // Antes iba directo a AdminScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SelectStoreScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
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
