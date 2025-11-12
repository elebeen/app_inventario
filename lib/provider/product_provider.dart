import 'package:flutter/material.dart';
import 'package:registro_productos/domain/repositories/product_repository.dart';
import 'package:registro_productos/data/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepository;

  ProductProvider(this._productRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Product> _products = [];
  List<Product> get products => _products;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Lógica de negocio para obtener productos
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productRepository.fetchProducts();
    } catch (e) {
      _errorMessage = e.toString()+ "del provider";
      print(e.toString()); // Manejar mejor el error en una app real
    }

    _isLoading = false;
    notifyListeners();
  }

  // Aquí puedes agregar más lógica (createProduct, deleteProduct, etc.)
  // y llamar a notifyListeners() cuando el estado cambie.
}