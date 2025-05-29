import 'package:dio/dio.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rest_todo/data/datasources/remote_data_source_impl.dart';
import 'package:flutter_rest_todo/data/repositories/todo_repository_impl.dart';
import 'package:flutter_rest_todo/domain/entities/todo_item.dart';
import 'package:flutter_rest_todo/domain/usecases/add_todo.dart';
import 'package:flutter_rest_todo/domain/usecases/get_categories.dart';
import 'package:flutter_rest_todo/domain/usecases/get_todos.dart';
import 'package:flutter_rest_todo/presentation/providers/todo_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final url = 'https://my-json-server.typicode.com/i-panov/flutter_rest_todo';

  final dio = Dio(
    BaseOptions(
      baseUrl: url,
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
    ));
  }

  return dio;
});

final remoteDataSourceProvider = Provider<RemoteDataSourceImpl>((ref) {
  return RemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

// Repositories
final todoRepositoryProvider = Provider((ref) {
  return TodoRepositoryImpl(ref.watch(remoteDataSourceProvider));
});

// Use Cases
final getCategoriesProvider = Provider((ref) {
  return GetCategories(ref.watch(todoRepositoryProvider));
});

final getTodosProvider = Provider((ref) {
  return GetTodos(ref.watch(todoRepositoryProvider));
});

final addTodoProvider = Provider((ref) {
  return AddTodo(ref.watch(todoRepositoryProvider));
});

// State Providers
final categoriesProvider = FutureProvider<ISet<String>>((ref) async {
  return (await ref.watch(getCategoriesProvider)()).lock;
});

class TodoListNotifier extends StateNotifier<TodoListState> {
  final GetTodos getTodos;

  TodoListNotifier(this.getTodos) : super(TodoListState()) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    state = state.copyWith(isLoading: true);
    try {
      final todos = await getTodos();
      state = state.copyWith(todos: todos.lock, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final todoListProvider = StateNotifierProvider<TodoListNotifier, TodoListState>(
  (ref) => TodoListNotifier(ref.watch(getTodosProvider)),
);

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final filteredTodosProvider = Provider<IList<TodoItem>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final todos = ref.watch(todoListProvider).todos;
  return selectedCategory == null
      ? todos
      : todos.where((item) => item.category == selectedCategory).toIList();
});
