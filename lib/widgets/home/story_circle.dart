// lib/widgets/home/story_circle.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryCircle extends StatelessWidget {
  final String userId;
  final String userName;
  final String imageUrl;
  final bool isMyStory;
  final VoidCallback onTap;

  const StoryCircle({
    super.key,
    required this.userId,
    required this.userName,
    required this.imageUrl,
    this.isMyStory = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Story circle
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isMyStory
                  ? LinearGradient(
                      colors: [Colors.grey.shade300, Colors.grey.shade400],
                    )
                  : const LinearGradient(
                      colors: [
                        Color(0xFF833AB4),
                        Color(0xFFFD1D1D),
                        Color(0xFFFCAF45),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: isMyStory
                    ? const AssetImage('assets/images/default_profile.png')
                          as ImageProvider
                    : (imageUrl.isNotEmpty
                          ? CachedNetworkImageProvider(imageUrl)
                          : const AssetImage(
                                  'assets/images/default_profile.png',
                                )
                                as ImageProvider),
                child: isMyStory
                    ? Center(
                        child: Icon(
                          Icons.add,
                          size: 24,
                          color: Colors.grey.shade700,
                        ),
                      )
                    : null,
              ),
            ),
          ),

          // User name
          const SizedBox(height: 8),
          Text(
            isMyStory ? 'Your Story' : userName,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
