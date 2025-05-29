import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repository.dart';

final appRepositoryProvider = Provider<AppRepository>((ref) {
  return AppRepositoryImpl(
    baseUrl: 'https://my-json-server.typicode.com/i-panov/flutter_rest_todo',
  );
});

final categoriesProvider = FutureProvider<ISet<String>>((ref) async {
  final repo = ref.watch(appRepositoryProvider);
  return (await repo.getCategories()).lock;
});

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

class TodoListNotifier extends StateNotifier<TodoListState> {
  final AppRepository _repo;

  TodoListNotifier(this._repo) : super(TodoListState()) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    state = state.copyWith(isLoading: true);

    try {
      final todos = await _repo.getTodoItems();
      state = state.copyWith(todos: todos.lock, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addTodo(TodoItem item) async {
    await _repo.addTodoItem(item);
    await loadTodos();
  }
}

final todoListProvider = StateNotifierProvider<TodoListNotifier, TodoListState>(
  (ref) => TodoListNotifier(ref.watch(appRepositoryProvider)),
);

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final filteredTodosProvider = Provider<IList<TodoItem>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final todos = ref.watch(todoListProvider).todos;
  if (selectedCategory == null) return todos;
  return todos.where((item) => item.category == selectedCategory).toIList();
});
