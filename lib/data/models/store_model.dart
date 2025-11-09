import 'package:registro_productos/data/models/category_model.dart';
import 'package:registro_productos/data/models/product_model.dart';
import 'package:registro_productos/data/models/user_model.dart';

class Store {
  String? id;
  String? nombre;
  List<Product>? product;
  List<Category>? category;
  List<User>? user;

  Store({this.id, this.nombre, this.product, this.category, this.user});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      nombre: json['nombre'],
      product: (json['product'] as List<dynamic>?)
        ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList(),
      category: (json['category'] as List<dynamic>?)
        ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList(),
      user: (json['user'] as List<dynamic>?)
        ?.map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList(),
    );
  }
}