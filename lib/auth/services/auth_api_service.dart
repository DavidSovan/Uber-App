import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_taxi/Api/api_config.dart';

class ApiService {
  // Base URL for the API

  // SharedPreferences keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // HTTP headers
  static Map<String, String> _headers({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Get SharedPreferences instance
  static Future<SharedPreferences> getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  // Sign in user
  static Future<Map<String, dynamic>> signIn(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: _headers(),
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Save token and user data
        final prefs = await getPreferences();
        await prefs.setString(tokenKey, responseData['data']['token']);
        await prefs.setString(
          userKey,
          jsonEncode(responseData['data']['user']),
        );
        return responseData['data'];
      } else {
        throw Exception(responseData['message'] ?? 'Failed to sign in');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Sign up user
  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String userType,
    String? phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.signup),
        headers: _headers(),
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'user_type': userType,
          if (phoneNumber != null && phoneNumber.isNotEmpty)
            'phone_number': phoneNumber,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Save token and user data
        final prefs = await getPreferences();
        await prefs.setString(tokenKey, responseData['data']['token']);
        await prefs.setString(
          userKey,
          jsonEncode(responseData['data']['user']),
        );
        return responseData['data'];
      } else {
        throw Exception(responseData['message'] ?? 'Failed to sign up');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Sign out user
  static Future<bool> signOut() async {
    try {
      final prefs = await getPreferences();
      final token = prefs.getString(tokenKey);

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.post(
        Uri.parse(ApiConfig.logout),
        headers: _headers(token: token),
      );

      if (response.statusCode == 200) {
        // Clear token and user data
        await prefs.remove(tokenKey);
        await prefs.remove(userKey);
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message'] ?? 'Failed to sign out');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get current user
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await getPreferences();
    final userData = prefs.getString(userKey);

    if (userData == null) {
      return null;
    }

    return jsonDecode(userData);
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final prefs = await getPreferences();
    return prefs.getString(tokenKey) != null;
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await getPreferences();
    return prefs.getString(tokenKey);
  }

  // Check user role
  static Future<String?> getUserRole() async {
    final user = await getCurrentUser();
    if (user != null) {
      return user['role'];
    }
    return null;
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    String? phoneNumber,
  }) async {
    try {
      final token = await getToken();

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.put(
        Uri.parse(ApiConfig.updateProfile),
        headers: _headers(token: token),
        body: jsonEncode({
          'name': name,
          if (phoneNumber != null && phoneNumber.isNotEmpty)
            'phone_number': phoneNumber,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Update stored user data
        final prefs = await getPreferences();
        await prefs.setString(userKey, jsonEncode(responseData['data']));
        return responseData['data'];
      } else {
        throw Exception(responseData['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Request password reset
  static Future<bool> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.forgotpassword),
        headers: _headers(),
        body: jsonEncode({'email': email}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
