import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  
  AuthProvider({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null && _user!.token.isNotEmpty;

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.tokenKey);
      final userData = prefs.getString(AppConstants.userKey);

      if (token != null && userData != null) {
        final user = User.fromJson(jsonDecode(userData));
        _user = user.copyWith(token: token);
        
        // Validate token
        final isValid = await _apiService.validateToken(token);
        if (!isValid) {
          await logout();
        }
      }
    } catch (e) {
      await logout();
    }
  }

  Future<void> initialize() async {
    await _loadUserData();
    notifyListeners();
  }

  Future<void> register(String email, String password, Role role) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _apiService.register(email, password, role);
      await _saveUser(user);
      _user = user;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _apiService.login(email, password);
      await _saveUser(user);
      _user = user;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.tokenKey);
      await prefs.remove(AppConstants.userKey);
    } catch (e) {
      print('Error clearing user data: $e');
    }
    
    _user = null;
    notifyListeners();
  }

  Future<void> _saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, user.token);
      await prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}

