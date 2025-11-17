import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/data/models/product_model.dart';
import 'package:registro_productos/provider/product_provider.dart';

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

    // Pasamos la lista de productos del provider a tu widget de lista
    // (Asumiendo que tienes un widget ProductList como en tu código comentado)
    return ProductList(
      productProvider.products.content,
      _scrollController,
      productProvider.hasMore,
      productProvider.isLoading,
    );
  }
}

//  // Este es el widget que tenías comentado, ahora recibe la lista
class ProductList extends StatelessWidget {
  final List<Product> products;
  final ScrollController scrollController;
  final bool hasMore;
  final bool isLoading;

  const ProductList(
    this.products,
    this.scrollController,
    this.hasMore,
    this.isLoading,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: products.length + 1, //  <-- item extra
      itemBuilder: (context, index) {

        // Último ítem → indicador
        if (index == products.length) {
          if (hasMore) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            return const SizedBox.shrink();
          }
        }

        final p = products[index];

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(p.nombre ?? ''),
            subtitle: Text(
              'Código: ${p.codigoBarras} '
                  '| Stock: ${p.stock} '
                  '| Categoría: ${p.categoria?.name ?? 'N/A'}',
            ),
          ),
        );
      },
    );
  }
}