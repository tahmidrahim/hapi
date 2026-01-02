// lib/utils/helpers.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class AppHelpers {
  // Shared Preferences
  static Future<SharedPreferences> get prefs async =>
      await SharedPreferences.getInstance();

  // File Operations
  static Future<File> getFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    final buffer = byteData.buffer;
    final tempDir = await getTemporaryDirectory();
    final tempFile = File(
      '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}',
    );
    await tempFile.writeAsBytes(
      buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    return tempFile;
  }

  // Image Processing
  static Future<File> compressImage(File file, {int quality = 85}) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) return file;

    final compressed = img.copyResize(image, width: min(1080, image.width));

    final compressedBytes = img.encodeJpg(compressed, quality: quality);

    final tempDir = await getTemporaryDirectory();
    final compressedFile = File(
      '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  }

  // Permissions
  static Future<bool> checkAndRequestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;
    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }
    if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return false;
  }

  static Future<bool> checkCameraPermission() async {
    return await checkAndRequestPermission(Permission.camera);
  }

  static Future<bool> checkMicrophonePermission() async {
    return await checkAndRequestPermission(Permission.microphone);
  }

  static Future<bool> checkStoragePermission() async {
    return await checkAndRequestPermission(Permission.storage);
  }

  // Network
  static Future<bool> hasNetworkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  // Formatting
  static String formatNumber(int number) {
    if (number < 1000) return number.toString();
    if (number < 1000000) {
      final result = number / 1000;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}K';
    }
    final result = number / 1000000;
    return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}M';
  }

  static String formatFileSize(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // UUID
  static String generateId() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    return base64UrlEncode(values).replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  // Debounce
  static Function debounce(
    Function func, [
    Duration delay = const Duration(milliseconds: 500),
  ]) {
    Timer? timer;
    return () {
      if (timer?.isActive ?? false) {
        timer?.cancel();
      }
      timer = Timer(delay, () => func());
    };
  }

  // Throttle
  static Function throttle(
    Function func, [
    Duration delay = const Duration(milliseconds: 500),
  ]) {
    bool isThrottled = false;
    return () {
      if (!isThrottled) {
        func();
        isThrottled = true;
        Timer(delay, () => isThrottled = false);
      }
    };
  }

  // Copy to Clipboard
  static Future<void> copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
  }

  // Open URL
  static Future<void> openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  // Get Initials
  static String getInitials(String name) {
    final names = name.split(' ');
    if (names.length > 1) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  // Generate Random Color
  static Color getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  // Check if dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
