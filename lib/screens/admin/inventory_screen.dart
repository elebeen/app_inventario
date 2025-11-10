import 'package:flutter/material.dart';
import '../../data/inventory_data.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario')),
      body: ListView.builder(
        itemCount: inventario.length,
        itemBuilder: (context, index) {
          final p = inventario[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(p['nombre'] ?? ''),
              subtitle: Text(
                  'Código: ${p['codigo']} | Stock: ${p['stock']} | Categoria: ${p['categoria']}'),
            ),
          );
        },
      ),
    );
  }
}
