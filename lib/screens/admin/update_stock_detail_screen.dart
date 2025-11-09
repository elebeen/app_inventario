import 'package:flutter/material.dart';
import '../../data/inventory_data.dart';
import '../../data/sales_history_data.dart';

class UpdateStockDetailScreen extends StatefulWidget {
  final int index;
  const UpdateStockDetailScreen({super.key, required this.index});

  @override
  State<UpdateStockDetailScreen> createState() =>
      _UpdateStockDetailScreenState();
}

class _UpdateStockDetailScreenState extends State<UpdateStockDetailScreen> {
  int quantityToSell = 1;

  void venderProducto() {
    final producto = inventario[widget.index];
    int stockActual = int.tryParse(producto['stock'] ?? '0') ?? 0;

    if (quantityToSell <= 0 || quantityToSell > stockActual) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cantidad inválida')),
      );
      return;
    }

    // Reducir stock
    stockActual -= quantityToSell;
    producto['stock'] = stockActual.toString();

    // Guardar en historial de ventas
    salesHistory.add({
      'codigo': producto['codigo'],
      'nombre': producto['nombre'],
      'cantidad': quantityToSell,
      'fecha': DateTime.now().toString(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Producto "${producto['nombre']}" vendido. Stock restante: $stockActual')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final producto = inventario[widget.index];

    return Scaffold(
      appBar: AppBar(title: const Text('Actualizar Stock')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text('Producto: ${producto['nombre']}',
                style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 16),
            Text('Stock actual: ${producto['stock']}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Cantidad a vender: '),
                Expanded(
                  child: TextFormField(
                    initialValue: '1',
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      quantityToSell = int.tryParse(v) ?? 1;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.remove),
              label: const Text('Vender producto'),
              onPressed: venderProducto,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}
