// lib/services/api/user_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';

class UserApi {
  static final String _baseUrl = AppConstants.baseUrl;

  static Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  static Future<List<dynamic>> getRecommendedFriends() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/recommended'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recommended friends');
    }
  }

  static Future<void> updateProfile(Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/users/profile'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  static Future<List<dynamic>> searchUsers(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/search?q=$query'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to search users');
    }
  }
}
