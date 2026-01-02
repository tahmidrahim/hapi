// lib/widgets/common/user_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCard extends StatelessWidget {
  final String userId;
  final String name;
  final String? username;
  final String? profileImage;
  final bool isOnline;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showOnlineStatus;

  const UserCard({
    super.key,
    required this.userId,
    required this.name,
    this.username,
    this.profileImage,
    this.isOnline = false,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showOnlineStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildProfileImage(context),
      title: Text(
        name,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : username != null
          ? Text(
              '@$username',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: profileImage != null && profileImage!.isNotEmpty
              ? CachedNetworkImageProvider(profileImage!)
              : const AssetImage('assets/images/default_profile.png')
                    as ImageProvider,
        ),
        if (showOnlineStatus && isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// User Card with action button
class UserCardWithAction extends StatelessWidget {
  final String userId;
  final String name;
  final String? profileImage;
  final bool isOnline;
  final String? subtitle;
  final String actionText;
  final Color actionColor;
  final VoidCallback onActionPressed;

  const UserCardWithAction({
    super.key,
    required this.userId,
    required this.name,
    this.profileImage,
    this.isOnline = false,
    this.subtitle,
    required this.actionText,
    required this.actionColor,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildProfileImage(context),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onActionPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: actionColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(actionText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: profileImage != null && profileImage!.isNotEmpty
              ? CachedNetworkImageProvider(profileImage!)
              : const AssetImage('assets/images/default_profile.png')
                    as ImageProvider,
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
