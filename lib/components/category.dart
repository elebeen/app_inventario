import 'package:flutter/material.dart';
import 'package:registro_productos/data/models/category_model.dart';

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
    return ListView.builder(
      controller: scrollController,
      itemCount: categories.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == categories.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final category = categories[index];

        return ListTile(
          title: Text(category.nombre),
          subtitle: Text("ID: ${category.id}"),
          //trailing: const Icon(Icons.arrow_forward_ios),
        );
      },
    );
  }
}
