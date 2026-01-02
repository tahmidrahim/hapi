// lib/models/story_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String id;
  final String userId;
  final String mediaUrl;
  final String type;
  final int duration;
  final List<String> views;
  final DateTime expiresAt;
  final DateTime createdAt;

  StoryModel({
    required this.id,
    required this.userId,
    required this.mediaUrl,
    required this.type,
    required this.duration,
    required this.views,
    required this.expiresAt,
    required this.createdAt,
  });

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      mediaUrl: map['mediaUrl'] ?? '',
      type: map['type'] ?? 'image',
      duration: map['duration'] ?? 5,
      views: List<String>.from(map['views'] ?? []),
      expiresAt: (map['expiresAt'] ?? Timestamp.now()).toDate(),
      createdAt: (map['createdAt'] ?? Timestamp.now()).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'mediaUrl': mediaUrl,
      'type': type,
      'duration': duration,
      'views': views,
      'expiresAt': expiresAt,
      'createdAt': createdAt,
    };
  }

  bool get isImage => type == 'image';
  bool get isVideo => type == 'video';
  bool get isExpired => expiresAt.isBefore(DateTime.now());
  int get viewCount => views.length;
}
