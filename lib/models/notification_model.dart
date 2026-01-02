// lib/models/notification_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String body;
  final NotificationData data;
  final bool read;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      type: map['type'] ?? 'general',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      data: NotificationData.fromMap(map['data'] ?? {}),
      read: map['read'] ?? false,
      createdAt: (map['createdAt'] ?? Timestamp.now()).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'body': body,
      'data': data.toMap(),
      'read': read,
      'createdAt': createdAt,
    };
  }
}

class NotificationData {
  final String senderId;
  final String senderName;
  final String senderImage;
  final String? chatId;
  final String? callId;
  final String? postId;
  final String? storyId;
  final Map<String, dynamic>? extra;

  NotificationData({
    required this.senderId,
    required this.senderName,
    required this.senderImage,
    this.chatId,
    this.callId,
    this.postId,
    this.storyId,
    this.extra,
  });

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderImage: map['senderImage'] ?? '',
      chatId: map['chatId'],
      callId: map['callId'],
      postId: map['postId'],
      storyId: map['storyId'],
      extra: map['extra'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'senderImage': senderImage,
      'chatId': chatId,
      'callId': callId,
      'postId': postId,
      'storyId': storyId,
      if (extra != null) 'extra': extra,
    };
  }
}
