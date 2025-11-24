import 'package:registro_productos/core/dio_client.dart';
import 'package:registro_productos/data/models/product_model.dart';

abstract class ProductRepository {
  Future<PaginatedProductsResponse> fetchProducts(int page, int size);
  Future<Product> fetchProduct(int id);
  Future<Product> createProduct(String codigoBarras, String nombre, double precio, int stock, int categoria);
  Future<Product> updateProduct(int id, String nombre, double precio, int stock, int categoria);
  Future<Product> updateStock(int id, int stock);
  Future<void> deleteProduct(int id);
  Future<Product> fetchProductByBarcode(String codigoBarras);
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiService _api;
  ProductRepositoryImpl(this._api);

  @override
  Future<PaginatedProductsResponse> fetchProducts( int page, int size ) async {
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
  Future<Product> createProduct(String codigoBarras, String nombre, double precio, int stock, int categoria) async {
    final response = await _api.post('/productos/', {
      'codigo_barras': codigoBarras,
      'nombre': nombre,
      'precio':precio ,
      'stock': stock,
      'categoriaId': categoria,
    });

    return Product.fromJson(response.data);
  }

  @override
  Future<Product> updateProduct(int id, String nombre, double precio, int stock, int categoria) async {
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
  
  @override
  Future<Product> fetchProductByBarcode(String codigoBarras) async {
    final response = await _api.post('/productos/scan/', {
      'codigo_barras': codigoBarras,
    });

    return Product.fromJson(response.data);
  }
}

