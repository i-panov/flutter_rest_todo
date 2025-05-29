import 'package:flutter/material.dart';
import 'package:flutter_rest_todo/create_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final todos = ref.watch(filteredTodosProvider);

    return Scaffold(
      appBar: AppBar(title: Text('ToDo')),
      body: Column(
        children: [
          categoriesAsync.when(
            data: (categories) {
              return DropdownButton<String>(
                value: selectedCategory,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('(all)'),
                  ),
                  
                  for (final category in categories)
                    DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                ],
                onChanged: (value) {
                  ref
                      .read(selectedCategoryProvider.notifier)
                      .update((_) => value);
                },
              );
            },
            loading: () => CircularProgressIndicator(),
            error: (err, stack) => Text('Ошибка загрузки категорий'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final item = todos[index];
                return ListTile(title: Text(item.title));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
