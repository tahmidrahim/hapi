// lib/services/api/chat_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';

class ChatApi {
  static final String _baseUrl = AppConstants.baseUrl;

  static Future<List<dynamic>> getChats() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/chats'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load chats');
    }
  }

  static Future<List<dynamic>> getMessages(String chatId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/chats/$chatId/messages'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  static Future<void> sendMessage({
    required String chatId,
    required String text,
    String? mediaUrl,
    String type = 'text',
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/chats/$chatId/messages'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'text': text, 'mediaUrl': mediaUrl, 'type': type}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }

  static Future<void> markAsRead(String messageId) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/messages/$messageId/read'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark as read');
    }
  }
}
