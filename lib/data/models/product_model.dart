class Product {
  String? codigoBarras;
  String? nombre;
  String? precio;
  String? stock;

  Product({this.codigoBarras, this.nombre, this.precio, this.stock});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      codigoBarras: json['codigoBarras'],
      nombre: json['nombre'],
      precio: json['precio'],
      stock: json['stock'],
    );
  }
}