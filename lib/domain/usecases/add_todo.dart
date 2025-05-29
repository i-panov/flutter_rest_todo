import 'package:flutter_rest_todo/domain/entities/todo_item.dart';
import 'package:flutter_rest_todo/domain/repositories/todo_repository.dart';

class AddTodo {
  final TodoRepository repository;

  const AddTodo(this.repository);

  Future<void> call(TodoItem item) => repository.addTodo(item);
}
