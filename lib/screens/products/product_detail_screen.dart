import 'package:flutter/material.dart';
import '../../components/app_bar.dart';
import '../../data/models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: product.nombre),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Código: ${product.codigoBarras}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Nombre: ${product.nombre}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('Precio: \$${product.precio}'),
            SizedBox(height: 8),
            Text('Stock: ${product.stock}'),
            SizedBox(height: 8),
            Text('Categoría: ${product.categoria}'),
            SizedBox(height: 12),
            Text('Descripción:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            //Text(producto['descripcion'] ?? ''),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Eliminar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
