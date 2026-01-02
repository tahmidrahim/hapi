// lib/screens/video/video_recorder_screen.dart
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';

class VideoRecorderScreen extends ConsumerStatefulWidget {
  const VideoRecorderScreen({super.key});

  @override
  ConsumerState<VideoRecorderScreen> createState() =>
      _VideoRecorderScreenState();
}

class _VideoRecorderScreenState extends ConsumerState<VideoRecorderScreen> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isRecording = false;
  bool _isFrontCamera = true;
  bool _isFlashOn = false;
  Duration _recordingDuration = Duration.zero;
  Timer? _recordingTimer;
  VideoPlayerController? _videoPlayerController;
  String? _recordedVideoPath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController!.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_recordedVideoPath != null && _videoPlayerController != null) {
      return _buildPreviewScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          if (_cameraController != null &&
              _cameraController!.value.isInitialized)
            CameraPreview(_cameraController!)
          else
            const Center(child: CircularProgressIndicator()),

          // Top controls
          _buildTopControls(),

          // Bottom controls
          _buildBottomControls(),

          // Recording timer
          if (_isRecording) _buildRecordingTimer(),
        ],
      ),
    );
  }

  Widget _buildPreviewScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video preview
          Center(
            child: AspectRatio(
              aspectRatio: _videoPlayerController!.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController!),
            ),
          ),

          // Top controls
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: _discardVideo,
                ),
                Text(
                  'Preview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.white),
                  onPressed: _useVideo,
                ),
              ],
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.replay, color: Colors.white, size: 30),
                  onPressed: _replayVideo,
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 30),
                  onPressed: _editVideo,
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 30),
                  onPressed: _shareVideo,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopControls() {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: Icon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: _toggleFlash,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Recording time
          if (_isRecording)
            Text(
              _formatDuration(_recordingDuration),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

          const SizedBox(height: 20),

          // Main recording button
          GestureDetector(
            onTap: _toggleRecording,
            onLongPress: _startRecording,
            onLongPressEnd: (_) => _stopRecording(),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isRecording ? Colors.red : Colors.white,
                  width: 4,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording ? Colors.red : Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Secondary controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Gallery button
              IconButton(
                icon: const Icon(
                  Icons.photo_library,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: _openGallery,
              ),

              // Switch camera
              IconButton(
                icon: const Icon(
                  Icons.cameraswitch,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: _switchCamera,
              ),

              // Settings
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 30),
                onPressed: _showSettings,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingTimer() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 50,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Recording indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Recording',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null) return;

    try {
      if (_isFlashOn) {
        await _cameraController!.setFlashMode(FlashMode.off);
      } else {
        await _cameraController!.setFlashMode(FlashMode.torch);
      }
      setState(() => _isFlashOn = !_isFlashOn);
    } catch (e) {
      print('Error toggling flash: $e');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    try {
      _isFrontCamera = !_isFrontCamera;
      final camera = _cameras.firstWhere(
        (camera) =>
            camera.lensDirection ==
            (_isFrontCamera
                ? CameraLensDirection.front
                : CameraLensDirection.back),
      );

      await _cameraController!.dispose();
      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: true,
      );
      await _cameraController!.initialize();
      setState(() {});
    } catch (e) {
      print('Error switching camera: $e');
    }
  }

  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      await _cameraController!.startVideoRecording();
      setState(() => _isRecording = true);

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() => _recordingDuration += const Duration(seconds: 1));
      });
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      final videoFile = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _recordedVideoPath = videoFile.path;
      });

      _recordingTimer?.cancel();
      _recordingDuration = Duration.zero;

      // Initialize video player for preview
      _videoPlayerController = VideoPlayerController.file(videoFile as File);
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.setLooping(true);
      await _videoPlayerController!.play();

      setState(() {});
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  void _toggleRecording() {
    if (_isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  void _openGallery() {
    // Implement gallery opening
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.video_settings),
              title: const Text('Video Quality'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _changeVideoQuality,
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Timer'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _setTimer,
            ),
            ListTile(
              leading: const Icon(Icons.grid_view),
              title: const Text('Grid'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _toggleGrid,
            ),
          ],
        ),
      ),
    );
  }

  void _changeVideoQuality() {
    // Implement quality change
  }

  void _setTimer() {
    // Implement timer
  }

  void _toggleGrid() {
    // Implement grid toggle
  }

  void _discardVideo() {
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    _recordedVideoPath = null;
    setState(() {});
  }

  void _useVideo() {
    // Return video path to previous screen
    Navigator.pop(context, _recordedVideoPath);
  }

  void _replayVideo() {
    if (_videoPlayerController != null) {
      _videoPlayerController!.seekTo(Duration.zero);
      _videoPlayerController!.play();
    }
  }

  void _editVideo() {
    // Navigate to video editor
  }

  void _shareVideo() {
    // Implement share functionality
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoPlayerController?.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }
}
