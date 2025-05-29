import 'package:equatable/equatable.dart';

class TodoItem extends Equatable {
  final String title;
  final String description;
  final String category;

  const TodoItem({
    required this.title,
    required this.description,
    required this.category,
  });

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [title, description, category];
}
