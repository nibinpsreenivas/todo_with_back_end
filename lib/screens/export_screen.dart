import 'package:flutter/material.dart';
import '../services/gist_service.dart';
import '../models/project.dart';
import '../models/todo.dart';

class ExportScreen extends StatelessWidget {
  final Project project;
  final GistService _gistService = GistService();

  ExportScreen({required this.project});

  String generateMarkdown() {
    final completedTodos =
        project.todos.where((todo) => todo.isCompleted).toList();
    final pendingTodos =
        project.todos.where((todo) => !todo.isCompleted).toList();

    final markdown = StringBuffer();
    markdown.writeln('# ${project.title}\n');
    markdown.writeln(
        'Summary: ${completedTodos.length} / ${project.todos.length} completed\n');
    markdown.writeln('## Pending Todos');
    for (var todo in pendingTodos) {
      markdown.writeln('- [ ] ${todo.description}');
    }
    markdown.writeln('\n## Completed Todos');
    for (var todo in completedTodos) {
      markdown.writeln('- [x] ${todo.description}');
    }
    return markdown.toString();
  }

  void _exportGist(BuildContext context) async {
    final markdownContent = generateMarkdown();
    try {
      await _gistService.createGistAndExport(project.id, markdownContent);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gist exported successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export gist: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 254, 251, 191),
      appBar: AppBar(
        title: Text('Export Project'),
        backgroundColor: Color.fromARGB(249, 253, 245, 139), // Yellow shade
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _exportGist(context),
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(248, 255, 246, 118), // Yellow shade
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Export as Gist', style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}
