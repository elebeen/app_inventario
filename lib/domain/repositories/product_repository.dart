import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
import 'package:dio/dio.dart';
import 'package:registro_productos/data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  Future<Product> fetchProduct(String id);
  Future<Product> createProduct(String codigoBarras, String nombre, Float precio, Int32 stock, String categoria);
  Future<Product> updateProduct(String id, String nombre, Float precio, Int32 stock, String categoria);
  Future<Product> updateStock(String id, Int32 stock);
  Future<void> deleteProduct(String id);
}

class ProductRepositoryImpl implements ProductRepository {
  final Dio _dio;

  ProductRepositoryImpl(this._dio);
  
  @override
  Future<List<Product>> fetchProducts() async {
    final response = await _dio.get('/productos/');
    return (response.data as List).map((e) => Product.fromJson(e)).toList();
  }

  @override
  Future<Product> fetchProduct(String id) async {
    final response = await _dio.get('/productos/$id');
    return Product.fromJson(response.data);
  }
  
  @override
  Future<Product> createProduct(String codigoBarras, String nombre, Float precio, Int32 stock, String categoria) async {
    final response = await _dio.post('/productos/crear', data: {
      'codigo_barras': codigoBarras,
      'nombre': nombre,
      'precio':precio ,
      'stock': stock,
      'categoria': categoria,
    });
    return Product.fromJson(response.data);
  }

  @override
  Future<Product> updateProduct(String id, String nombre, Float precio, Int32 stock, String categoria) async {
    final response = await _dio.put('/productos/$id', data: {
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
      'categoriaId': categoria,
    });
    return Product.fromJson(response.data);
  }
  
  @override
  Future<Product> updateStock(String id, Int32 stock) async {
    final response = await _dio.put('/productos/$id', data: {
      'cantidad': stock,
    });
    return Product.fromJson(response.data);
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response = await _dio.delete('/productos/$id');
    return response.data;
  }
}

