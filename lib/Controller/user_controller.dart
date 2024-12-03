import 'dart:convert';

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart'as http;

class UserController extends GetxController {
  var users = <Map<String, dynamic>>[].obs;
  var isFirstLogin = false.obs;
  var isLoading = false.obs;

  Future<Database> _initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_data.db');
    return openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, username TEXT, email TEXT)',
      );
    });
  }

  Future<void> fetchUsersFromApi() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        users.value = List<Map<String, dynamic>>.from(data);
        _saveUsersToDatabase(users.value);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }


  Future<void> _saveUsersToDatabase(List<Map<String, dynamic>> usersList) async {
    final db = await _initializeDatabase();
    for (var user in usersList) {
      await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> loadUsersFromDatabase() async {
    final db = await _initializeDatabase();
    final List<Map<String, dynamic>> dbUsers = await db.query('users');
    users.value = dbUsers;
  }

  void checkFirstLogin() {
    isFirstLogin(true);
  }
}
