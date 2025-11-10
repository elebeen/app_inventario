import 'package:registro_productos/data/models/category_model.dart';

class Product {
  String? codigo_barras;
  String? nombre;
  String? precio;
  String? stock;
  Category? categoriaId;

  Product({this.codigo_barras, this.nombre, this.precio, this.stock, this.categoriaId});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      codigo_barras: json['codigoBarras'],
      nombre: json['nombre'],
      precio: json['precio'],
      stock: json['stock'],
      categoriaId: json['categoriaId'] != null 
          ? Category.fromJson(json['categoriaId'] as Map<String, dynamic>)
          : null,
    );
  }
}