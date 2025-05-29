import 'package:flutter_rest_todo/domain/repositories/todo_repository.dart';

class GetCategories {
  final TodoRepository repository;

  const GetCategories(this.repository);

  Future<Set<String>> call() => repository.getCategories();
}
