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
    // Necesitas acceder al CategoryProvider para llamar a la función de eliminación
    final categoryProvider = context.read<CategoryProvider>();

    return ListView.builder(
      controller: scrollController,
      itemCount: categories.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == categories.length) {
          // ... (Mostrar CircularProgressIndicator para más categorías)
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final category = categories[index];

        // 💡 Usamos Dismissible para implementar el deslizamiento
        return Dismissible(
          // 1. **Key:** Obligatorio. Debe ser único para cada elemento.
          key: ValueKey(category.id),
          
          // 2. **Background:** Lo que se muestra mientras se desliza.
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          
          // 3. **Direction:** Permite deslizar solo hacia un lado (ej. de derecha a izquierda).
          direction: DismissDirection.endToStart,
          
          // 4. **Confirmar Deslizamiento (Opcional pero Recomendado):** // Permite mostrar un diálogo de confirmación antes de eliminar.
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirmar"),
                  content: Text("¿Estás seguro de que quieres eliminar la categoría ${category.nombre}?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false), // No eliminar
                      child: const Text("CANCELAR"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true), // Eliminar
                      child: const Text("ELIMINAR", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );
          },
          
          // 5. **On Dismissed:** La acción a ejecutar una vez que se desliza y se confirma.
          onDismissed: (direction) {
            // Llama al método de tu CategoryProvider para eliminar la categoría
            categoryProvider.deleteCategory(category.id);
            categoryProvider.resetCategories();
            categoryProvider.fetchCategories();
            
            // Opcional: Mostrar un SnackBar para indicar que se ha eliminado o para deshacer la acción.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Categoría ${category.nombre} eliminada')),
            );
          },
          
          // 6. **Child:** El widget que se puede deslizar.
          child: ListTile(
            title: Text(category.nombre),
            subtitle: Text("ID: ${category.id}"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCategoryScreen(id: category.id, name: category.nombre)),
              );
            },
          ),
        );
      },
    );
  }
}