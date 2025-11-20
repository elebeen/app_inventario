import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/provider/product_provider.dart';
import '../../components/product.dart';
import 'package:registro_productos/screens/products/scan_product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Llamamos al ViewModel para que cargue los datos UNA VEZ
    // Usamos addPostFrameCallback para asegurar que el 'context' esté listo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // listen: false porque solo queremos llamar a la función, no escuchar cambios
      Provider.of<ProductProvider>(context, listen: false).refreshProducts();
    });

    _scrollController.addListener(() {
      final provider = Provider.of<ProductProvider>(context, listen: false);

      if (provider.products.page == 1) return;

      if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9 &&
        provider.hasMore &&
        !provider.isLoading) {
        provider.fetchProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    Widget screenBody;
    if (productProvider.isLoading) {
      screenBody = const Center(child: CircularProgressIndicator());
    } else if (productProvider.errorMessage != null) {
      screenBody = Center(child: Text("Error: ${productProvider.errorMessage}"));
    } else if (productProvider.products.content.isEmpty) {
      screenBody = const Center(child: Text("No se encontraron productos."));
    } else {
      screenBody = ProductList(
        productProvider.products.content,
        _scrollController,
        productProvider.hasMore,
        productProvider.isLoading,
      );
    }

    return Scaffold(
      body: screenBody,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: () async {
          // 1. Esperamos a que la pantalla de Scan/Añadir se cierre
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScanProductScreen()),
          );
        },
      ),
    );
  }
}