// lib/screens/video/live_stream_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LiveStreamScreen extends ConsumerStatefulWidget {
  final String streamId;
  final bool isHost;

  const LiveStreamScreen({
    super.key,
    required this.streamId,
    this.isHost = false,
  });

  @override
  ConsumerState<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends ConsumerState<LiveStreamScreen> {
  final List<Viewer> _viewers = [];
  final List<Comment> _comments = [];
  int _viewerCount = 0;
  int _likeCount = 0;
  final bool _isLive = true;
  bool _isMuted = false;
  bool _showComments = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStreamData();
    _startStream();
  }

  void _loadStreamData() {
    // Mock data
    setState(() {
      _viewerCount = 1250;
      _likeCount = 5430;

      _viewers.addAll([
        Viewer(
          id: '1',
          name: 'John Doe',
          imageUrl: 'https://picsum.photos/200',
        ),
        Viewer(
          id: '2',
          name: 'Sarah Smith',
          imageUrl: 'https://picsum.photos/201',
        ),
        Viewer(
          id: '3',
          name: 'Mike Johnson',
          imageUrl: 'https://picsum.photos/202',
        ),
      ]);

      _comments.addAll([
        Comment(
          id: '1',
          userId: '1',
          userName: 'John Doe',
          userImage: 'https://picsum.photos/200',
          text: 'Great stream!',
          timeAgo: '2 min ago',
        ),
        Comment(
          id: '2',
          userId: '2',
          userName: 'Sarah Smith',
          userImage: 'https://picsum.photos/201',
          text: 'Love this content!',
          timeAgo: '1 min ago',
        ),
        Comment(
          id: '3',
          userId: '3',
          userName: 'Mike Johnson',
          userImage: 'https://picsum.photos/202',
          text: 'Can you explain that again?',
          timeAgo: 'just now',
        ),
      ]);
    });
  }

  void _startStream() {
    // Initialize stream logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video stream
          _buildVideoStream(),

          // Stream info and controls
          _buildStreamOverlay(),

          // Comments overlay
          if (_showComments) _buildCommentsOverlay(),
        ],
      ),
    );
  }

  Widget _buildVideoStream() {
    return Container(
      color: Colors.grey.shade900,
      child: Center(
        child: widget.isHost ? _buildHostView() : _buildViewerView(),
      ),
    );
  }

  Widget _buildHostView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.videocam, size: 64, color: Colors.white54),
        const SizedBox(height: 16),
        Text(
          'You are live',
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
        Text(
          'Streaming to $_viewerCount viewers',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildViewerView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.play_circle_filled, size: 64, color: Colors.white54),
        const SizedBox(height: 16),
        Text(
          'Live Stream',
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
        Text(
          '$_viewerCount viewers watching',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildStreamOverlay() {
    return Column(
      children: [
        // Top bar
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Spacer(),
              if (_isLive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        'LIVE',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: _showMoreOptions,
              ),
            ],
          ),
        ),

        const Spacer(),

        // Bottom controls
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Stream info
              if (!widget.isHost)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: CachedNetworkImageProvider(
                          'https://picsum.photos/200',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'John Doe',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Flutter Development Tutorial',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _followStreamer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Follow'),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Controls
              Row(
                children: [
                  // Like button
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: _sendLike,
                      ),
                      Text(
                        _formatNumber(_likeCount),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Comment button
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.comment,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: _toggleComments,
                      ),
                      Text(
                        _formatNumber(_comments.length),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Share button
                  IconButton(
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: _shareStream,
                  ),

                  const Spacer(),

                  // Viewers
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.remove_red_eye,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatNumber(_viewerCount),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (widget.isHost) ...[
                    const SizedBox(width: 12),
                    IconButton(
                      icon: Icon(
                        _isMuted ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: _toggleMute,
                    ),
                    IconButton(
                      icon: const Icon(Icons.stop, color: Colors.red, size: 30),
                      onPressed: _endStream,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsOverlay() {
    return Positioned(
      right: 0,
      bottom: 120,
      child: Container(
        width: 300,
        height: 400,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Comments header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Comments',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: _toggleComments,
                  ),
                ],
              ),
            ),

            // Comments list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return _buildCommentItem(comment);
                },
              ),
            ),

            // Comment input
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type a comment...',
                        hintStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade800,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendComment,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: CachedNetworkImageProvider(comment.userImage),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.userName,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  comment.text,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                ),
                Text(
                  comment.timeAgo,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number < 1000) return number.toString();
    if (number < 1000000) {
      final result = number / 1000;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}K';
    }
    final result = number / 1000000;
    return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}M';
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report Stream'),
              onTap: () {
                Navigator.pop(context);
                _reportStream();
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block Streamer'),
              onTap: () {
                Navigator.pop(context);
                _blockStreamer();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Stream Settings'),
              onTap: () {
                Navigator.pop(context);
                _showSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendLike() {
    setState(() => _likeCount++);
  }

  void _toggleComments() {
    setState(() => _showComments = !_showComments);
  }

  void _shareStream() {
    // Implement share functionality
  }

  void _followStreamer() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Followed streamer')));
  }

  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
  }

  void _endStream() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Stream'),
        content: const Text('Are you sure you want to end the stream?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('End Stream'),
          ),
        ],
      ),
    );
  }

  void _sendComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _comments.insert(
        0,
        Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: 'me',
          userName: 'You',
          userImage: 'https://picsum.photos/203',
          text: text,
          timeAgo: 'just now',
        ),
      );
      _commentController.clear();
    });
  }

  void _reportStream() {
    // Implement report functionality
  }

  void _blockStreamer() {
    // Implement block functionality
  }

  void _showSettings() {
    // Implement settings
  }
}

class Viewer {
  final String id;
  final String name;
  final String imageUrl;

  Viewer({required this.id, required this.name, required this.imageUrl});
}

class Comment {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final String text;
  final String timeAgo;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.text,
    required this.timeAgo,
  });
}
