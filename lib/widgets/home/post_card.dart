// lib/widgets/home/post_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class PostCard extends StatelessWidget {
  final String postId;
  final String userId;
  final String userName;
  final String userImage;
  final String content;
  final String imageUrl;
  final int likes;
  final int comments;
  final int shares;
  final String timeAgo;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostCard({
    super.key,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.content,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.timeAgo,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),

          // Content
          _buildContent(),

          // Image
          if (imageUrl.isNotEmpty) _buildImage(),

          // Stats
          _buildStats(),

          // Actions
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: userImage.isNotEmpty
                ? CachedNetworkImageProvider(userImage)
                : const AssetImage('assets/images/default_profile.png')
                    as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  timeAgo,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (content.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(content, style: GoogleFonts.poppins(fontSize: 15)),
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            Container(height: 250, color: Colors.grey.shade200),
        errorWidget: (context, url, error) => Container(
          height: 250,
          color: Colors.grey.shade200,
          child: const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Likes
          Row(
            children: [
              Icon(Icons.favorite, size: 16, color: Colors.red.shade600),
              const SizedBox(width: 4),
              Text(
                _formatNumber(likes),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Comments
          Row(
            children: [
              Icon(Icons.comment, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                _formatNumber(comments),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Shares
          Row(
            children: [
              Icon(Icons.share, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                _formatNumber(shares),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: onLike,
              icon: Icon(Icons.favorite_border, color: Colors.grey.shade600),
              label: Text(
                'Like',
                style: GoogleFonts.poppins(color: Colors.grey.shade600),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: onComment,
              icon: Icon(Icons.comment_outlined, color: Colors.grey.shade600),
              label: Text(
                'Comment',
                style: GoogleFonts.poppins(color: Colors.grey.shade600),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: onShare,
              icon: Icon(Icons.share_outlined, color: Colors.grey.shade600),
              label: Text(
                'Share',
                style: GoogleFonts.poppins(color: Colors.grey.shade600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number < 1000) return number.toString();
    if (number < 1000000) {
      final result = number / 1000;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}K';
    }
    final result = number / 1000000;
    return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}M';
  }
}
