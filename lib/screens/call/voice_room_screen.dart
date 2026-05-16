import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hapi/providers/navigation_provider.dart';
import 'package:hapi/providers/user_provider.dart';
import 'package:hapi/services/agora_service.dart';
import 'package:hapi/widgets/animated_avatar.dart';
import 'package:hapi/widgets/animation.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRoomScreen extends ConsumerStatefulWidget {
  final String? roomId;
  final bool isCreating;

  const VoiceRoomScreen({super.key, this.roomId, this.isCreating = false});

  @override
  ConsumerState<VoiceRoomScreen> createState() => _VoiceRoomScreenState();
}

class _VoiceRoomScreenState extends ConsumerState<VoiceRoomScreen>
    with TickerProviderStateMixin {
  bool _isMuted = false;
  bool _isSpeakerOn = true;
  bool _isConnected = false;
  int _participantCount = 1;
  String _connectionStatus = 'Connecting...';

  // Animation Controllers
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _micWaveController;
  late Animation<double> _micWaveAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Setup Pulse Animation (For the speaking halo effect)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutCirc),
    );

    // 2. Setup Mic Wave Animation (For the icon opacity flicker)
    _micWaveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _micWaveAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _micWaveController, curve: Curves.easeIn),
    );

    _initVoiceChat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _micWaveController.dispose();
    AgoraService.dispose();
    super.dispose();
  }

  Future<void> _initVoiceChat() async {
    final micStatus = await Permission.microphone.request();
    if (micStatus.isDenied) {
      setState(() {
        _connectionStatus = 'Microphone permission denied';
      });
      return;
    }

    try {
      setState(() => _connectionStatus = 'Initializing...');
      await AgoraService.initialize();

      setState(() => _connectionStatus = 'Joining channel...');
      await AgoraService.joinChannel(
        channelName: widget.roomId ?? "test_room",
        token: "",
        uid: 0,
      );

      if (mounted) {
        setState(() {
          _isConnected = true;
          _connectionStatus = 'Connected';
        });
      }
    } catch (e) {
      debugPrint("Detailed Error: $e");
      if (mounted) {
        setState(() => _connectionStatus = 'Connection failed');
      }
    }
  }

  void _toggleMute() async {
    await AgoraService.muteLocalAudio(!_isMuted);
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _toggleSpeaker() async {
    _isSpeakerOn = !_isSpeakerOn;
    await AgoraService.setSpeakerphoneOn(_isSpeakerOn);
    setState(() {});
  }

  Future<void> _exitRoom() async {
    await AgoraService.dispose();
    if (mounted) {
      ref.read(navigationProvider.notifier).goToHome();
    }
  }

  void _showExitOptions() {
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
                Navigator.pop(context);
                _exitRoom();
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.white),
              title: const Text('Keep', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final bool isSpeaking = _isConnected && !_isMuted;

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
          Container(color: Colors.black.withOpacity(0.4)),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(user),
                const SizedBox(height: 20),
                _buildStatusIndicator(),
                const SizedBox(height: 20),
                _buildHostSection(user),
                const SizedBox(height: 20),
                _buildMicGrid(isSpeaking),
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

  Widget _buildStatusIndicator() {
    Color statusColor;
    if (_isConnected) {
      statusColor = Colors.green;
    } else if (_connectionStatus == 'Connection failed') {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _connectionStatus,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildHeader(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Animated Avatar in top left corner
          AnimatedAvatar(
            imageUrl: user.photoUrl,
            radius: 11,
            animationSize: 32,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.name.length > 15
                    ? "${user.name.substring(0, 15)}..."
                    : user.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  const Text(
                    "ID: ",
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                  Text(
                    user.id.length > 10
                        ? "${user.id.substring(0, 8)}..."
                        : user.id,
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
          const SizedBox(width: 15),
          const Icon(Icons.share_outlined, color: Colors.white, size: 20),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: _showExitOptions,
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
        AnimatedAvatar(imageUrl: user.photoUrl, radius: 26, animationSize: 76),
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

  Widget _buildMicGrid(bool isSpeaking) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 25,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          final isUserSeat = index == 0;

          return Column(
            children: [
              AnimatedBuilder(
                animation: (isUserSeat && isSpeaking)
                    ? _pulseAnimation
                    : const AlwaysStoppedAnimation(1.0),
                builder: (context, child) {
                  return Transform.scale(
                    scale: (isUserSeat && isSpeaking)
                        ? _pulseAnimation.value
                        : 1.0,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black45,
                        border: (isUserSeat && isSpeaking)
                            ? Border.all(
                                color: const Color(0xFF1DE9B6),
                                width: 3,
                              )
                            : Border.all(color: Colors.transparent),
                        boxShadow: (isUserSeat && isSpeaking)
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF1DE9B6,
                                  ).withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: (isUserSeat && isSpeaking)
                          ? AnimatedBuilder(
                              animation: _micWaveAnimation,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _micWaveAnimation.value,
                                  child: const Icon(
                                    Icons.mic,
                                    color: Color(0xFF1DE9B6),
                                    size: 26,
                                  ),
                                );
                              },
                            )
                          : Icon(
                              (isUserSeat && _isMuted)
                                  ? Icons.mic_off
                                  : Icons.mic_none,
                              color: (isUserSeat && _isMuted)
                                  ? Colors.red
                                  : Colors.white54,
                              size: 24,
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                isUserSeat ? "You" : "No.${index + 1}",
                style: TextStyle(
                  color: (isUserSeat && isSpeaking)
                      ? const Color(0xFF1DE9B6)
                      : Colors.white70,
                  fontSize: 11,
                  fontWeight: (isUserSeat && isSpeaking)
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
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
              "Welcome to Hapi! Please respect each other and talk politely.",
              style: TextStyle(color: Colors.greenAccent, fontSize: 11),
            ),
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _toolbarButton(
            icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
            label: 'Sound',
            onTap: _toggleSpeaker,
          ),
          _toolbarButton(
            icon: _isMuted ? Icons.mic_off : Icons.mic,
            label: _isMuted ? 'Unmute' : 'Mute',
            color: _isMuted ? Colors.red : Colors.white,
            onTap: _toggleMute,
          ),
          _toolbarButton(
            icon: Icons.chat_bubble_outline,
            label: 'Chat',
            onTap: () {},
          ),
          _toolbarButton(
            icon: Icons.emoji_emotions_outlined,
            label: 'Emoji',
            onTap: () {},
          ),
          _toolbarButton(
            icon: Icons.logout,
            label: 'Exit',
            color: Colors.red,
            onTap: _showExitOptions,
          ),
        ],
      ),
    );
  }

  Widget _toolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
