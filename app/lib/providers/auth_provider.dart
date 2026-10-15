import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> loadUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString('user');
      String? token = prefs.getString('token');
      if (userData != null && token != null) {
        final decoded = jsonDecode(userData);
        // Ensure token is always present in the decoded map
        if (decoded['token'] == null || decoded['token'].toString().isEmpty) {
          decoded['token'] = token;
        }
        _user = UserModel.fromJson(decoded);
        notifyListeners();
      }
    } catch (e) {
      // Clear corrupted data and force re-login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user');
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    _user = await ApiService.login(email, password);

    _isLoading = false;
    notifyListeners();
    return _user != null;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    _user = null;
    notifyListeners();
  }
}
