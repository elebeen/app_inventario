import 'package:flutter/material.dart';
import '../../data/inventory_data.dart';
import 'inventory_screen.dart';

class UpdateStockScreen extends StatelessWidget {
  final int index;

  const UpdateStockScreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final producto = inventario[index];

    return Scaffold(
      appBar: AppBar(title: const Text('Producto Reconocido')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // centra verticalmente
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Producto Reconocido',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Código: ${producto['codigo']}'),
                  const SizedBox(height: 8),
                  Text('Nombre: ${producto['nombre']}'),
                  const SizedBox(height: 8),
                  Text('Precio: ${producto['precio']}'),
                  const SizedBox(height: 8),
                  Text('Stock actual: ${producto['stock']}'),
                  const SizedBox(height: 8),
                  Text('Categoría: ${producto['categoria']}'),
                  const SizedBox(height: 8),
                  Text('Descripción: ${producto['descripcion']}'),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                      onPressed: () {
                        // Incrementamos el stock
                        int stockActual =
                            int.tryParse(producto['stock'] ?? '0') ?? 0;
                        stockActual++;
                        producto['stock'] = stockActual.toString();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Producto "${producto['nombre']}" agregado. Stock: ${producto['stock']}'),
                          ),
                        );

                        // Volvemos a la pantalla de inventario
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const InventoryScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(180, 50),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
