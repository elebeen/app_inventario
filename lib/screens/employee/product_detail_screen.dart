import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String codigo;
  // En una app real obtendrías aquí el producto desde la nube por el código
  const ProductDetailScreen({Key? key, required this.codigo}) : super(key: key);

  // Simulamos un producto retornado
  Map<String, String> fakeProducto(String codigo) {
    return {
      'codigo': codigo,
      'nombre': 'Producto de ejemplo',
      'precio': '12.50',
      'descripcion': 'Descripción breve del producto.',
      'stock': '20',
      'categoria': 'General',
    };
  }

  @override
  Widget build(BuildContext context) {
    final producto = fakeProducto(codigo);

    return Scaffold(
      appBar: AppBar(title: Text('Detalle producto')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Código: ${producto['codigo']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Nombre: ${producto['nombre']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('Precio: \$${producto['precio']}'),
            SizedBox(height: 8),
            Text('Stock: ${producto['stock']}'),
            SizedBox(height: 8),
            Text('Categoría: ${producto['categoria']}'),
            SizedBox(height: 12),
            Text('Descripción:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(producto['descripcion'] ?? ''),
            Spacer(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Editar: podrías navegar a la pantalla de edición
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Editar pendiente')));
                  },
                  child: Text('Editar'),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // Acción de borrar o similar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Eliminar pendiente')),
                    );
                  },
                  child: Text('Eliminar'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
