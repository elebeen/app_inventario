import 'package:registro_productos/data/models/product_model.dart';

// para la relacion muchos a muchos y obtener los productos de una categoría
class CategoryWithProduct {
  int? id;
  String? name;
  List<Product>? product;

  CategoryWithProduct({this.id, this.name, this.product});

  factory CategoryWithProduct.fromJson(Map<String, dynamic> json) {
    return CategoryWithProduct(
      id: json['id'],
      name: json['nombre'],
      product: (json['producto'] as List<dynamic>?)
        ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList(),
    );
  }
}

// para solo obtener las categorías sin productos
class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['nombre'],
    );
  }
}

class PaginatedCategoryResponse {
  final List<CategoryWithProduct> categories;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  PaginatedCategoryResponse({
    required this.categories,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginatedCategoryResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedCategoryResponse(
      categories: (json['content'] as List)
          .map((item) => CategoryWithProduct.fromJson(item))
          .toList(),
      page: json['page'], 
      size: json['size'], 
      totalElements: json['totalElements'], 
      totalPages: json['totalPages'], 
      hasNext: json['hasNext'], 
      hasPrevious: json['hasPrevious']
    );
  }
}