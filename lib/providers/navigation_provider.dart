import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationProvider = StateNotifierProvider<NavigationNotifier, String>((
  ref,
) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<String> {
  NavigationNotifier() : super('/login');
  void goToLogin() {
    // ← ADD THIS
    state = '/login';
  }

  void goToCompleteProfile() {
    state = '/complete-profile';
  }

  void goToHome() {
    state = '/home';
  }

  void goToEditRoomName() {
    state = '/edit-room-name';
  }

  void goToVoiceRoom({String? roomId, bool isCreating = false}) {
    state = '/voice-room?roomId=${roomId ?? ''}&isCreating=$isCreating';
  }
}
