// lib/models/chat_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final List<String> participants;
  final String type;
  final String lastMessage;
  final DateTime lastMessageTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  ChatModel({
    required this.id,
    required this.participants,
    required this.type,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      type: map['type'] ?? 'direct',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] ?? Timestamp.now()).toDate(),
      createdAt: (map['createdAt'] ?? Timestamp.now()).toDate(),
      updatedAt: (map['updatedAt'] ?? Timestamp.now()).toDate(),
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participants': participants,
      'type': type,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final String mediaUrl;
  final String type;
  final List<String> readBy;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.mediaUrl,
    required this.type,
    required this.readBy,
    required this.createdAt,
    this.metadata,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      mediaUrl: map['mediaUrl'] ?? '',
      type: map['type'] ?? 'text',
      readBy: List<String>.from(map['readBy'] ?? []),
      createdAt: (map['createdAt'] ?? Timestamp.now()).toDate(),
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'mediaUrl': mediaUrl,
      'type': type,
      'readBy': readBy,
      'createdAt': createdAt,
      if (metadata != null) 'metadata': metadata,
    };
  }

  bool get isText => type == 'text';
  bool get isImage => type == 'image';
  bool get isVideo => type == 'video';
  bool get isAudio => type == 'audio';
  bool get isRead => readBy.length > 1;
}
