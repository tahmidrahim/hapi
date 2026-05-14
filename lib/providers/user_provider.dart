// lib/providers/user_provider.dart
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier() : super(UserModel(name: '', gender: '', id: _generateId()));

  void updateUser(String name, String gender) {
    state = state.copyWith(name: name, gender: gender);
  }

  static String _generateId() {
    final random = Random();
    return random.nextInt(1000000).toString().padLeft(6, '0');
  }
}

class UserModel {
  final String name;
  final String gender;
  final String id;
  final String? profilePic;

  UserModel({
    required this.name,
    required this.gender,
    required this.id,
    this.profilePic,
  });

  UserModel copyWith({
    String? name,
    String? gender,
    String? id,
    String? profilePic,
  }) {
    return UserModel(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      id: id ?? this.id,
      profilePic: profilePic ?? this.profilePic,
    );
  }
}
