import 'package:flutter_rest_todo/domain/entities/todo_item.dart';
import 'package:flutter_rest_todo/domain/repositories/todo_repository.dart';

class GetTodos {
  final TodoRepository repository;

  const GetTodos(this.repository);

  Future<List<TodoItem>> call() => repository.getTodos();
}
