// lib/utils/constants.dart
import 'dart:ui';

class AppConstants {
  // App Info
  static const String appName = 'Kapi Hapi';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String friendsCollection = 'friends';
  static const String chatsCollection = 'chats';
  static const String callsCollection = 'calls';
  static const String postsCollection = 'posts';
  static const String storiesCollection = 'stories';
  static const String notificationsCollection = 'notifications';

  // Storage Paths
  static const String profilePicturesPath = 'profile_pictures';
  static const String postsPath = 'posts';
  static const String storiesPath = 'stories';
  static const String messagesPath = 'messages';

  // Agora Settings
  static const String agoraAppId = 'YOUR_AGORA_APP_ID';
  static const int agoraUid = 0; // 0 means random UID

  // API Endpoints
  static const String baseUrl = 'https://your-backend.com/api';

  // Default Values
  static const String defaultProfileImage = 'assets/images/default_profile.png';
  static const String defaultErrorMessage = 'Something went wrong';
  static const int defaultPageSize = 20;
  static const int storyDuration = 24; // hours

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Pagination
  static const int postsPerPage = 10;
  static const int messagesPerPage = 50;
  static const int usersPerPage = 20;

  // Regex Patterns
  static final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
  static final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration splashDuration = Duration(seconds: 2);

  // Keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
}

class AppColors {
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFFFF6584);
  static const Color accentColor = Color(0xFF36D1DC);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);

  // Social Media Colors
  static const Color facebookColor = Color(0xFF1877F2);
  static const Color googleColor = Color(0xFF4285F4);
  static const Color appleColor = Color(0xFF000000);

  // Background Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF121212);
  static const Color cardBackground = Color(0xFFF5F5F5);

  // Text Colors
  static const Color lightText = Color(0xFF333333);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color greyText = Color(0xFF757575);
  static const Color lightGreyText = Color(0xFF9E9E9E);
}

class AppImages {
  static const String logo = 'assets/images/logo.png';
  static const String splash = 'assets/images/splash.png';
  static const String defaultProfile = 'assets/images/default_profile.png';
  static const String placeholder = 'assets/images/placeholder.png';
  static const String onboarding1 = 'assets/images/onboarding1.png';
  static const String onboarding2 = 'assets/images/onboarding2.png';
  static const String onboarding3 = 'assets/images/onboarding3.png';
}

class AppIcons {
  static const String home = 'assets/icons/home.svg';
  static const String discover = 'assets/icons/discover.svg';
  static const String chat = 'assets/icons/chat.svg';
  static const String profile = 'assets/icons/profile.svg';
  static const String camera = 'assets/icons/camera.svg';
  static const String videoCall = 'assets/icons/video_call.svg';
  static const String voiceCall = 'assets/icons/voice_call.svg';
  static const String more = 'assets/icons/more.svg';
}

class AppAnimations {
  static const String loading = 'assets/animations/loading.json';
  static const String success = 'assets/animations/success.json';
  static const String error = 'assets/animations/error.json';
  static const String empty = 'assets/animations/empty.json';
  static const String welcome = 'assets/animations/welcome.json';
}
