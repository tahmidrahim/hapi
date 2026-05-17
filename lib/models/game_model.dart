import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// Model for the Game data
class GameModel {
  final int id;
  final String name;
  final String curl;
  GameModel({required this.id, required this.name, required this.curl});

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(id: json['id'], name: json['name'], curl: json['curl']);
  }
}

final gamesFutureProvider = FutureProvider<List<GameModel>>((ref) async {
  // Ensure the token is in the path if that's how the GET works
  final response = await http.get(
    Uri.parse("https://funint.site/api/games/187871878"),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> body = jsonDecode(response.body);
    if (body['status'] == true) {
      final List data = body['data'];
      return data.map((g) => GameModel.fromJson(g)).toList();
    }
  }
  throw Exception("Failed to load games list");
});
