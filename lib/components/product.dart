import 'package:flutter/material.dart';
import 'package:registro_productos/data/models/product_model.dart';
import '../screens/products/product_detail_screen.dart';
import 'package:registro_productos/screens/products/scan_product.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;
  final ScrollController scrollController;
  final bool hasMore;
  final bool isLoading;

  const ProductList(
      this.products,
      this.scrollController,
      this.hasMore,
      this.isLoading, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: products.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == products.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final product = products[index];

        return Scaffold(
          body: ListTile(
            title: Text(product.nombre.toString()),
            subtitle: Text("ID: ${product.id}"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product)
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.add),
            // Agregar un nuevo producto
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScanProductScreen()),
              );
            },
          ),
        );
      },
    );
  }
}
