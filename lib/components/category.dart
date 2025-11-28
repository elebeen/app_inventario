import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registro_productos/data/models/category_model.dart';
import 'package:registro_productos/provider/category_provider.dart';
import 'package:registro_productos/screens/categories/edit_category_screen.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;
  final ScrollController scrollController;
  final bool hasMore;
  final bool isLoading;

  const CategoryList(
    this.categories,
    this.scrollController,
    this.hasMore,
    this.isLoading, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.read<CategoryProvider>();

    return ListView.builder(
      controller: scrollController,
      itemCount: categories.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == categories.length) {
          return _buildLoadingIndicator();
        }

        final category = categories[index];
        return _buildCategoryCard(context, category, categoryProvider);
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category, CategoryProvider categoryProvider) {
    return Dismissible(
      key: ValueKey(category.id),
      direction: DismissDirection.endToStart,
      background: _buildDismissibleBackground(),
      secondaryBackground: _buildDismissibleSecondaryBackground(),
      confirmDismiss: (direction) => _showDeleteConfirmationDialog(context, category),
      onDismissed: (direction) => _handleCategoryDelete(context, category, categoryProvider),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con nombre de categoría
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      category.nombre,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // _buildCategoryStatusBadge(category),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Información de la categoría
              _buildCategoryInfoRow(
                context,
                Icons.fingerprint_outlined,
                'ID de categoría',
                category.id.toString(),
              ),
              
              const SizedBox(height: 12),
              
              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditCategoryScreen(
                            id: category.id, 
                            name: category.nombre
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Editar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20.0),
      child: const Row(
        children: [
          Icon(Icons.edit, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Editar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissibleSecondaryBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Eliminar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.delete, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildCategoryInfoRow(BuildContext context, IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context, Category category) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar Categoría"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "¿Estás seguro de que quieres eliminar la categoría \"${category.nombre}\"?",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                "Se eliminarán todos los productos de esta categoría.", 
                style: Theme.of(context).textTheme.bodyLarge
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCELAR"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "ELIMINAR",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleCategoryDelete(BuildContext context, Category category, CategoryProvider categoryProvider) {
    categoryProvider.deleteCategory(category.id);
    categoryProvider.resetCategories();
    categoryProvider.fetchCategories();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Categoría "${category.nombre}" eliminada'),
      ),
    );
  }
}