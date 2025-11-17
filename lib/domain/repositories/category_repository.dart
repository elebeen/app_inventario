import 'package:registro_productos/core/dio_client.dart';
import 'package:registro_productos/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<PaginatedCategoryResponse> getCategory(int id);
  Future<void> createCategory(String category);
  Future<void> updateCategory(String id, String category);
  Future<void> deleteCategory(String id);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiService _api;
  CategoryRepositoryImpl(this._api);

  int? _page = 1;
  int? _size = 10;

  int? get page => _page;
  int? get size => _size;
  
  @override
  Future<List<Category>> getCategories() async {
    final response = await _api.get('/categorias/');
    return (response.data as List).map((e) => Category.fromJson(e)).toList();
  }
  
  @override
  Future<PaginatedCategoryResponse> getCategory(int id) async {
    final response = await _api.get('/categorias/$id',
      params: {
        'page': _page,
        'size': _size
      }
    );
    return PaginatedCategoryResponse.fromJson(response.data);
  }

  @override
  Future<void> createCategory(String category) async {
    final response = await _api.post('/categorias/', {'nombre': category});
    return response.data;
  }
  
  @override
  Future<void> updateCategory(String id, String category) async {
    final response = await _api.put('/categorias/$id', {'nombre': category});
    return response.data;
  }

  @override
  Future<void> deleteCategory(String id) async {
    final response = await _api.delete('/categorias/$id');
    return response.data;
  }
}