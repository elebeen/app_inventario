import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/provider/product_provider.dart';
import '../../components/product.dart';

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
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });

    _scrollController.addListener(() {
      final provider = Provider.of<ProductProvider>(context, listen: false);

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
    // Ya no necesitas el FutureBuilder.
    // Usamos context.watch para que el widget se reconstruya
    // cada vez que ProductProvider llame a notifyListeners()
    final productProvider = context.watch<ProductProvider>();

    // Mostramos diferentes UI según el estado del ViewModel
    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (productProvider.errorMessage != null) {
      return Center(child: Text("Error: ${productProvider.errorMessage}"));
    }

    if (productProvider.products.content.isEmpty) {
      return const Center(child: Text("No se encontraron productos."));
    }

    return ProductList(
      productProvider.products.content,
      _scrollController,
      productProvider.hasMore,
      productProvider.isLoading,
    );
  }
}