// lib/services/video/video_stream_service.dart
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VideoStreamService {
  static const String appId = 'YOUR_AGORA_APP_ID';
  late RtcEngine _engine;

  Future<void> initialize() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));
    await _engine.enableVideo();
  }

  Future<void> joinChannel({
    required String channelName,
    required String token,
    int uid = 0,
  }) async {
    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
  }

  Future<void> dispose() async {
    await _engine.release();
  }
}
