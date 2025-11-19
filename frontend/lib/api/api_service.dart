import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_veeda/models/user.dart';
import 'package:task_manager_veeda/models/task.dart';
import 'package:task_manager_veeda/models/task_create.dart';
import 'package:task_manager_veeda/models/task_update.dart';

class ApiService {
  final String apiBaseUrl = 'http://127.0.0.1:8000/api/v1';
  String _token = '';

  void setToken(String token) {
    _token = token;
  }

  Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      if (_token.isNotEmpty) 'Authorization': 'Bearer $_token',
    };
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      final errorBody = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('API Error (${response.statusCode}): ${errorBody['detail']}');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$apiBaseUrl/token');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': username, 'password': password},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorBody = json.decode(response.body);
      throw Exception('Failed to login: ${errorBody['detail']}');
    }
  }

  Future<User> register(String username, String email, String password) async {
    final url = Uri.parse('$apiBaseUrl/users/');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    final responseData = _handleResponse(response);
    return User.fromJson(responseData);
  }

  Future<User> getMe() async {
    final url = Uri.parse('$apiBaseUrl/users/me');
    final response = await http.get(url, headers: await _getHeaders());
    final responseData = _handleResponse(response);
    return User.fromJson(responseData);
  }

  Future<List<Task>> getTasks() async {
    final url = Uri.parse('$apiBaseUrl/tasks/');
    final response = await http.get(url, headers: await _getHeaders());
    final responseData = _handleResponse(response) as List;
    return responseData.map((task) => Task.fromJson(task)).toList();
  }

  Future<Task> createTask(TaskCreate task) async {
    final url = Uri.parse('$apiBaseUrl/tasks/');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: json.encode(task.toJson()),
    );
    final responseData = _handleResponse(response);
    return Task.fromJson(responseData);
  }

  Future<Task> updateTask(int taskId, TaskUpdate task) async {
    final url = Uri.parse('$apiBaseUrl/tasks/$taskId');
    final response = await http.put(
      url,
      headers: await _getHeaders(),
      body: json.encode(task.toJson()),
    );
    final responseData = _handleResponse(response);
    return Task.fromJson(responseData);
  }

  Future<void> deleteTask(int taskId) async {
    final url = Uri.parse('$apiBaseUrl/tasks/$taskId');
    final response = await http.delete(url, headers: await _getHeaders());
    _handleResponse(response);
  }
}