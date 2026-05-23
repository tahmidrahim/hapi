import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HapiAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final bool showAnimation;
  final VoidCallback? onTap;

  const HapiAvatar({
    super.key,
    this.imageUrl,
    this.radius = 35,
    this.showAnimation = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
          ? CachedNetworkImageProvider(imageUrl!)
          : const AssetImage('assets/profile.png') as ImageProvider,
      child: imageUrl == null || imageUrl!.isEmpty
          ? Icon(Icons.person, size: radius, color: Colors.grey)
          : null,
    );

    if (onTap != null) {
      avatar = GestureDetector(onTap: onTap, child: avatar);
    }

    if (showAnimation) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: radius * 2.2,
            height: radius * 2.2,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1DE9B6), Colors.cyan],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, size: 10),
          ),
          avatar,
        ],
      );
    }

    return avatar;
  }
}
