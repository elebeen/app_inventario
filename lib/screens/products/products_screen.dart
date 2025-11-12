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
  @override
  void initState() {
    super.initState();
    // Llamamos al ViewModel para que cargue los datos UNA VEZ
    // Usamos addPostFrameCallback para asegurar que el 'context' esté listo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // listen: false porque solo queremos llamar a la función, no escuchar cambios
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
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

    if (productProvider.products.isEmpty) {
      return const Center(child: Text("No se encontraron productos."));
    }

    // Pasamos la lista de productos del provider a tu widget de lista
    // (Asumiendo que tienes un widget ProductList como en tu código comentado)
    return ProductList(productProvider.products);
  }
}

//  // Este es el widget que tenías comentado, ahora recibe la lista
class ProductList extends StatelessWidget {
  final List<Product> products;
  const ProductList(this.products, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(p.nombre ?? ''),
            subtitle: Text(
                'Código: ${p.codigoBarras} | Stock: ${p.stock} | Categoria: ${p.categoria?.name ?? 'N/A'}'),
          ),
        );
      },
    );
  }
}