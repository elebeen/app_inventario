import 'package:dio/dio.dart';
import 'package:registro_productos/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<CategoryWithProduct> getCategory(String id);
  Future<void> createCategory(String category);
  Future<void> updateCategory(String id, String category);
  Future<void> deleteCategory(String id);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final Dio _dio;

  CategoryRepositoryImpl(this._dio);
  
  @override
  Future<List<Category>> getCategories() async {
    final response = await _dio.get('/categorias/');
    return (response.data as List).map((e) => Category.fromJson(e)).toList();
  }
  
  @override
  Future<CategoryWithProduct> getCategory(String id) async {
    final response = await _dio.get('/categorias//$id');
    return CategoryWithProduct.fromJson(response.data);
  }

  @override
  Future<void> createCategory(String category) async {
    final response = await _dio.post('/categorias/', data: {'nombre': category});
    return response.data;
  }
  
  @override
  Future<void> updateCategory(String id, String category) async {
    final response = await _dio.put('/categorias/$id', data: {'nombre': category});
    return response.data;
  }

  @override
  Future<void> deleteCategory(String id) async {
    final response = await _dio.delete('/categorias/$id');
    return response.data;
  }
}