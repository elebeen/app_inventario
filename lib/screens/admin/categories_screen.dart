import 'package:flutter/material.dart';
import '../../data/inventory_data.dart';
import 'create_category_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // Abrir pantalla para crear nueva categoría
  void crearCategoria() async {
    final nuevaCategoria = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateCategoryScreen()),
    );

    if (nuevaCategoria != null && nuevaCategoria is String) {
      setState(() {
        categorias.add(nuevaCategoria);
      });
    }
  }

  // Abrir pantalla de productos por categoría
  void verCategoria(String categoria) {
    final productos =
        inventario.where((p) => p['categoria'] == categoria).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryProductsScreen(
          categoria: categoria,
          productos: productos,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categorías (Admin)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: crearCategoria,
              child: const Text('Crear Categoría'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final categoria = categorias[index];
                  return Card(
                    child: ListTile(
                      title: Text(categoria),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => verCategoria(categoria),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla que muestra productos de una categoría
class CategoryProductsScreen extends StatelessWidget {
  final String categoria;
  final List<Map<String, dynamic>> productos;

  const CategoryProductsScreen({
    super.key,
    required this.categoria,
    required this.productos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Productos: $categoria')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: productos.isEmpty
            ? const Center(child: Text('No hay productos en esta categoría.'))
            : ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final p = productos[index];
                  return Card(
                    child: ListTile(
                      title: Text(p['nombre'] ?? ''),
                      subtitle: Text(
                          'Código: ${p['codigo']}, Precio: ${p['precio']}, Stock: ${p['stock']}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
