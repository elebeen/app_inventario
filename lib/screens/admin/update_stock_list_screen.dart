import 'package:flutter/material.dart';
import 'update_stock_detail_screen.dart';
import '../../data/inventory_data.dart';

class UpdateStockListScreen extends StatelessWidget {
  const UpdateStockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actualizar Stock')),
      body: ListView.builder(
        itemCount: inventario.length,
        itemBuilder: (context, index) {
          final p = inventario[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(p['nombre'] ?? ''),
              subtitle: Text('Stock actual: ${p['stock']}'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateStockDetailScreen(index: index),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
