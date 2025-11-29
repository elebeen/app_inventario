import 'package:flutter/foundation.dart';
import 'package:registro_productos/domain/repositories/product_repository.dart';
import 'package:registro_productos/data/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepositoryImpl _productRepository;
  ProductProvider(this._productRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;
  int _page = 0;
  final int _size = 20;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final PaginatedProductsResponse _products = PaginatedProductsResponse(
    content: [],
    page: 1,
    size: 10,
    totalElements: 0,
    totalPages: 0,
    hasNext: false,
    hasPrevious: false,
  );
  
  PaginatedProductsResponse get products => _products;

  Product? _currentProduct;
  Product? get currentProduct => _currentProduct;

  Future<void> fetchProducts() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final res = await _productRepository.fetchProducts(_page, _size);
      _products.content.addAll(res.content);

      if (res.content.length < _size) {
        _hasMore = false;
      }

      _page++;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Product> fetchProduct(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final product = await _productRepository.fetchProduct(id);
      _currentProduct = product;
      return product;
    } catch (e) {
      _errorMessage = e.toString();
      _currentProduct = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> createProduct(
    String codigoBarras,
    String nombre,
    double precio,
    int stock,
    int categoria
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final product = await _productRepository.createProduct(
        codigoBarras,
        nombre,
        precio,
        stock,
        categoria
      );
      return product.nombre.toString();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return "Error al crear el producto $nombre";
  }

  Future<String> updateProduct(
    int id,
    String nombre,
    double precio,
    int stock,
    int categoria
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final product = await _productRepository.updateProduct(
        id,
        nombre,
        precio,
        stock,
        categoria
      );
      return product.nombre.toString();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return "Error al actualizar el producto $nombre";
  }

  Future<Product> updateStock(int id, int stock) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final product = await _productRepository.updateStock(id, stock);
      return product;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return Product();
  }

  Future<void> deleteProduct(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _productRepository.deleteProduct(id);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    // 1. Bloqueamos inmediatamente para evitar que el ScrollController pida datos
    _isLoading = true;
    notifyListeners(); // Esto mostrará el CircularProgressIndicator de inmediato

    // 2. Limpiamos la lista y reseteamos contadores mientras está cargando
    _products.content.clear();
    _page = 0;
    _hasMore = true;
    _errorMessage = null;

    try {
      // 3. Hacemos la petición directamente (sin llamar a fetchProducts para evitar chequeos extra)
      final res = await _productRepository.fetchProducts(_page, _size);
      
      // 4. Agregamos los datos nuevos
      _products.content.addAll(res.content);

      // 5. Verificamos si hay más páginas
      if (res.content.length < _size) {
        _hasMore = false;
      }

      // Preparamos la siguiente página
      _page++;
      
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      // 6. Desbloqueamos al final
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Product?> scanProduct(String barcode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final product = await _productRepository.scanProducts(barcode);
      _currentProduct = product;
      _isLoading = false;
      notifyListeners();

      return product;
    } catch (e) {
      _currentProduct = null;
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return null;
  }

  void resetPagination() {
    _hasMore = true;
    _page = 1;
    _errorMessage = null;
    notifyListeners();
  }

  void clearCurrentProduct() {
    _currentProduct = null;
    notifyListeners();
  }

  void clearLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}