// lib/utils/extensions.dart
import 'package:flutter/material.dart';
import 'package:hapi/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

// DateTime Extensions
extension DateTimeExtension on DateTime {
  String get timeAgo => timeago.format(this);

  String get formattedDate => DateFormat('MMM dd, yyyy').format(this);

  String get formattedTime => DateFormat('hh:mm a').format(this);

  String get formattedDateTime =>
      DateFormat('MMM dd, yyyy hh:mm a').format(this);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final difference = now.difference(this);
    return difference.inDays < 7;
  }
}

// String Extensions
extension StringExtension on String {
  String get capitalize =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  String get initials {
    final words = split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (isNotEmpty) {
      return this[0].toUpperCase();
    }
    return '';
  }

  bool get isValidEmail => AppConstants.emailRegex.hasMatch(this);

  bool get isValidPhone => AppConstants.phoneRegex.hasMatch(this);

  bool get isValidUsername => AppConstants.usernameRegex.hasMatch(this);

  String get maskEmail {
    if (!contains('@')) return this;
    final parts = split('@');
    if (parts[0].length <= 2) return this;
    return '${parts[0][0]}***${parts[0].substring(parts[0].length - 1)}@${parts[1]}';
  }
}

// BuildContext Extensions
extension ContextExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: AppConstants.snackBarDuration,
      ),
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void hideLoadingDialog() {
    Navigator.of(this, rootNavigator: true).pop();
  }
}

// List Extensions
extension ListExtension<T> on List<T> {
  List<T> get unique => toSet().toList();

  List<T> paginate(int page, int limit) {
    final start = (page - 1) * limit;
    final end = start + limit;
    if (start >= length) return [];
    if (end > length) return sublist(start);
    return sublist(start, end);
  }
}

// Color Extensions
extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
