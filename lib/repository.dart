import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class TodoItem extends Equatable {
  final String title, description, category;

  const TodoItem({
    required this.title,
    required this.description,
    required this.category,
  });

  factory TodoItem.fromJson(Map json) => TodoItem(
    title: json['title'],
    description: json['description'],
    category: json['category'],
  );

  Map<String, dynamic> toJson() => {
    'name': title,
    'description': description,
    'category': category,
  };

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [title, description, category];
}

abstract interface class AppRepository {
  Future<Set<String>> getCategories();
  Future<List<TodoItem>> getTodoItems();
  Future<void> addTodoItem(TodoItem item);
}

class AppRepositoryImpl implements AppRepository {
  static const _baseUrl =
      'my-json-server.typicode.com/i.panov/flutter_rest_todo';

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
    ),
  );

  final String baseUrl;

  AppRepositoryImpl({this.baseUrl = _baseUrl});

  @override
  Future<Set<String>> getCategories() async {
    final response = await _dio.get<List>('/categories');
    return (response.data ?? []).map((s) => s.toString()).toSet();
  }

  @override
  Future<List<TodoItem>> getTodoItems() async {
    final response = await _dio.get<List>('/todos');

    return (response.data ?? []).map((e) => TodoItem.fromJson(e)).toList();
  }

  @override
  Future<void> addTodoItem(TodoItem item) async {
    await _dio.post('/todos', data: item.toJson());
  }
}
