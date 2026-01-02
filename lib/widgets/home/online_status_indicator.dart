// lib/widgets/home/online_status_indicator.dart
import 'package:flutter/material.dart';

class OnlineStatusIndicator extends StatelessWidget {
  final bool isOnline;
  final double size;
  final Color onlineColor;
  final Color offlineColor;

  const OnlineStatusIndicator({
    super.key,
    required this.isOnline,
    this.size = 12,
    this.onlineColor = Colors.green,
    this.offlineColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOnline ? onlineColor : offlineColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 2,
        ),
      ),
    );
  }
}
