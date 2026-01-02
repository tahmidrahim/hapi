// lib/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String? bio;
  final String username;
  final String profileImage;
  final String phoneNumber;
  final String gender;
  final String country;
  final DateTime? birthDate;
  final bool profileCompleted;
  final bool isOnline;
  final DateTime lastSeen;
  final String deviceToken;
  final UserSettings settings;
  final List<String> friends;
  final List<String> friendRequests;
  final List<String> blockedUsers;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.name,
    this.bio,
    required this.username,
    required this.profileImage,
    required this.phoneNumber,
    required this.gender,
    required this.country,
    required this.birthDate,
    required this.profileCompleted,
    required this.isOnline,
    required this.lastSeen,
    required this.deviceToken,
    required this.settings,
    required this.friends,
    required this.friendRequests,
    required this.blockedUsers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      bio: map['bio'],
      username: map['username'] ?? '',
      profileImage: map['profileImage'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      gender: map['gender'] ?? '',
      country: map['country'] ?? '',
      birthDate: map['birthDate']?.toDate(),
      profileCompleted: map['profileCompleted'] ?? false,
      isOnline: map['isOnline'] ?? false,
      lastSeen: (map['lastSeen'] as Timestamp?)?.toDate() ?? DateTime.now(),
      deviceToken: map['deviceToken'] ?? '',
      settings: UserSettings.fromMap(
        Map<String, dynamic>.from(map['settings'] ?? {}),
      ),
      friends: List<String>.from(map['friends'] ?? []),
      friendRequests: List<String>.from(map['friendRequests'] ?? []),
      blockedUsers: List<String>.from(map['blockedUsers'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'bio': bio,
      'username': username,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'country': country,
      'birthDate': birthDate,
      'profileCompleted': profileCompleted,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'deviceToken': deviceToken,
      'settings': settings.toMap(),
      'friends': friends,
      'friendRequests': friendRequests,
      'blockedUsers': blockedUsers,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? bio,
    String? username,
    String? profileImage,
    String? phoneNumber,
    String? gender,
    String? country,
    DateTime? birthDate,
    bool? profileCompleted,
    bool? isOnline,
    DateTime? lastSeen,
    String? deviceToken,
    UserSettings? settings,
    List<String>? friends,
    List<String>? friendRequests,
    List<String>? blockedUsers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      birthDate: birthDate ?? this.birthDate,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      deviceToken: deviceToken ?? this.deviceToken,
      settings: settings ?? this.settings,
      friends: friends ?? this.friends,
      friendRequests: friendRequests ?? this.friendRequests,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserSettings {
  final bool notifications;
  final bool darkMode;
  final String privacy;
  final bool showOnlineStatus;
  final bool showLastSeen;
  final bool allowCallsFrom;
  final bool allowMessagesFrom;

  UserSettings({
    this.notifications = true,
    this.darkMode = false,
    this.privacy = 'friends',
    this.showOnlineStatus = true,
    this.showLastSeen = true,
    this.allowCallsFrom = true,
    this.allowMessagesFrom = true,
  });

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      notifications: map['notifications'] ?? true,
      darkMode: map['darkMode'] ?? false,
      privacy: map['privacy'] ?? 'friends',
      showOnlineStatus: map['showOnlineStatus'] ?? true,
      showLastSeen: map['showLastSeen'] ?? true,
      allowCallsFrom: map['allowCallsFrom'] ?? true,
      allowMessagesFrom: map['allowMessagesFrom'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notifications': notifications,
      'darkMode': darkMode,
      'privacy': privacy,
      'showOnlineStatus': showOnlineStatus,
      'showLastSeen': showLastSeen,
      'allowCallsFrom': allowCallsFrom,
      'allowMessagesFrom': allowMessagesFrom,
    };
  }
}
