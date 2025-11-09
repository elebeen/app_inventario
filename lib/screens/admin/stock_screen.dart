import 'package:flutter/material.dart';
import '../../data/inventory_data.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  void eliminarCategoria(String categoria) {
    setState(() {
      // Eliminar productos de esa categoría
      inventario.removeWhere((p) => p['categoria'] == categoria);
      // Eliminar la categoría
      categorias.remove(categoria);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Categoría "$categoria" eliminada')),
    );
  }

  void eliminarProducto(Map<String, dynamic> producto) {
    setState(() {
      inventario.remove(producto);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Producto "${producto['nombre']}" eliminado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock (Admin)')),
      body: ListView.builder(
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          // Filtrar productos de esa categoría
          final productos =
              inventario.where((p) => p['categoria'] == categoria).toList();

          return ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(categoria,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => eliminarCategoria(categoria),
                  tooltip: 'Eliminar categoría',
                ),
              ],
            ),
            children: productos.isEmpty
                ? [const ListTile(title: Text('No hay productos'))]
                : productos.map((producto) {
                    return ListTile(
                      title: Text(producto['nombre']),
                      subtitle: Text(
                          'Precio: ${producto['precio']} | Stock: ${producto['stock']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => eliminarProducto(producto),
                        tooltip: 'Eliminar producto',
                      ),
                    );
                  }).toList(),
          );
        },
      ),
    );
  }
}
