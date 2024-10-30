import 'package:flutter/material.dart';
import 'package:todo_with_back_end/screens/export_screen.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart'; // Import AuthService for logout
import 'project_screen.dart';
import '../models/project.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService(); // Initialize AuthService

  Future<void> _createProject() async {
    String? projectName = await _showProjectNameDialog();

    if (projectName != null && projectName.isNotEmpty) {
      final project = Project(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: projectName,
        createdDate: DateTime.now(),
      );
      await _firestoreService.createProject(project);
      setState(() {}); // Refresh the UI to show the new project
    }
  }

  Future<String?> _showProjectNameDialog() async {
    String? projectName;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Project Name'),
          content: TextField(
            onChanged: (value) {
              projectName = value;
            },
            decoration: InputDecoration(hintText: "Project Name"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(projectName);
              },
              child: Text('Create'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without creating
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
    return projectName; // Return the project name entered
  }

  Future<void> _deleteProject(String projectId) async {
    await _firestoreService.deleteProject(projectId);
    setState(() {}); // Refresh the UI after deletion
  }

  Future<void> _logout() async {
    await _authService.logout(); // Call logout from AuthService
    Navigator.pushReplacementNamed(
        context, '/login'); // Navigate to login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 254, 251, 191),
      appBar: AppBar(
        elevation: 0,
        title: Text('TODO'),
        centerTitle: false,
        backgroundColor: Color.fromARGB(249, 253, 245, 139),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<List<Project>>(
        future: _firestoreService.getProjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final projects = snapshot.data ?? [];
          return ListView.builder(
            padding: EdgeInsets.all(12.0),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Dismissible(
                key: Key(project.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(right: 16),
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  _deleteProject(project.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${project.title} deleted')),
                  );
                },
                child: Card(
                  color: Color.fromARGB(248, 255, 246, 118),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      project.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteProject(project.id),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectScreen(project: project),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createProject,
        backgroundColor: Color.fromARGB(248, 255, 246, 118),
        child: Icon(Icons.add),
      ),
    );
  }
}
