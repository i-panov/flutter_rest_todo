import 'package:dio/dio.dart';
import 'remote_data_source.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  const RemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Map<String, dynamic>>> getTodos() async {
    final response = await dio.get<List>('/todos');
    return (response.data ?? []).cast<Map<String, dynamic>>();
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await dio.get<List>('/categories');
    return (response.data ?? []).map((e) => e.toString()).toList();
  }

  @override
  Future<void> addTodo(Map<String, dynamic> todo) async {
    await dio.post('/todos', data: todo);
  }
}
