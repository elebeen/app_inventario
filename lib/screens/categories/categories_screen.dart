import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/components/category.dart';
import 'package:registro_productos/provider/category_provider.dart';
import 'package:registro_productos/screens/categories/add_category.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Llamar a la API una sola vez
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });

    // Scroll infinito
    _scrollController.addListener(() {
      final provider = Provider.of<CategoryProvider>(context, listen: false);

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9 &&
          provider.hasMoreCategories &&
          !provider.isLoading) {
        provider.fetchCategories();
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
    final categoryProvider = context.watch<CategoryProvider>();

    Widget screenBody = const SizedBox.shrink();

    if (categoryProvider.isLoading) {
      screenBody = const Center(child: CircularProgressIndicator());
    } else if (categoryProvider.errorMessage != null) {
      screenBody = Center(child: Text("Error: ${categoryProvider.errorMessage}"));
    } else if (categoryProvider.categories.isEmpty) {
      screenBody = const Center(child: Text("No se encontraron categorias."));
    } else {
      screenBody = CategoryList(
        categoryProvider.categories,
        _scrollController,
        categoryProvider.hasMoreCategories,
        categoryProvider.isLoading,
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
            MaterialPageRoute(builder: (_) => const CreateCategoryScreen()),
          );
        },
      ),
    );
  }
}