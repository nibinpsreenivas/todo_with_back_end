import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add intl package for date formatting
import 'package:todo_with_back_end/screens/export_screen.dart';
import '../models/project.dart';
import '../models/todo.dart';
import '../services/firestore_service.dart';

class ProjectScreen extends StatefulWidget {
  final Project project;

  ProjectScreen({required this.project});

  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _todoController = TextEditingController();

  void _addTodo() async {
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: _todoController.text,
      createdDate: DateTime.now(),
    );
    await _firestoreService.addTodoToProject(widget.project.id, todo);
    setState(() {
      widget.project.todos.add(todo);
    });
    _todoController.clear();
  }

  void _toggleTodoStatus(Todo todo) {
    setState(() {
      todo.isCompleted = !todo.isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 254, 251, 191),
      appBar: AppBar(
        title: Text(widget.project.title),
        backgroundColor: Color.fromARGB(249, 253, 245, 139), // Yellow shade
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _todoController,
              decoration: InputDecoration(
                labelText: 'New Todo',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromARGB(248, 255, 246, 118),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTodo,
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(248, 255, 246, 118), // Yellow shade
              ),
              child: Text('Add Todo'),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.project.todos.length,
                itemBuilder: (context, index) {
                  final todo = widget.project.todos[index];
                  final formattedDate = DateFormat('yyyy-MM-dd – kk:mm')
                      .format(todo.createdDate); // Format the date

                  return Card(
                    color: Color.fromARGB(248, 255, 246, 118),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todo.description,
                            style: TextStyle(
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Created on: $formattedDate',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      trailing: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) => _toggleTodoStatus(todo),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: IconButton(
        icon: Image.asset(
          'lib/assets/github_logo.png', // Make sure to add a GitHub logo image in your assets folder
          width: 74,
          height: 74,
        ),
        onPressed: () {
          // Navigate to ExportScreen, passing the project
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExportScreen(project: widget.project),
            ),
          );
        },
      ),
    );
  }
}
