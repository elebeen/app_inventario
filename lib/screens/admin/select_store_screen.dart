import 'package:flutter/material.dart';
import '../../data/stores_data.dart';
import 'admin_screen.dart';

class SelectStoreScreen extends StatefulWidget {
  const SelectStoreScreen({super.key});

  @override
  State<SelectStoreScreen> createState() => _SelectStoreScreenState();
}

class _SelectStoreScreenState extends State<SelectStoreScreen> {
  final TextEditingController _nombreCtrl = TextEditingController();

  // Crear nueva tienda
  void crearTienda() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Crear Tienda'),
        content: TextField(
          controller: _nombreCtrl,
          decoration: const InputDecoration(labelText: 'Nombre de la tienda'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nombreCtrl.text.trim().isNotEmpty) {
                tiendas.add({
                  'nombre': _nombreCtrl.text.trim(),
                });
                Navigator.pop(context);
                setState(() {}); // Refresca la lista
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  // Seleccionar tienda
  void seleccionarTienda(Map<String, dynamic> tienda) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ya estás en tu tienda: ${tienda['nombre']}')),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar Tienda (Admin)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: crearTienda,
              child: const Text('Crear Tienda'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: tiendas.isEmpty
                  ? const Center(child: Text('No hay tiendas disponibles.'))
                  : ListView.builder(
                      itemCount: tiendas.length,
                      itemBuilder: (context, index) {
                        final tienda = tiendas[index];
                        return Card(
                          child: ListTile(
                            title: Text(tienda['nombre']),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () => seleccionarTienda(tienda),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
