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