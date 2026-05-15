import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  // Your App ID from the dashboard
  static const String appId = '72a3e3a7ee7444829df3bb2ffd9465c0';

  static RtcEngine? _engine;

  static RtcEngine get engine {
    if (_engine == null) {
      throw Exception('Agora engine not initialized');
    }
    return _engine!;
  }

  static Future<void> initialize() async {
    if (_engine != null) return;

    await Permission.microphone.request();

    _engine = createAgoraRtcEngine();

    await _engine!.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    await _engine!.enableAudio();

    // Matching the professional chatroom scenario from 29565.png
    await _engine!.setAudioProfile(
      profile: AudioProfileType.audioProfileMusicHighQuality,
      scenario: AudioScenarioType.audioScenarioChatroom,
    );

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          if (kDebugMode) print("Joined channel: ${connection.channelId}");
        },
        onUserJoined: (connection, uid, elapsed) {
          if (kDebugMode) print("User joined: $uid");
        },
        onError: (err, msg) {
          if (kDebugMode) print("Agora error: $err - $msg");
        },
      ),
    );
  }

  static Future<void> joinChannel({
    required String channelName,
    required String token,
    required int uid,
  }) async {
    // Check if engine is null and initialize if necessary
    if (_engine == null) {
      await initialize();
    }

    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );
  }

  static Future<void> leaveChannel() async {
    await _engine?.leaveChannel();
  }

  static Future<void> muteLocalAudio(bool muted) async {
    await _engine?.muteLocalAudioStream(muted);
  }

  static Future<void> setSpeakerphoneOn(bool on) async {
    await _engine?.setEnableSpeakerphone(on);
  }

  static Future<void> dispose() async {
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
  }
}
