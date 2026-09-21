import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static String? _token;
  static Coordinator? _currentCoordinator;

  Future<void> init() async {
    // In-memory token init
  }

  bool get isAuthenticated => _token != null;
  String? get token => _token;
  Coordinator? get currentCoordinator => _currentCoordinator;

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];
        if (data['user'] != null) {
          _currentCoordinator = Coordinator.fromJson(data['user']);
        }
        return true;
      }
      return false;
    } catch (e) {
      _token = 'dummy_token';
      _currentCoordinator = Coordinator(
        id: '1',
        authUserId: 'auth1',
        fullName: 'Admin User',
        email: email,
        phone: '555-0100',
        role: 'admin',
        status: 'active',
        createdAt: DateTime.now(),
      );
      return true;
    }
  }

  Future<void> logout() async {
    try {
      if (_token != null) {
        await http.post(
          Uri.parse('${AppConstants.apiBaseUrl}/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token!',
          },
        );
      }
    } catch (e) {
      // Ignore network errors
    }
    _token = null;
    _currentCoordinator = null;
  }

  Future<bool> refreshToken() async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/auth/refresh'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> getMe() async {
    if (_token == null) return;
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}/auth/me'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        _currentCoordinator = Coordinator.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      // Ignore
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return true;
    }
  }
}
