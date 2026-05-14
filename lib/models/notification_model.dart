// lib/models/notification_model.dart
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final int badge;
  final String? iconUrl;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.badge,
    this.iconUrl,
  });
}

// lib/models/message_model.dart
class MessageModel {
  final String id;
  final String senderName;
  final String senderAvatar;
  final String message;
  final String time;
  final int unreadCount;

  MessageModel({
    required this.id,
    required this.senderName,
    required this.senderAvatar,
    required this.message,
    required this.time,
    required this.unreadCount,
  });
}
