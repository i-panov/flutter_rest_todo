import 'package:flutter_rest_todo/domain/entities/todo_item.dart';

class TodoModel extends TodoItem {
  const TodoModel({
    required super.title,
    required super.description,
    required super.category,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
    title: json['title'],
    description: json['description'],
    category: json['category'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'category': category,
  };
}
