// lib/services/utils/permission_service.dart
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Check and request camera permission
  static Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    return false;
  }

  // Check and request microphone permission
  static Future<bool> checkMicrophonePermission() async {
    final status = await Permission.microphone.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await Permission.microphone.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    return false;
  }

  // Check and request storage permission
  static Future<bool> checkStoragePermission() async {
    final status = await Permission.storage.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await Permission.storage.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    return false;
  }

  // Check and request photos permission
  static Future<bool> checkPhotosPermission() async {
    final status = await Permission.photos.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await Permission.photos.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    return false;
  }

  // Check and request notifications permission
  static Future<bool> checkNotificationsPermission() async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await Permission.notification.request();
      return result.isGranted;
    }

    return false;
  }

  // Check and request location permission
  static Future<bool> checkLocationPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await Permission.location.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    return false;
  }

  // Check all permissions needed for video call
  static Future<bool> checkVideoCallPermissions() async {
    final cameraGranted = await checkCameraPermission();
    final microphoneGranted = await checkMicrophonePermission();

    return cameraGranted && microphoneGranted;
  }

  // Check all permissions needed for app
  static Future<Map<String, bool>> checkAllPermissions() async {
    final permissions = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
      Permission.photos,
      Permission.notification,
      Permission.location,
    ].request();

    return {
      'camera': permissions[Permission.camera]?.isGranted ?? false,
      'microphone': permissions[Permission.microphone]?.isGranted ?? false,
      'storage': permissions[Permission.storage]?.isGranted ?? false,
      'photos': permissions[Permission.photos]?.isGranted ?? false,
      'notifications': permissions[Permission.notification]?.isGranted ?? false,
      'location': permissions[Permission.location]?.isGranted ?? false,
    };
  }
}
