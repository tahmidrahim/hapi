// lib/providers/video_provider.dart
import 'package:flutter_riverpod/legacy.dart';

class VideoNotifier extends StateNotifier<VideoState> {
  VideoNotifier() : super(const VideoState.initial());

  Future<void> startVideoCall(String userId) async {
    state = state.copyWith(status: VideoStatus.loading);
    try {
      // Start video call logic
      state = state.copyWith(
        status: VideoStatus.callStarted,
        callId: DateTime.now().millisecondsSinceEpoch.toString(),
      );
    } catch (e) {
      state = state.copyWith(status: VideoStatus.error, error: e.toString());
    }
  }

  Future<void> endCall() async {
    state = const VideoState.initial();
  }
}

enum VideoStatus { initial, loading, callStarted, error }

class VideoState {
  final VideoStatus status;
  final String? callId;
  final String? error;

  const VideoState({
    this.status = VideoStatus.initial,
    this.callId,
    this.error,
  });

  const VideoState.initial()
      : status = VideoStatus.initial,
        callId = null,
        error = null;

  VideoState copyWith({VideoStatus? status, String? callId, String? error}) {
    return VideoState(
      status: status ?? this.status,
      callId: callId ?? this.callId,
      error: error ?? this.error,
    );
  }
}

final videoProvider = StateNotifierProvider<VideoNotifier, VideoState>(
  (ref) => VideoNotifier(),
);
