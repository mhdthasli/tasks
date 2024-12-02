import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart';

class AuthViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  String? _token;

  String? get token => _token;

  // Login method
  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);

      if (response['token'] != null && response['token'].isNotEmpty) {
        _token = response['token'];

        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);

        // Notify listeners only after setting the token
        notifyListeners();
      } else {
        throw Exception('Token is missing from the response');
      }
    } catch (error) {
      throw Exception('Login failed: $error');
    }
  }

  // Load token from SharedPreferences
  Future<void> loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to load token: $error');
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token'); // Remove token from SharedPreferences
      _token = null; // Set token to null
      notifyListeners();
    } catch (error) {
      throw Exception('Logout failed: $error');
    }
  }
}
