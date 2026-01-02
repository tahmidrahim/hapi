// lib/providers/user_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hapi/providers/auth_provider.dart';
import '../models/user_model.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState.initial());

  Future<void> fetchUser(String userId) async {
    try {
      state = state.copyWith(status: UserStatus.loading);

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        final user = UserModel.fromMap(snapshot.data()!);
        state = state.copyWith(status: UserStatus.success, user: user);
      } else {
        state = state.copyWith(
          status: UserStatus.error,
          error: 'User not found',
        );
      }
    } catch (e) {
      state = state.copyWith(status: UserStatus.error, error: e.toString());
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    try {
      state = state.copyWith(status: UserStatus.loading);

      final userId = state.user!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(updates);

      final updatedUser = state.user!.copyWith(
        name: updates['name'] ?? state.user!.name,
        bio: updates['bio'] ?? state.user!.bio,
        // Add other fields as needed
      );

      state = state.copyWith(status: UserStatus.success, user: updatedUser);
    } catch (e) {
      state = state.copyWith(status: UserStatus.error, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

enum UserStatus { initial, loading, success, error }

class UserState {
  final UserStatus status;
  final UserModel? user;
  final String? error;

  const UserState({this.status = UserStatus.initial, this.user, this.error});

  const UserState.initial()
      : status = UserStatus.initial,
        user = null,
        error = null;

  UserState copyWith({UserStatus? status, UserModel? user, String? error}) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  bool get isLoading => status == UserStatus.loading;
  bool get isSuccess => status == UserStatus.success;
  bool get hasError => error != null;
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>(
  (ref) => UserNotifier(),
);

// Current user provider
final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authProvider);
  final userState = ref.watch(userProvider);

  if (authState.isAuthenticated && userState.isSuccess) {
    return userState.user;
  }
  return null;
});
