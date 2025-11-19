import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/task.dart';
import '../models/task_create.dart';
import '../models/task_update.dart';
import './auth_provider.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final ApiService _apiService = ApiService();
  AuthProvider? authProvider;

  List<Task> get tasks => _tasks;

  void update(AuthProvider auth) {
    authProvider = auth;
    if (authProvider!.isAuthenticated) {
      _apiService.setToken(authProvider!.token!);
      fetchTasks();
    } else {
      _tasks = [];
      notifyListeners();
    }
  }

  Future<void> fetchTasks() async {
    try {
      _tasks = await _apiService.getTasks();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTask(String title, String description) async {
    try {
      final newTask = await _apiService.createTask(TaskCreate(title: title, description: description));
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTask(int id, String title, String description, bool isCompleted) async {
    try {
      final updatedTask = await _apiService.updateTask(id, TaskUpdate(title: title, description: description, is_completed: isCompleted));
      final taskIndex = _tasks.indexWhere((task) => task.id == id);
      if (taskIndex != -1) {
        _tasks[taskIndex] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _apiService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}