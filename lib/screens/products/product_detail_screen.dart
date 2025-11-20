import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/components/app_bar.dart';
import 'package:registro_productos/components/product_info.dart';
import 'package:registro_productos/data/models/product_model.dart';
import 'package:registro_productos/provider/product_provider.dart';
import 'package:registro_productos/screens/products/edit_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreen();
}
class _ProductDetailScreen extends State<ProductDetailScreen> {

  Future<void> deleteProduct() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    await productProvider.deleteProduct(widget.product.id!);
    if (!mounted) return;
    // Después de eliminar, recargar la lista de productos para reflejar el cambio
    productProvider.refreshProducts();
    productProvider.clearLoading();
    print("Productos cargados delete_product_screen");
    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.product.nombre),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aquí insertamos el nuevo widget reusado
            ProductInfo(product: widget.product),

            const Spacer(),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProductScreen(id: widget.product.id),
                      ),
                    );
                  },
                  child: const Text('Editar'),
                ),
                const SizedBox(width: 12),

                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('¿Estás seguro?'),
                          content: const Text('Esta acción no se puede deshacer'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteProduct();
                                Navigator.pop(context);
                              },
                              child: const Text('Eliminar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Eliminar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
