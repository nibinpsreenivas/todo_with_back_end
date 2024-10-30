import 'package:todo_with_back_end/models/todo.dart';

class Project {
  String id;
  String title;
  DateTime createdDate;
  List<Todo> todos;

  Project(
      {required this.id,
      required this.title,
      required this.createdDate,
      this.todos = const []});

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'createdDate': createdDate.toIso8601String(),
        'todos': todos.map((todo) => todo.toMap()).toList(),
      };

  static Project fromMap(Map<String, dynamic> map) => Project(
        id: map['id'],
        title: map['title'],
        createdDate: DateTime.parse(map['createdDate']),
        todos: (map['todos'] as List)
            .map((todoMap) => Todo.fromMap(todoMap))
            .toList(),
      );
}
