import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_rest_todo/domain/entities/todo_item.dart';

class TodoListState extends Equatable {
  final IList<TodoItem> todos;
  final bool isLoading;

  const TodoListState({
    this.todos = const IList.empty(),
    this.isLoading = false,
  });

  TodoListState copyWith({IList<TodoItem>? todos, bool? isLoading}) {
    return TodoListState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [todos, isLoading];
}
