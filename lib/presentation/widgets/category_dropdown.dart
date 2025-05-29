import 'package:flutter/material.dart';
import 'package:flutter_rest_todo/presentation/providers/todo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryDropdown extends ConsumerWidget {
  const CategoryDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return categoriesAsync.when(
      data: (categories) {
        return DropdownButton<String>(
          value: selectedCategory,
          items: [
            DropdownMenuItem(
              value: null,
              child: Text('Все категории'),
            ),
            for (final category in categories)
              DropdownMenuItem(
                value: category,
                child: Text(category),
              ),
          ],
          onChanged: (value) {
            ref.read(selectedCategoryProvider.notifier).update((_) => value);
          },
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Ошибка загрузки категорий'),
    );
  }
}
