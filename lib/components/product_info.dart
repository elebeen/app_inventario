import 'package:flutter/material.dart';
import 'package:registro_productos/data/models/product_model.dart';

class ProductInfo extends StatelessWidget {
  final Product product;

  const ProductInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Código: ${product.codigoBarras}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        Text(
          'Nombre: ${product.nombre}',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),

        Text('Precio: \$${product.precio.toString()}'),
        const SizedBox(height: 8),

        Text('Stock: ${product.stock}'),
        const SizedBox(height: 8),

        Text('Categoría: ${product.categoria?.nombre}'),
        const SizedBox(height: 12),

        const Text(
          'Descripción:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        // Aquí puedes agregar product.descripcion cuando exista
      ],
    );
  }
}