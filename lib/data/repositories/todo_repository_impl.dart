import 'package:flutter_rest_todo/data/datasources/remote_data_source.dart';
import 'package:flutter_rest_todo/data/models/todo_model.dart';
import 'package:flutter_rest_todo/domain/entities/todo_item.dart';
import 'package:flutter_rest_todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final RemoteDataSource remoteDataSource;

  const TodoRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addTodo(TodoItem item) async {
    await remoteDataSource.addTodo(
      TodoModel(
        title: item.title,
        description: item.description,
        category: item.category,
      ).toJson(),
    );
  }

  @override
  Future<Set<String>> getCategories() async {
    final categories = await remoteDataSource.getCategories();
    return categories.toSet();
  }

  @override
  Future<List<TodoItem>> getTodos() async {
    final todos = await remoteDataSource.getTodos();
    return todos
        .map((json) => TodoModel.fromJson(json))
        .cast<TodoItem>()
        .toList();
  }
}
