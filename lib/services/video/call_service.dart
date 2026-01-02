// lib/services/video/call_service.dart
import 'package:hapi/services/video/agora_service.dart';
import '../firebase/firestore_service.dart';

class CallService {
  final AgoraService _agoraService = AgoraService();
  bool _isInCall = false;
  String? _currentCallId;
  String? _currentChannel;

  // Initialize
  Future<void> initialize() async {
    await _agoraService.initialize();
  }

  // Start a call
  Future<void> startCall({
    required String receiverId,
    required bool isVideoCall,
  }) async {
    try {
      final callType = isVideoCall ? 'video' : 'audio';

      // Create call record in Firestore
      final callId = await FirestoreService.createCall(
        receiverId: receiverId,
        type: callType,
      );

      _currentCallId = callId;

      // Generate channel name (use callId or combination of user IDs)
      final channelName = 'call_$callId';
      _currentChannel = channelName;

      // For agora, you'd need to generate a token from your server
      // For now, using temp token (in production, generate from your server)
      const tempToken = 'YOUR_TEMP_TOKEN';

      await _agoraService.joinChannel(
        channelName: channelName,
        token: tempToken,
        isBroadcaster: true,
      );

      _isInCall = true;
    } catch (e) {
      rethrow;
    }
  }

  // Join a call
  Future<void> joinCall(String callId) async {
    try {
      _currentCallId = callId;
      final channelName = 'call_$callId';
      _currentChannel = channelName;

      const tempToken = 'YOUR_TEMP_TOKEN';

      await _agoraService.joinChannel(
        channelName: channelName,
        token: tempToken,
        isBroadcaster: true,
      );

      _isInCall = true;

      // Update call status to accepted
      await FirestoreService.updateCallStatus(callId, 'accepted');
    } catch (e) {
      rethrow;
    }
  }

  // End call
  Future<void> endCall({int? duration}) async {
    try {
      await _agoraService.leaveChannel();

      if (_currentCallId != null) {
        await FirestoreService.updateCallStatus(
          _currentCallId!,
          'ended',
          duration: duration,
        );
      }

      _isInCall = false;
      _currentCallId = null;
      _currentChannel = null;
    } catch (e) {
      rethrow;
    }
  }

  // Toggle mute
  Future<void> toggleMute() async {
    // You'll need to track mute state
    // await _agoraService.muteLocalAudio(!isMuted);
  }

  // Toggle video
  Future<void> toggleVideo() async {
    // You'll need to track video state
    // await _agoraService.enableLocalVideo(!isVideoEnabled);
  }

  // Switch camera
  Future<void> switchCamera() async {
    await _agoraService.switchCamera();
  }

  // Getters
  bool get isInCall => _isInCall;
  String? get currentCallId => _currentCallId;
  String? get currentChannel => _currentChannel;

  // Dispose
  Future<void> dispose() async {
    if (_isInCall) {
      await endCall();
    }
    await _agoraService.dispose();
  }
}
