import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/components/category.dart';
import 'package:registro_productos/provider/category_provider.dart';

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

    if (categoryProvider.isLoading && categoryProvider.categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categoryProvider.errorMessage != null) {
      return Center(child: Text("Error: ${categoryProvider.errorMessage}"));
    }

    if (categoryProvider.categories.isEmpty) {
      return const Center(child: Text("No se encontraron categorias."));
    }

    if (categoryProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error: ${categoryProvider.errorMessage}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                categoryProvider.clearError();
                categoryProvider.fetchCategories();
              },
              child: const Text("Reintentar"),
            ),
          ],
        ),
      );
    }

    if (categoryProvider.categories.isEmpty && !categoryProvider.isLoading) {
      return const Center(child: Text("No se encontraron categorías."));
    }

    return CategoryList(
      categoryProvider.categories,
      _scrollController,
      categoryProvider.hasMoreCategories,
      categoryProvider.isLoading,
    );
  }
}