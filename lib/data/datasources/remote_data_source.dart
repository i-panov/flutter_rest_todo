abstract class RemoteDataSource {
  Future<List<Map<String, dynamic>>> getTodos();
  Future<List<String>> getCategories();
  Future<void> addTodo(Map<String, dynamic> todo);
}
