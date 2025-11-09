import 'package:dio/dio.dart';
import 'package:registro_productos/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<Category> getCategories(String id);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final Dio _dio;

  CategoryRepositoryImpl(this._dio);
  
  @override
  Future<Category> getCategories(String id) async {
    try {
      final response = await _dio.get('/categorias/$id');
      if (response.statusCode == 200) {
        return Category.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Error al obtener categorias');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}