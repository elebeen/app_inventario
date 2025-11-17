import 'package:registro_productos/core/dio_client.dart';
import 'package:registro_productos/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<PaginatedCategoryResponse> getCategories(int page, int size);
  Future<CategoryWithProductsResponse> getCategory(int id, int page, int size);
  Future<void> createCategory(String category);
  Future<void> updateCategory(String id, String category);
  Future<void> deleteCategory(String id);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiService _api;
  CategoryRepositoryImpl(this._api);
  
  @override
  Future<PaginatedCategoryResponse> getCategories(int page, int size) async {
    final response = await _api.get('/categorias/',
      params: {
        'page': page,
        'size': size
      }
    );

    return PaginatedCategoryResponse.fromJson(response.data);
  }
  
  @override
  Future<CategoryWithProductsResponse> getCategory(int id, page, size) async {
    final response = await _api.get('/categorias/$id',
      params: {
        'page': page,
        'size': size
      }
    );
    return CategoryWithProductsResponse.fromJson(response.data);
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