import 'package:flutter_rest_todo/domain/entities/todo_item.dart';

abstract class TodoRepository {
  Future<Set<String>> getCategories();
  Future<List<TodoItem>> getTodos();
  Future<void> addTodo(TodoItem item);
}
