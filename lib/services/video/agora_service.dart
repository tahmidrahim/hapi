// lib/services/video/agora_service.dart
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  static const String appId = 'YOUR_AGORA_APP_ID';
  late RtcEngine _engine;

  // Event handlers
  Function(int uid, int elapsed)? onUserJoined;
  Function(
    int uid,
  )? onUserOffline;
  Function(int uid, int width, int height, int rotation)?
      onFirstRemoteVideoFrame;
  Function(RtcStats stats)? onRtcStats;
  Function(int duration, int totalFrozenTime)? onNetworkQuality;

  RtcEngine? get engine => null;

  // Initialize Agora
  Future<void> initialize() async {
    // Request permissions
    await [Permission.microphone, Permission.camera].request();

    // Create engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));

    // Enable video
    await _engine.enableVideo();

    // Set up event handlers
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          print('Joined channel: ${connection.channelId}, elapsed: $elapsed');
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          print('User joined: $remoteUid');
          onUserJoined?.call(remoteUid, elapsed);
        },
        onUserOffline: (connection, remoteUid, reason) {
          print('User offline: $remoteUid, reason: $reason');
          onUserOffline?.call(remoteUid);
        },
        onFirstRemoteVideoFrame:
            (connection, remoteUid, width, height, elapsed) {
          print('First remote video frame: $remoteUid');
          onFirstRemoteVideoFrame?.call(remoteUid, width, height, elapsed);
        },
        onRtcStats: (connection, stats) {
          onRtcStats?.call(stats);
        },
        onNetworkQuality: (connection, remoteUid, txQuality, rxQuality) {
          onNetworkQuality?.call(txQuality as int, rxQuality as int);
        },
        onError: (err, msg) {
          print('Agora error: $err, $msg');
        },
      ),
    );
  }

  // Join channel
  Future<void> joinChannel({
    required String channelName,
    required String token,
    int uid = 0,
    bool isBroadcaster = true,
  }) async {
    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: isBroadcaster
            ? ClientRoleType.clientRoleBroadcaster
            : ClientRoleType.clientRoleAudience,
      ),
    );
  }

  // Leave channel
  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
  }

  // Switch camera
  Future<void> switchCamera() async {
    await _engine.switchCamera();
  }

  // Mute/unmute audio
  Future<void> muteLocalAudio(bool muted) async {
    await _engine.muteLocalAudioStream(muted);
  }

  // Enable/disable video
  Future<void> enableLocalVideo(bool enabled) async {
    await _engine.enableLocalVideo(enabled);
  }

  // Start/stop screen sharing
  Future<void> startScreenSharing() async {
    // Note: Screen sharing requires additional setup
    // You need to create a ScreenSharing instance
  }

  // Set video encoder configuration
  Future<void> setVideoEncoderConfiguration({
    int width = 640,
    int height = 360,
    int frameRate = 15,
    int bitrate = 500,
  }) async {
    await _engine.setVideoEncoderConfiguration(
      VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: width, height: height),
        frameRate: frameRate,
        bitrate: bitrate,
      ),
    );
  }

  // Dispose
  Future<void> dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }
}
