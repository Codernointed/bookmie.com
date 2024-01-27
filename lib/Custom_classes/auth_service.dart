// auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'https://ethenatx.pythonanywhere.com/management';
  late String _accessToken;
  late String _refreshToken;

  // Singleton pattern to ensure only one instance of AuthService
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Getter for the access token
  String get accessToken => _accessToken;

  // Check if the user is authenticated
  bool isAuthenticated() {
    return _accessToken.isNotEmpty;
  }

  // Log in and obtain access and refresh tokens
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/obtain-token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access'];
        _refreshToken = data['refresh'];
        await _saveTokensToStorage();
        return true;
      } else {
        // Handle login error
        return false;
      }
    } catch (e) {
      // Handle network or other errors
      return false;
    }
  }

  // Refresh the access token using the refresh token
  Future<bool> refreshToken() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/refresh-token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': _refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access'];
        await _saveTokensToStorage();
        return true;
      } else {
        // Handle refresh token error
        return false;
      }
    } catch (e) {
      // Handle network or other errors
      return false;
    }
  }

  // Save tokens to local storage (SharedPreferences)
  Future<void> _saveTokensToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', _accessToken);
    prefs.setString('refreshToken', _refreshToken);
  }

  // Load tokens from local storage (SharedPreferences)
  Future<void> _loadTokensFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken') ?? '';
    _refreshToken = prefs.getString('refreshToken') ?? '';
  }
  // Logout and clear tokens
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('accessToken');
    prefs.remove('refreshToken');
    _accessToken = '';
    _refreshToken = '';
    
  }

  // Initialize the AuthService
  Future<void> init() async {
    await _loadTokensFromStorage();
  }
}
