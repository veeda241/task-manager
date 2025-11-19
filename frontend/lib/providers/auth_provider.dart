import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  User? _user;
  final ApiService _apiService = ApiService();

  String? get token => _token;
  User? get user => _user;
  bool get isAuthenticated => _token != null;

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _token = token;
    _apiService.setToken(token);
    notifyListeners();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    if (storedToken != null) {
      _token = storedToken;
      _apiService.setToken(storedToken);
    }
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = null;
    _user = null;
    _apiService.setToken('');
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    await _loadToken();
    if (!isAuthenticated) {
      return false;
    }
    try {
      await fetchUser();
      return true;
    } catch (e) {
      await logout();
      return false;
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final tokenData = await _apiService.login(username, password);
      await _saveToken(tokenData['access_token']);
      await fetchUser();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signup(String username, String email, String password) async {
    try {
      await _apiService.register(username, email, password);
      await login(username, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchUser() async {
    try {
      _user = await _apiService.getMe();
      notifyListeners();
    } catch (e) {
      await logout();
      rethrow;
    }
  }

  Future<void> logout() async {
    await _removeToken();
  }
}