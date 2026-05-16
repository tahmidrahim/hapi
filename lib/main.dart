import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hapi/firebase_options.dart';
import 'package:hapi/providers/navigation_provider.dart';
import 'package:hapi/providers/user_provider.dart';
import 'package:hapi/screens/auth/auth_screen.dart';
import 'package:hapi/screens/auth/complete_profile_screen.dart';
import 'package:hapi/screens/call/edit_room_name_dialog.dart';
import 'package:hapi/screens/home/home_screen.dart';
import 'package:hapi/screens/call/voice_room_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(navigationProvider);
    final user = ref.watch(userProvider);

    return MaterialApp(
      title: 'Hapi',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: _getScreen(route, user),
    );
  }

  Widget _getScreen(String route, UserModel user) {
    // Handle edit room name route
    if (route == '/edit-room-name') {
      return const EditRoomNameScreen();
    }

    // Handle voice-room routes
    if (route.startsWith('/voice-room')) {
      final uri = Uri.parse(route);
      final roomId = uri.queryParameters['roomId'] ?? '';
      final isCreating = uri.queryParameters['isCreating'] == 'true';
      return VoiceRoomScreen(roomId: roomId, isCreating: isCreating);
    }

    // Check if profile is complete before going to home
    if (route == '/home' && (user.gender.isEmpty || user.name.isEmpty)) {
      return const CompleteProfileScreen();
    }

    switch (route) {
      case '/login':
        return AuthScreen();
      case '/complete-profile':
        return const CompleteProfileScreen();
      case '/home':
        return const HomeScreen();
      default:
        return AuthScreen();
    }
  }
}
