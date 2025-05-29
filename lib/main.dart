import 'package:flutter/material.dart';
import 'package:flutter_rest_todo/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: ToDoApp()));
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'ToDo App', home: MainScreen());
  }
}
