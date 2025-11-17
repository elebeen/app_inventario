import 'package:flutter/foundation.dart';
import '../domain/repositories/category_repository.dart';
import 'package:registro_productos/data/models/category_model.dart' as categoria;
import 'package:registro_productos/data/models/product_model.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepositoryImpl _categoryRepository;

  CategoryProvider(this._categoryRepository);

  // ESTADO GLOBAL
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // listando categorias
  final List<categoria.Category> _categories = [];
  List<categoria.Category> get categories => _categories;

  bool _hasMoreCategories = true;
  bool get hasMoreCategories => _hasMoreCategories;

  int _categoryPage = 1;
  final int _categorySize = 20;

  // categorias mas productos
  final List<Product> _categoryProducts = [];
  List<Product> get categoryProducts => _categoryProducts;

  categoria.Category? _selectedCategory;
  categoria.Category? get selectedCategory => _selectedCategory;

  bool _hasMoreCategoryProducts = true;
  bool get hasMoreCategoryProducts => _hasMoreCategoryProducts;

  int _categoryProductPage = 1;
  final int _categoryProductSize = 20;

  Future<void> fetchCategories() async {
    if (_isLoading || !_hasMoreCategories) return;

    _isLoading = true;
    notifyListeners();

    try {
      final resp = await _categoryRepository.getCategories(
        _categoryPage,
        _categorySize,
      );

      if (resp.content.isNotEmpty) {
        _categories.addAll(resp.content);
      }

      if (resp.content.length < _categorySize) {
        _hasMoreCategories = false;
      }

      _categoryPage++;
      _errorMessage = null;

    } catch (e) {
      _errorMessage = 'Error al cargar categorías: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategoryProducts(int categoryId) async {
    if (_isLoading || !_hasMoreCategoryProducts) return;

    _isLoading = true;
    notifyListeners();

    try {
      final resp = await _categoryRepository.getCategory(
        categoryId,
        _categoryProductPage,
        _categoryProductSize,
      );

      _selectedCategory ??= resp.categoria;

      _categoryProducts.addAll(resp.productos);

      if (resp.productos.length < _categoryProductSize) {
        _hasMoreCategoryProducts = false;
      }

      _categoryProductPage++;
      _errorMessage = null;

    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createCategory(String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _categoryRepository.createCategory(name);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCategory(String id, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _categoryRepository.updateCategory(id, name);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _categoryRepository.deleteCategory(id);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void resetCategories() {
    _categories.clear();
    _hasMoreCategories = true;
    _categoryPage = 1;
    notifyListeners();
  }

  void resetCategoryProducts() {
    _categoryProducts.clear();
    _selectedCategory = null;
    _hasMoreCategoryProducts = true;
    _categoryProductPage = 1;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
