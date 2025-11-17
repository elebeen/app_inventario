import 'package:registro_productos/data/models/product_model.dart';

// para solo obtener las categorías sin productos
class Category {
  final int id;
  final String nombre;
  final int tiendaId;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.nombre,
    required this.tiendaId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nombre: json['nombre'],
      tiendaId: json['tiendaId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class PaginatedCategoryResponse {
  final List<Category> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  PaginatedCategoryResponse({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginatedCategoryResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedCategoryResponse(
      content: (json['content'] as List<dynamic>?)
              ?.map((c) => Category.fromJson(c))
              .toList() ?? [],
      page: json['page'] ?? 0,
      size: json['size'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrevious: json['hasPrevious'] ?? false,
    );
  }
}

// para la relacion muchos a muchos y obtener los productos de una categoría
class CategoryWithProductsResponse {
  final Category categoria;
  final List<Product> productos;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  CategoryWithProductsResponse({
    required this.categoria,
    required this.productos,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory CategoryWithProductsResponse.fromJson(Map<String, dynamic> json) {
    return CategoryWithProductsResponse(
      categoria: Category.fromJson(json['categoria']),
      productos: (json['productos'] as List<dynamic>?)
              ?.map((p) => Product.fromJson(p))
              .toList() ?? [],
      page: json['page'] ?? 0,
      size: json['size'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrevious: json['hasPrevious'] ?? false,
    );
  }
}