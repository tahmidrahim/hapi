// lib/screens/home/chat_screen.dart
import 'dart:io'; // Required for Platform checks
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// FIX: Hide 'Config' to avoid conflict with emoji_picker_flutter
import 'package:google_fonts/google_fonts.dart' hide Config;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../../widgets/common/chat_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String userId;
  final String userName;
  final String? userImage;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.userImage,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _messages.addAll([
        ChatMessage(
          id: '1',
          senderId: widget.userId,
          text: 'Hey there! 👋',
          time: DateTime.now().subtract(const Duration(hours: 2)),
          isMe: false,
        ),
        ChatMessage(
          id: '2',
          senderId: 'me',
          text: 'Hello! How are you?',
          time: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          isMe: true,
        ),
        ChatMessage(
          id: '3',
          senderId: widget.userId,
          text: 'I\'m doing great! Thanks for asking. How about you?',
          time: DateTime.now().subtract(const Duration(hours: 1)),
          isMe: false,
        ),
        ChatMessage(
          id: '4',
          senderId: 'me',
          text: 'I\'m good too! Just working on some projects.',
          time: DateTime.now().subtract(const Duration(minutes: 30)),
          isMe: true,
        ),
        ChatMessage(
          id: '5',
          senderId: widget.userId,
          text: 'That sounds interesting! What kind of projects?',
          time: DateTime.now().subtract(const Duration(minutes: 15)),
          isMe: false,
        ),
      ]);
      _isLoading = false;
    });

    // Scroll to bottom after frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildChatList(),
          ),
          _buildMessageInput(),
          if (_showEmojiPicker) _buildEmojiPicker(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage:
                widget.userImage != null && widget.userImage!.isNotEmpty
                    ? CachedNetworkImageProvider(widget.userImage!)
                    : const AssetImage('assets/images/default_profile.png')
                        as ImageProvider,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Online',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.video_call),
          onPressed: _startVideoCall,
        ),
        IconButton(
          icon: const Icon(Icons.phone),
          onPressed: _startVoiceCall,
        ),
        PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view_profile',
              child: Text('View Profile'),
            ),
            const PopupMenuItem(
              value: 'clear_chat',
              child: Text('Clear Chat'),
            ),
            const PopupMenuItem(
              value: 'block',
              child: Text('Block User'),
            ),
          ],
          onSelected: (value) => _handleMenuAction(value.toString()),
        ),
      ],
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final showAvatar = index == 0 ||
            _messages[index - 1].senderId != message.senderId ||
            message.time.difference(_messages[index - 1].time).inMinutes > 5;

        final showTime = index == _messages.length - 1 ||
            _messages[index + 1].senderId != message.senderId ||
            _messages[index + 1].time.difference(message.time).inMinutes > 5;

        return Column(
          children: [
            if (showAvatar && !message.isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: widget.userImage != null &&
                              widget.userImage!.isNotEmpty
                          ? CachedNetworkImageProvider(widget.userImage!)
                          : const AssetImage(
                                  'assets/images/default_profile.png')
                              as ImageProvider,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.userName,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ChatBubble(
              message: message.text,
              isMe: message.isMe,
              time: message.time,
              showTime: showTime,
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: _toggleEmojiPicker,
          ),
          IconButton(
            icon: const Icon(Icons.photo_library_outlined),
            onPressed: _pickImage,
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: _takePhoto,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          if (_messageController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: _sendMessage,
            )
          else
            IconButton(
              icon: const Icon(Icons.mic, color: Colors.blue),
              onPressed: _startVoiceMessage,
            ),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 300,
      child: EmojiPicker(
        textEditingController: _messageController,
        // FIX: Modern Config structure for emoji_picker_flutter v4+
        config: Config(
          height: 256,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            columns: 7,
            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
            backgroundColor: const Color(0xFFF2F2F2),
            // 'noRecents' is now a Widget, not a String
            noRecents: const Text(
              'No Recents',
              style: TextStyle(fontSize: 20, color: Colors.black26),
            ),
          ),
          categoryViewConfig: const CategoryViewConfig(
            initCategory: Category.RECENT,
            backgroundColor: Color(0xFFF2F2F2),
            indicatorColor: Colors.blue,
            iconColor: Colors.grey,
            iconColorSelected: Colors.blue,
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: CategoryIcons(),
          ),
          bottomActionBarConfig: const BottomActionBarConfig(
            enabled: false,
            backgroundColor: Color(0xFFF2F2F2),
            buttonColor: Colors.grey,
            buttonIconColor: Colors.black,
          ),
          searchViewConfig: const SearchViewConfig(
            backgroundColor: Color(0xFFF2F2F2),
          ),
        ),
      ),
    );
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
  }

  void _pickImage() {
    // Implement image picking
  }

  void _takePhoto() {
    // Implement camera
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'me',
          text: text,
          time: DateTime.now(),
          isMe: true,
        ),
      );
      _messageController.clear();
      _showEmojiPicker = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startVoiceMessage() {
    // Implement voice message
  }

  void _startVideoCall() {
    Navigator.pushNamed(
      context,
      '/video-call',
      arguments: {
        'userId': widget.userId,
        'userName': widget.userName,
      },
    );
  }

  void _startVoiceCall() {
    Navigator.pushNamed(
      context,
      '/video-call',
      arguments: {
        'userId': widget.userId,
        'userName': widget.userName,
        'isVideo': false,
      },
    );
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'view_profile':
        Navigator.pushNamed(
          context,
          '/profile',
          arguments: widget.userId,
        );
        break;
      case 'clear_chat':
        _clearChat();
        break;
      case 'block':
        _blockUser();
        break;
    }
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _messages.clear());
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _blockUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: const Text('Are you sure you want to block this user?'),
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
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime time;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.time,
    required this.isMe,
  });
}