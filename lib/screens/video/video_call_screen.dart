// lib/screens/video/video_call_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// FIX: Using only the main library for Agora v6
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/video/agora_service.dart';

class VideoCallScreen extends ConsumerStatefulWidget {
  final String userId;
  final String userName;
  final String? userImage;
  final bool isVideoCall;

  const VideoCallScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.userImage,
    this.isVideoCall = true,
  });

  @override
  ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallScreen> {
  final AgoraService _agoraService = AgoraService();
  final List<int> _remoteUids = [];
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  bool _isSpeakerEnabled = true;
  bool _isFrontCamera = true;
  bool _isConnecting = true;
  bool _isCallActive = false;
  int _callDuration = 0;
  late Timer _callTimer;

  @override
  void initState() {
    super.initState();
    _initializeCall();
    _startCallTimer();
  }

  Future<void> _initializeCall() async {
    try {
      await _agoraService.initialize();

      _agoraService.onUserJoined = (uid, elapsed) {
        if (mounted) {
          setState(() {
            _remoteUids.add(uid);
            _isConnecting = false;
            _isCallActive = true;
          });
        }
      };

      _agoraService.onUserOffline = (uid, reason) {
        if (mounted) {
          setState(() {
            _remoteUids.remove(uid);
            _isCallActive = _remoteUids.isNotEmpty;
          });
        }
      } as Function(int uid)?;

      // Join channel with user ID as channel name
      await _agoraService.joinChannel(
        channelName: widget.userId,
        token: 'YOUR_TEMP_TOKEN', // Replace with actual token
        isBroadcaster: true,
      );

      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    } catch (e) {
      debugPrint('Error initializing call: $e');
    }
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isCallActive && mounted) {
        setState(() => _callDuration++);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video views
          _buildVideoViews(),

          // Call info
          _buildCallInfo(),

          // Controls
          _buildControls(),

          // Connecting indicator
          if (_isConnecting) _buildConnectingOverlay(),
        ],
      ),
    );
  }

  // FIX: Refactored to use AgoraVideoView (v6 API)
  Widget _buildVideoViews() {
    // If no remote users, show full screen local video
    if (_remoteUids.isEmpty) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _agoraService.engine!,
          canvas: const VideoCanvas(uid: 0), // 0 indicates local user
        ),
      );
    }

    // One-on-one call layout
    if (_remoteUids.length == 1) {
      return Stack(
        children: [
          // Remote video (Full Screen)
          AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: _agoraService.engine!,
              canvas: VideoCanvas(uid: _remoteUids[0]),
              connection: RtcConnection(channelId: widget.userId),
            ),
          ),

          // Local video (Small Overlay)
          Positioned(
            bottom: 120,
            right: 20,
            width: 100,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _agoraService.engine!,
                  canvas: const VideoCanvas(uid: 0),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Group call layout (Grid)
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: _remoteUids.length + 1, // +1 for local video
      itemBuilder: (context, index) {
        if (index < _remoteUids.length) {
          // Remote User
          return AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: _agoraService.engine!,
              canvas: VideoCanvas(uid: _remoteUids[index]),
              connection: RtcConnection(channelId: widget.userId),
            ),
          );
        } else {
          // Local User
          return AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _agoraService.engine!,
              canvas: const VideoCanvas(uid: 0),
            ),
          );
        }
      },
    );
  }

  Widget _buildCallInfo() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // User info
          CircleAvatar(
            radius: 30,
            backgroundImage:
                widget.userImage != null && widget.userImage!.isNotEmpty
                    ? CachedNetworkImageProvider(widget.userImage!)
                    : const AssetImage('assets/images/default_profile.png')
                        as ImageProvider,
          ),
          const SizedBox(height: 8),
          Text(
            widget.userName,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            _isCallActive ? _formatDuration() : 'Calling...',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
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
          if (widget.isVideoCall)
            _buildControlButton(
              icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
              backgroundColor: _isVideoEnabled ? Colors.white : Colors.white24,
              iconColor: _isVideoEnabled ? Colors.black : Colors.white,
              onPressed: _toggleVideo,
            ),

          // Switch Camera
          if (widget.isVideoCall && _isVideoEnabled)
            _buildControlButton(
              icon: Icons.cameraswitch,
              backgroundColor: Colors.white24,
              iconColor: Colors.white,
              onPressed: _switchCamera,
            ),

          // Speaker
          _buildControlButton(
            icon: _isSpeakerEnabled ? Icons.volume_up : Icons.volume_off,
            backgroundColor: Colors.white24,
            iconColor: Colors.white,
            onPressed: _toggleSpeaker,
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

  Widget _buildConnectingOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'Connecting...',
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
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

  Future<void> _toggleMute() async {
    setState(() => _isMuted = !_isMuted);
    await _agoraService.muteLocalAudio(_isMuted);
  }

  Future<void> _toggleVideo() async {
    setState(() => _isVideoEnabled = !_isVideoEnabled);
    await _agoraService.enableLocalVideo(_isVideoEnabled);
  }

  Future<void> _switchCamera() async {
    await _agoraService.switchCamera();
    setState(() => _isFrontCamera = !_isFrontCamera);
  }

  Future<void> _toggleSpeaker() async {
    setState(() => _isSpeakerEnabled = !_isSpeakerEnabled);
    // Note: Use enableSpeakerphone or setEnableSpeakerphone depending on your AgoraService implementation
  }

  Future<void> _endCall() async {
    _callTimer.cancel();
    await _agoraService.leaveChannel();
    // Only dispose if you don't intend to reuse the service immediately without re-initializing
    await _agoraService.dispose();
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _callTimer.cancel();
    // Do not dispose the service here if it is a singleton shared across screens,
    // but based on your _endCall logic, you seem to want to dispose it.
    super.dispose();
  }
}
