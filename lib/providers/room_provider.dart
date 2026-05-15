import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomProvider = StateNotifierProvider<RoomNotifier, RoomState>((ref) {
  return RoomNotifier();
});

class RoomState {
  final List<String> participants;
  final int participantCount;

  RoomState({this.participants = const [], this.participantCount = 1});

  RoomState copyWith({List<String>? participants, int? participantCount}) {
    return RoomState(
      participants: participants ?? this.participants,
      participantCount: participantCount ?? this.participantCount,
    );
  }
}

class RoomNotifier extends StateNotifier<RoomState> {
  RoomNotifier() : super(RoomState());

  void addParticipant(String userId) {
    final newList = List<String>.from(state.participants)..add(userId);
    state = state.copyWith(
      participants: newList,
      participantCount: newList.length + 1,
    );
  }

  void removeParticipant(String userId) {
    final newList = List<String>.from(state.participants)..remove(userId);
    state = state.copyWith(
      participants: newList,
      participantCount: newList.length + 1,
    );
  }
}
