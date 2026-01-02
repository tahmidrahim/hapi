// lib/models/post_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String text;
  final List<String> mediaUrls;
  final String type;
  final List<String> likes;
  final int comments;
  final int shares;
  final String privacy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? location;

  PostModel({
    required this.id,
    required this.userId,
    required this.text,
    required this.mediaUrls,
    required this.type,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.privacy,
    required this.createdAt,
    required this.updatedAt,
    this.location,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      text: map['text'] ?? '',
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      type: map['type'] ?? 'text',
      likes: List<String>.from(map['likes'] ?? []),
      comments: map['comments'] ?? 0,
      shares: map['shares'] ?? 0,
      privacy: map['privacy'] ?? 'public',
      createdAt: (map['createdAt'] ?? Timestamp.now()).toDate(),
      updatedAt: (map['updatedAt'] ?? Timestamp.now()).toDate(),
      location: map['location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'text': text,
      'mediaUrls': mediaUrls,
      'type': type,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'privacy': privacy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (location != null) 'location': location,
    };
  }

  bool get hasMedia => mediaUrls.isNotEmpty;
  bool get isTextOnly => type == 'text' && mediaUrls.isEmpty;
  bool get hasImage => type == 'image';
  bool get hasVideo => type == 'video';
  int get likeCount => likes.length;
}

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String text;
  final List<String> likes;
  final DateTime createdAt;
  final List<CommentModel>? replies;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.text,
    required this.likes,
    required this.createdAt,
    this.replies,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      text: map['text'] ?? '',
      likes: List<String>.from(map['likes'] ?? []),
      createdAt: (map['createdAt'] ?? Timestamp.now()).toDate(),
      replies: map['replies'] != null
          ? List<CommentModel>.from(
              map['replies'].map((x) => CommentModel.fromMap(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'text': text,
      'likes': likes,
      'createdAt': createdAt,
      if (replies != null)
        'replies': List<dynamic>.from(replies!.map((x) => x.toMap())),
    };
  }
}
