import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationProvider = StateNotifierProvider<NavigationNotifier, String>((
  ref,
) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<String> {
  NavigationNotifier() : super('/login');

  void goToCompleteProfile() {
    state = '/complete-profile';
  }

  void goToHome() {
    state = '/home';
  }
}
