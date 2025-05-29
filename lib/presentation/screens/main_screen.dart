import 'package:flutter/material.dart';
import 'package:flutter_rest_todo/presentation/providers/todo_providers.dart';
import 'package:flutter_rest_todo/presentation/screens/create_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final todos = ref.watch(filteredTodosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ToDo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            categoriesAsync.when(
              data: (categories) => DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Все категории'),
                  ),
                  for (final category in categories)
                    DropdownMenuItem(value: category, child: Text(category)),
                ],
                onChanged: (value) =>
                    ref.read(selectedCategoryProvider.notifier).state = value,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Ошибка загрузки категорий'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(todos[index].title),
                  subtitle: Text(todos[index].category),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
