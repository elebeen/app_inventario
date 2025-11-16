import 'package:registro_productos/core/dio_client.dart';
import 'package:registro_productos/data/models/product_model.dart';

abstract class ProductRepository {
  Future<PaginatedProductsResponse> fetchProducts();
  Future<Product> fetchProduct(int id);
  Future<Product> createProduct(String codigoBarras, String nombre, double precio, int stock, String categoria);
  Future<Product> updateProduct(int id, String nombre, double precio, int stock, String categoria);
  Future<Product> updateStock(int id, int stock);
  Future<void> deleteProduct(int id);
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiService _api;

  ProductRepositoryImpl(this._api);
  
  @override
  Future<PaginatedProductsResponse> fetchProducts({ int page = 1, int size = 10 }) async {
    final response = await _api.get('/productos', 
      params: {
        'page': page, 
        'size': size
      }
    );
    return PaginatedProductsResponse.fromJson(response.data);
  }

  @override
  Future<Product> fetchProduct(int id) async {
    final response = await _api.get('/productos/$id');
    return Product.fromJson(response.data);
  }
  
  @override
  Future<Product> createProduct(String codigoBarras, String nombre, double precio, int stock, String categoria) async {
    final response = await _api.post('/productos/', {
      'codigo_barras': codigoBarras,
      'nombre': nombre,
      'precio':precio ,
      'stock': stock,
      'categoria': categoria,
    });
    return Product.fromJson(response.data);
  }

  @override
  Future<Product> updateProduct(int id, String nombre, double precio, int stock, String categoria) async {
    final response = await _api.put('/productos/$id', {
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
      'categoriaId': categoria,
    });
    return Product.fromJson(response.data);
  }
  
  @override
  Future<Product> updateStock(int id, int stock) async {
    final response = await _api.put('/productos/$id', {
      'cantidad': stock,
    });
    return Product.fromJson(response.data);
  }

  @override
  Future<void> deleteProduct(int id) async {
    final response = await _api.delete('/productos/$id');
    return response.data;
  }
}

