import 'package:registro_productos/data/models/category_model.dart';

class Product {
  final int? id;
  final String? codigoBarras;
  final String? nombre;
  final double? precio;
  final int? stock;
  final Category? categoria;

  Product({
    this.id,
    this.codigoBarras,
    this.nombre,
    this.precio,
    this.stock,
    this.categoria,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final categoryData = json['categoria'];
    Category? parsedCategory;

    if (categoryData != null && categoryData is Map<String, dynamic>) {
      parsedCategory = Category.fromJson(categoryData);
    } else if (json['categoriaId'] != null) {
      parsedCategory = Category(id: json['categoriaId'], name: null);
    }

    return Product(
      id: json['id'],
      codigoBarras: json['codigo_barras'],
      nombre: json['nombre'],
      precio: double.tryParse(json['precio'].toString()) ?? 0.0,
      stock: json['stock'],
      categoria: parsedCategory,
    );
  }
}

class PaginatedProductsResponse {
  final List<Product> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  PaginatedProductsResponse({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginatedProductsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedProductsResponse(
      content: (json['content'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
      page: json['page'],
      size: json['size'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      hasNext: json['hasNext'],
      hasPrevious: json['hasPrevious'],
    );
  }
}
