import 'package:registro_productos/data/models/category_model.dart';

class Product {
  int? id;
  String? codigoBarras;
  String? nombre;
  double? precio;
  int? stock;
  Category? categoria;

  Product({
    this.id,
    this.codigoBarras, 
    this.nombre, 
    this.precio, 
    this.stock, 
    this.categoria
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    
    Category? parsedCategory;
    final categoryData = json['categoria']; 

    if (categoryData != null && categoryData is Map<String, dynamic>) {
      // 2. Parsea el objeto 'categoria'
      parsedCategory = Category.fromJson(categoryData);
    } else {
      // Como plan B, si 'categoria' no viniera, usamos el ID.
      if (json['categoriaId'] != null) {
          parsedCategory = Category(id: json['categoriaId'], name: null);
      } else {
          parsedCategory = null;
      }
    }

    return Product(
      codigoBarras: json['codigo_barras'],
      nombre: json['nombre'],
      precio: double.parse(json['precio']),
      stock: json['stock'],
      // Asignamos la categoría que procesamos
      categoria: parsedCategory,
    );
  }
}