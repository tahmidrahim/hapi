import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hapi/providers/navigation_provider.dart';
import 'package:hapi/providers/user_provider.dart';

class VoiceRoomScreen extends ConsumerWidget {
  final String? roomId;
  final bool isCreating;

  const VoiceRoomScreen({super.key, this.roomId, this.isCreating = false});

  void _showExitOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.white),
              title: const Text('Exit', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
                ref.read(navigationProvider.notifier).goToHome();
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.white),
              title: const Text('Keep', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(
                  context,
                ); // Just close bottom sheet, stay in voice room
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/aurora_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(user, context, ref),
                const SizedBox(height: 20),
                _buildHostSection(user),
                const SizedBox(height: 20),
                _buildMicGrid(),
                const Spacer(),
                _buildChatAndAnnouncement(),
                _buildBottomToolbar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(UserModel user, BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.name.length > 15
                          ? "${user.name.substring(0, 15)}..."
                          : user.name,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    const Text(
                      "ID:24406788  👤1",
                      style: TextStyle(color: Colors.white70, fontSize: 8),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
          const SizedBox(width: 15),
          const Icon(Icons.share_outlined, color: Colors.white, size: 20),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () => _showExitOptions(context, ref),
            child: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostSection(UserModel user) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage('assets/profile.png'),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, color: Colors.greenAccent, size: 14),
            const SizedBox(width: 4),
            Text(
              user.name.length > 15
                  ? "${user.name.substring(0, 15)}..."
                  : user.name,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMicGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mic_none,
                  color: Colors.white54,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "No.${index + 1}",
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChatAndAnnouncement() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "Welcome to Hapi! Please respect each other and talk politely. Abusing, third-party advertising, fake official information and politically sensitive topics are strictly prohibited.",
              style: TextStyle(color: Colors.greenAccent, fontSize: 11),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Welcome Md Tahmid Tan... entered room",
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Text(
                "Announcement: ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.edit, color: Colors.white, size: 12),
            ],
          ),
          const Text(
            "Welcome to my room, let's chat together!",
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.volume_up, color: Colors.white, size: 24),
          const Icon(Icons.mic, color: Colors.white, size: 24),
          const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 24),
          const Icon(
            Icons.emoji_emotions_outlined,
            color: Colors.white,
            size: 24,
          ),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.mail_outline, color: Colors.white, size: 24),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "2",
                    style: TextStyle(color: Colors.white, fontSize: 8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Image.asset('assets/gift_icon.png', height: 40),
        ],
      ),
    );
  }
}
