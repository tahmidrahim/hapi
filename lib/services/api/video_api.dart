// lib/services/api/video_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';

class VideoApi {
  static final String _baseUrl = AppConstants.baseUrl;

  static Future<String> generateAgoraToken(String channelName) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/video/token'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'channelName': channelName}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token'];
    } else {
      throw Exception('Failed to generate token');
    }
  }

  static Future<String> startLiveStream(String title) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/video/live/start'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['streamId'];
    } else {
      throw Exception('Failed to start live stream');
    }
  }

  static Future<void> endLiveStream(String streamId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/video/live/end'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'streamId': streamId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to end live stream');
    }
  }

  static Future<List<dynamic>> getLiveStreams() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/video/live'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load live streams');
    }
  }
}
