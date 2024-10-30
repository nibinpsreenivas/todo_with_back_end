import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_with_back_end/models/project.dart';
import 'package:todo_with_back_end/models/todo.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createProject(Project project) async {
    await _db.collection('projects').doc(project.id).set(project.toMap());
  }

  Future<List<Project>> getProjects() async {
    final snapshot = await _db.collection('projects').get();
    return snapshot.docs.map((doc) => Project.fromMap(doc.data())).toList();
  }

  Future<void> addTodoToProject(String projectId, Todo todo) async {
    await _db.collection('projects').doc(projectId).update({
      'todos': FieldValue.arrayUnion([todo.toMap()])
    });
  }

  Future<void> deleteProject(String projectId) async {
    await _db.collection('projects').doc(projectId).delete();
  }

  Future<void> toggleTodoStatus(String projectId, Todo todo) async {
    // Retrieve current todos
    final projectDoc = await _db.collection('projects').doc(projectId).get();
    final projectData = projectDoc.data();
    if (projectData == null) return;

    // Update the specific todo status
    List<Todo> todos = (projectData['todos'] as List<dynamic>)
        .map((item) => Todo.fromMap(item))
        .toList();
    int index = todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      todos[index].toggleStatus();

      // Update Firestore with the new todos array
      await _db.collection('projects').doc(projectId).update({
        'todos': todos.map((t) => t.toMap()).toList(),
      });
    }
  }

  Future<void> deleteTodoFromProject(String projectId, Todo todo) async {
    // Retrieve current todos
    final projectDoc = await _db.collection('projects').doc(projectId).get();
    final projectData = projectDoc.data();
    if (projectData == null) return;

    // Remove the specified todo
    List<Todo> todos = (projectData['todos'] as List<dynamic>)
        .map((item) => Todo.fromMap(item))
        .toList();
    todos.removeWhere((t) => t.id == todo.id);

    // Update Firestore with the new todos array
    await _db.collection('projects').doc(projectId).update({
      'todos': todos.map((t) => t.toMap()).toList(),
    });
  }
}
