import 'package:registro_productos/data/models/product_model.dart';

class Category {
  String? id;
  String? name;
  String? image;
  List<Product>? product;

  Category({this.id, this.name, this.image, this.product});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      product: (json['product'] as List<dynamic>?)
        ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList(),
    );
  }
}