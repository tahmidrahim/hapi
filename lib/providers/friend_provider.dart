// lib/providers/friend_provider.dart
import 'package:flutter_riverpod/legacy.dart';

class FriendNotifier extends StateNotifier<FriendState> {
  FriendNotifier() : super(const FriendState());

  Future<void> loadFriends() async {
    state = state.copyWith(status: FriendStatus.loading);
    try {
      // Load friends logic
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(
        status: FriendStatus.success,
        friends: [], // Add actual friends data
      );
    } catch (e) {
      state = state.copyWith(status: FriendStatus.error, error: e.toString());
    }
  }

  Future<void> sendFriendRequest(String userId) async {
    try {
      // Send friend request logic
      state = state.copyWith(
        pendingRequests: [...state.pendingRequests, userId],
      );
    } catch (e) {
      rethrow;
    }
  }
}

enum FriendStatus { initial, loading, success, error }

class FriendState {
  final FriendStatus status;
  final List<String> friends;
  final List<String> pendingRequests;
  final String? error;

  const FriendState({
    this.status = FriendStatus.initial,
    this.friends = const [],
    this.pendingRequests = const [],
    this.error,
  });

  FriendState copyWith({
    FriendStatus? status,
    List<String>? friends,
    List<String>? pendingRequests,
    String? error,
  }) {
    return FriendState(
      status: status ?? this.status,
      friends: friends ?? this.friends,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      error: error ?? this.error,
    );
  }
}

final friendProvider = StateNotifierProvider<FriendNotifier, FriendState>(
  (ref) => FriendNotifier(),
);
