import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier() : super(UserModel(name: '', gender: '', id: '', email: ''));

  void updateUser({
    required String name,
    required String gender,
    String? email,
    String? photoUrl,
    String? id,
  }) {
    state = state.copyWith(
      name: name,
      gender: gender,
      email: email ?? state.email,
      photoUrl: photoUrl ?? state.photoUrl,
      id: id ?? state.id,
    );
  }
}

class UserModel {
  final String name;
  final String gender;
  final String id;
  final String email;
  final String? photoUrl;

  UserModel({
    required this.name,
    required this.gender,
    required this.id,
    required this.email,
    this.photoUrl,
  });

  UserModel copyWith({
    String? name,
    String? gender,
    String? id,
    String? email,
    String? photoUrl,
  }) {
    return UserModel(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      id: id ?? this.id,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
