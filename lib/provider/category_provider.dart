import 'package:flutter/foundation.dart';
import '../domain/repositories/category_repository.dart';
import 'package:registro_productos/data/models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepositoryImpl _categoryRepository;

  CategoryProvider(this._categoryRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  PaginatedCategoryResponse _categorias = PaginatedCategoryResponse(
    content: [],
    page: 1,
    size: 10,
    totalElements: 0,
    totalPages: 0,
    hasNext: false,
    hasPrevious: false,
  );

  PaginatedCategoryResponse get categorias => _categorias;

  Future<void> fetchCategories(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categorias = await _categoryRepository.getCategory(id);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}