import 'package:flutter/material.dart';
import 'package:flutter_rest_todo/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

class CreateScreen extends ConsumerStatefulWidget {
  const CreateScreen({super.key});

  @override
  ConsumerState<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends ConsumerState<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '', description = '', category = '';

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).value?.toList() ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('Новая задача')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Название'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Введите название' : null,
                onSaved: (value) => title = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Описание'),
                onSaved: (value) => description = value!,
              ),
              DropdownButtonFormField<String>(
                value: category.isNotEmpty ? category : null,
                items: categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) {},
                validator: (value) =>
                    value == null ? 'Выберите категорию' : null,
                onSaved: (value) => category = value!,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      final item = TodoItem(
                        title: title,
                        description: description,
                        category: category,
                      );
                      await ref.read(todoListProvider.notifier).addTodo(item);

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ошибка сохранения')),
                        );
                      }
                    }
                  }
                },
                child: Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
