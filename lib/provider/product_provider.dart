import 'package:flutter/foundation.dart';
import 'package:registro_productos/domain/repositories/product_repository.dart';
import 'package:registro_productos/data/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepositoryImpl _productRepository;

  ProductProvider(this._productRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  PaginatedProductsResponse _products = PaginatedProductsResponse(
    content: [],
    page: 1,
    size: 10,
    totalElements: 0,
    totalPages: 0,
    hasNext: false,
    hasPrevious: false,
  );
  
  PaginatedProductsResponse get products => _products;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productRepository.fetchProducts();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Aquí puedes agregar más lógica (createProduct, deleteProduct, etc.)
  // y llamar a notifyListeners() cuando el estado cambie.
}