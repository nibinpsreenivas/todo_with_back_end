import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class GistService {
  final String _gistApiUrl = 'https://api.github.com/gists';
  final String _accessToken = '';

  Future<void> createGistAndExport(
      String projectId, String markdownContent) async {
    // Data for the GitHub gist
    final gistData = {
      'files': {
        '$projectId.md': {'content': markdownContent},
      },
      'public': false,
    };

    // Create gist on GitHub
    final response = await http.post(
      Uri.parse(_gistApiUrl),
      headers: {
        'Authorization': 'token $_accessToken',
        'Accept': 'application/vnd.github.v3+json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(gistData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create gist: ${response.body}');
    }

    // Save the markdown content as a local file
    await _saveMarkdownLocally(projectId, markdownContent);
  }

  Future<void> _saveMarkdownLocally(String projectId, String content) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$projectId.md';
      final file = File(filePath);

      await file.writeAsString(content);
      print('File saved locally at $filePath');
    } catch (e) {
      print('Failed to save file locally: $e');
    }
  }
}
