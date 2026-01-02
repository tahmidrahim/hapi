// lib/screens/video/group_call_screen.dart
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupCallScreen extends ConsumerStatefulWidget {
  final String? roomId;
  final List<String> participantIds;

  const GroupCallScreen({super.key, this.roomId, required this.participantIds});

  @override
  ConsumerState<GroupCallScreen> createState() => _GroupCallScreenState();
}

class _GroupCallScreenState extends ConsumerState<GroupCallScreen> {
  final List<Participant> _participants = [];
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  int _callDuration = 0;
  late Timer _callTimer;

  @override
  void initState() {
    super.initState();
    _loadParticipants();
    _startCallTimer();
  }

  void _loadParticipants() {
    // Mock participants
    setState(() {
      _participants.addAll([
        Participant(
          id: '1',
          name: 'John Doe',
          imageUrl: 'https://picsum.photos/200',
          isSpeaking: true,
          isVideoEnabled: true,
          isMuted: false,
        ),
        Participant(
          id: '2',
          name: 'Sarah Smith',
          imageUrl: 'https://picsum.photos/201',
          isSpeaking: false,
          isVideoEnabled: true,
          isMuted: false,
        ),
        Participant(
          id: '3',
          name: 'Mike Johnson',
          imageUrl: 'https://picsum.photos/202',
          isSpeaking: false,
          isVideoEnabled: false,
          isMuted: true,
        ),
        Participant(
          id: 'me',
          name: 'You',
          imageUrl: 'https://picsum.photos/203',
          isSpeaking: false,
          isVideoEnabled: true,
          isMuted: false,
          isMe: true,
        ),
      ]);
    });
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _callDuration++);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video grid
          _buildVideoGrid(),

          // Call info
          _buildCallInfo(),

          // Controls
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildVideoGrid() {
    final videoParticipants =
        _participants.where((p) => p.isVideoEnabled).toList();
    final audioParticipants =
        _participants.where((p) => !p.isVideoEnabled).toList();

    return Column(
      children: [
        // Video participants grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: videoParticipants.length,
            itemBuilder: (context, index) {
              final participant = videoParticipants[index];
              return _buildVideoTile(participant);
            },
          ),
        ),

        // Audio participants list
        if (audioParticipants.isNotEmpty)
          Container(
            height: 100,
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: audioParticipants.length,
              itemBuilder: (context, index) {
                final participant = audioParticipants[index];
                return _buildAudioTile(participant);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildVideoTile(Participant participant) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Video feed or placeholder
          Center(
            child: participant.isMe
                ? const Icon(Icons.videocam, size: 48, color: Colors.white54)
                : const Icon(Icons.person, size: 48, color: Colors.white54),
          ),

          // Participant info
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: CachedNetworkImageProvider(
                    participant.imageUrl,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    participant.isMe ? 'You' : participant.name,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (participant.isMuted)
                  const Icon(Icons.mic_off, size: 14, color: Colors.white),
                if (participant.isSpeaking)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioTile(Participant participant) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: CachedNetworkImageProvider(participant.imageUrl),
          ),
          const SizedBox(height: 8),
          Text(
            participant.name,
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.white),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (participant.isMuted)
                const Icon(Icons.mic_off, size: 12, color: Colors.white),
              if (participant.isSpeaking)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCallInfo() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            'Group Call',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            _formatDuration(),
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
          ),
          Text(
            '${_participants.length} participants',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mute/Unmute
          _buildControlButton(
            icon: _isMuted ? Icons.mic_off : Icons.mic,
            backgroundColor: _isMuted ? Colors.white : Colors.white24,
            iconColor: _isMuted ? Colors.black : Colors.white,
            onPressed: _toggleMute,
          ),

          // Video On/Off
          _buildControlButton(
            icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
            backgroundColor: _isVideoEnabled ? Colors.white : Colors.white24,
            iconColor: _isVideoEnabled ? Colors.black : Colors.white,
            onPressed: _toggleVideo,
          ),

          // Add participant
          _buildControlButton(
            icon: Icons.person_add,
            backgroundColor: Colors.white24,
            iconColor: Colors.white,
            onPressed: _addParticipant,
          ),

          // Chat
          _buildControlButton(
            icon: Icons.chat,
            backgroundColor: Colors.white24,
            iconColor: Colors.white,
            onPressed: _openChat,
          ),

          // End Call
          _buildControlButton(
            icon: Icons.call_end,
            backgroundColor: Colors.red,
            iconColor: Colors.white,
            onPressed: _endCall,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: backgroundColor,
      child: IconButton(
        icon: Icon(icon, size: 24),
        color: iconColor,
        onPressed: onPressed,
      ),
    );
  }

  String _formatDuration() {
    final hours = _callDuration ~/ 3600;
    final minutes = (_callDuration % 3600) ~/ 60;
    final seconds = _callDuration % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
    // Update participant state
    final me = _participants.firstWhere((p) => p.isMe);
    final index = _participants.indexOf(me);
    _participants[index] = me.copyWith(isMuted: _isMuted);
  }

  void _toggleVideo() {
    setState(() => _isVideoEnabled = !_isVideoEnabled);
    // Update participant state
    final me = _participants.firstWhere((p) => p.isMe);
    final index = _participants.indexOf(me);
    _participants[index] = me.copyWith(isVideoEnabled: _isVideoEnabled);
  }

  void _addParticipant() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Participants',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            // Search and friend list would go here
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Add Selected'),
            ),
          ],
        ),
      ),
    );
  }

  void _openChat() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Group Chat',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  // Chat messages would go here
                ],
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _endCall() {
    _callTimer.cancel();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _callTimer.cancel();
    super.dispose();
  }
}

class Participant {
  final String id;
  final String name;
  final String imageUrl;
  final bool isSpeaking;
  final bool isVideoEnabled;
  final bool isMuted;
  final bool isMe;

  Participant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.isSpeaking,
    required this.isVideoEnabled,
    required this.isMuted,
    this.isMe = false,
  });

  Participant copyWith({
    String? id,
    String? name,
    String? imageUrl,
    bool? isSpeaking,
    bool? isVideoEnabled,
    bool? isMuted,
    bool? isMe,
  }) {
    return Participant(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isMuted: isMuted ?? this.isMuted,
      isMe: isMe ?? this.isMe,
    );
  }
}
