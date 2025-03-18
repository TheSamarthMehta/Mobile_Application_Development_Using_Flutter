import 'dart:convert';
import 'package:http/http.dart' as http;

import 'user.dart';

class ApiService {
  final String baseUrl = 'https://67d24eac90e0670699bd035b.mockapi.io/api/v1/Users';

  // Create
  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    return User.fromJson(json.decode(response.body));
  }

  // Read
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    final List data = json.decode(response.body);
    return data.map((json) => User.fromJson(json)).toList();
  }

  // Update
  Future<User> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    return User.fromJson(json.decode(response.body));
  }

  // Delete
  Future<void> deleteUser(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}
