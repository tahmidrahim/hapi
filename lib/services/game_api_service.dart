import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hapi/models/game_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class GameApiService {
  static const String _baseUrl = "https://funint.site/api";

  // 1. GET /games
  Future<List<GameModel>> fetchGames() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/games/187871878"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == true) {
          List<dynamic> data = body['data'];
          return data.map((json) => GameModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint("Fetch Games Error: $e");
      return [];
    }
  }

  // 2. POST /user-integration
  Future<bool> integrateUser({
    required String userId,
    required String username,
    required String avatar,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/user-integration"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          // FORCE THESE TO MATCH YOUR POSTMAN SCREENSHOT
          "token": 187871878, // Int, not String
          "userid": int.tryParse(userId) ?? 2, // Must be Int
          "username": username,
          "avater": avatar.isEmpty ? "https://comapany.com/path" : avatar,
          "balance": 500, // Int
        }),
      );

      print("Handshake Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['status'] == true;
      }
      return false;
    } catch (e) {
      debugPrint("Integration Error: $e");
      return false;
    }
  }
}

final gameApiServiceProvider = Provider((ref) => GameApiService());
