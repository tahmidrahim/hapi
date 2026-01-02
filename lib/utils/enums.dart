// lib/utils/enums.dart
import 'package:flutter/material.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

enum UserStatus { online, offline, away, busy }

enum ChatType { direct, group }

enum MessageType { text, image, video, audio, file, location, contact }

enum CallType { audio, video }

enum CallStatus { ringing, accepted, rejected, ended, missed, busy }

enum PostType { text, image, video }

enum PrivacyType { public, friends, private }

enum NotificationType {
  friendRequest,
  message,
  call,
  like,
  comment,
  share,
  mention,
  storyView,
}

enum MediaSource { camera, gallery }

enum ImageQuality { low, medium, high, original }

enum ThemeMode { light, dark, system }

enum AppTab { home, discover, chat, profile }

enum ConnectionStatus { connected, disconnected, connecting }

enum UploadStatus { initial, uploading, success, error }

enum SearchFilter { all, users, groups, posts, videos }

extension AuthStatusExtension on AuthStatus {
  bool get isInitial => this == AuthStatus.initial;
  bool get isLoading => this == AuthStatus.loading;
  bool get isAuthenticated => this == AuthStatus.authenticated;
  bool get isUnauthenticated => this == AuthStatus.unauthenticated;
  bool get isError => this == AuthStatus.error;
}

extension UserStatusExtension on UserStatus {
  Color get color {
    switch (this) {
      case UserStatus.online:
        return Colors.green;
      case UserStatus.offline:
        return Colors.grey;
      case UserStatus.away:
        return Colors.orange;
      case UserStatus.busy:
        return Colors.red;
    }
  }

  String get displayName {
    switch (this) {
      case UserStatus.online:
        return 'Online';
      case UserStatus.offline:
        return 'Offline';
      case UserStatus.away:
        return 'Away';
      case UserStatus.busy:
        return 'Busy';
    }
  }
}

extension CallStatusExtension on CallStatus {
  bool get isActive =>
      this == CallStatus.ringing || this == CallStatus.accepted;
  bool get isEnded =>
      this == CallStatus.ended ||
      this == CallStatus.missed ||
      this == CallStatus.rejected;

  String get displayName {
    switch (this) {
      case CallStatus.ringing:
        return 'Ringing';
      case CallStatus.accepted:
        return 'Accepted';
      case CallStatus.rejected:
        return 'Rejected';
      case CallStatus.ended:
        return 'Ended';
      case CallStatus.missed:
        return 'Missed';
      case CallStatus.busy:
        return 'Busy';
    }
  }
}
