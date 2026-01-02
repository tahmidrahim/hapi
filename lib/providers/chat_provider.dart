// lib/app/router.dart - UPDATED
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hapi/screens/create/create_post__screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/complete_profile_screen.dart';
import '../screens/auth/country_picker_screen.dart';
import '../screens/auth/recommended_friends_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/discover_screen.dart';
import '../screens/home/friends_screen.dart';
import '../screens/home/chat_screen.dart';
import '../screens/home/profile_screen.dart';
import '../screens/video/video_call_screen.dart';
import '../screens/video/group_call_screen.dart';
import '../screens/video/live_stream_screen.dart';
import '../screens/video/video_recorder_screen.dart';
import '../screens/create/create_story_screen.dart';
import '../screens/create/create_room_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/complete-profile',
        name: 'complete-profile',
        builder: (context, state) => const CompleteProfileScreen(),
      ),
      GoRoute(
        path: '/country-picker',
        name: 'country-picker',
        builder: (context, state) => const CountryPickerScreen(),
      ),
      GoRoute(
        path: '/recommended-friends',
        name: 'recommended-friends',
        builder: (context, state) => const RecommendedFriendsScreen(),
      ),

      // Home routes
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/discover',
        name: 'discover',
        builder: (context, state) => const DiscoverScreen(),
      ),
      GoRoute(
        path: '/friends',
        name: 'friends',
        builder: (context, state) => const FriendsScreen(),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return ChatScreen(
            userId: args['userId'] ?? '',
            userName: args['userName'] ?? 'User',
            userImage: args['userImage'],
          );
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) {
          final userId = state.extra as String?;
          return ProfileScreen(userId: userId);
        },
      ),

      // Video routes
      GoRoute(
        path: '/video-call',
        name: 'video-call',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return VideoCallScreen(
            userId: args['userId'] ?? '',
            userName: args['userName'] ?? 'User',
            userImage: args['userImage'],
            isVideoCall: args['isVideo'] ?? true,
          );
        },
      ),
      GoRoute(
        path: '/group-call',
        name: 'group-call',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return GroupCallScreen(
            roomId: args['roomId'],
            participantIds: args['participantIds'] ?? [],
          );
        },
      ),
      GoRoute(
        path: '/live-stream',
        name: 'live-stream',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return LiveStreamScreen(
            streamId: args['streamId'] ?? '',
            isHost: args['isHost'] ?? false,
          );
        },
      ),
      GoRoute(
        path: '/video-recorder',
        name: 'video-recorder',
        builder: (context, state) => const VideoRecorderScreen(),
      ),

      // Create routes
      GoRoute(
        path: '/create-post',
        name: 'create-post',
        builder: (context, state) => const CreatePostScreen(),
      ),
      GoRoute(
        path: '/create-story',
        name: 'create-story',
        builder: (context, state) => const CreateStoryScreen(),
      ),
      GoRoute(
        path: '/create-room',
        name: 'create-room',
        builder: (context, state) => const CreateRoomScreen(),
      ),
    ],
    redirect: (context, state) {
      // Add auth logic here
      return null;
    },
  );
});
