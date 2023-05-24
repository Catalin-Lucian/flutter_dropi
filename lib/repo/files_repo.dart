import 'dart:convert';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_dropi/models/file.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

List<FileSystem> files = [];

class FilesRepo {
  final jsonHeaders = {
    'accept': 'application/json',
    'Content-Type': 'application/json-patch+json',
  };

  Future<FileSystem> getRoot() async {
    final response = await http.get(
      Uri.parse('$baseUrl/root'),
      headers: jsonHeaders,
    );

    if (response.statusCode == 200) {
      return FileSystem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load root folder');
    }
  }

  Future<List<FileSystem>> getContent(int folder_id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/folder/$folder_id/files'),
      headers: jsonHeaders,
    );

    if (response.statusCode == 200) {
      var content = json.decode(response.body) as List;
      return content.map((e) => FileSystem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load folder content');
    }
  }

  Future<FileSystem> getFileSystem(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/filesystem/$id'),
      headers: jsonHeaders,
    );

    if (response.statusCode == 200) {
      return FileSystem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load root folder');
    }
  }

  Future<void> deleteFile(FileSystem file) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/filesystem/${file.id}'),
      headers: jsonHeaders,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete file');
    }
  }

  Future<FileSystem> addFolder(int parentId, String folderName) async {
    return http
        .post(
      Uri.parse('$baseUrl/folder'),
      headers: jsonHeaders,
      body: jsonEncode(
        {
          'name': folderName,
          'is_file': false,
          'parent_id': parentId,
        },
      ),
    )
        .then((response) {
      if (response.statusCode == 201) {
        return FileSystem.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add folder');
      }
    });
  }

  Future<void> addFiles(int folder_id, Map<String, XFile> files) async {
    // read file and sent it to server
    files.forEach((key, value) async {
      final bytes = await value.readAsBytes();
      final response = await http.post(
        Uri.parse('$baseUrl/file'),
        headers: jsonHeaders,
        body: jsonEncode(
          {
            'name': key,
            'is_file': true,
            'parent_id': folder_id,
            'file': base64Encode(bytes),
            'created_at': DateTime.now().toString(),
          },
        ),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to add file $key');
      }
    });
  }

  Future<Uint8List> downloadFile(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/file/$id/content'),
      headers: jsonHeaders,
    );

    if (response.statusCode == 200) {
      return base64Decode(json.decode(response.body)['file']);
    } else {
      throw Exception('Failed to download file');
    }
  }
}
