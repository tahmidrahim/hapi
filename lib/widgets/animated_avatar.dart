import 'package:flutter/material.dart';
import 'package:hapi/widgets/animation.dart';

class AnimatedAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final double animationSize;

  const AnimatedAvatar({
    super.key,
    this.imageUrl,
    this.radius = 35,
    this.animationSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Animated border ring
        SizedBox(
          width: animationSize,
          height: animationSize,
          child: SvgaAnimation(
            assetPath: 'assets/animation_1778864976525.svga',
            width: animationSize,
            height: animationSize,
            loop: true,
          ),
        ),
        // Profile picture
        CircleAvatar(
          radius: radius,
          backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
              ? NetworkImage(imageUrl!)
              : const AssetImage('assets/profile.png') as ImageProvider,
        ),
      ],
    );
  }
}
