import 'package:dio/src/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/data/models/product_model.dart';
import 'package:registro_productos/domain/repositories/product_repository.dart';
import 'package:registro_productos/core/dio_client.dart';
import 'package:registro_productos/core/service.dart';
import 'package:registro_productos/provider/auth_provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductRepositoryImpl _products = ProductRepositoryImpl(getIt<ApiService>() as Dio);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder<List<Product>>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data!;
          return ProductList(products);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Inventario')),
//       body: ListView.builder(
//         itemCount: inventario.length,
//         itemBuilder: (context, index) {
//           final p = inventario[index];
//           return Card(
//             margin: const EdgeInsets.all(8),
//             child: ListTile(
//               title: Text(p['nombre'] ?? ''),
//               subtitle: Text(
//                   'Código: ${p['codigo']} | Stock: ${p['stock']} | Categoria: ${p['categoria']}'),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
