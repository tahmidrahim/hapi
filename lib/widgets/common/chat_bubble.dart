// lib/widgets/common/chat_bubble.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime time;
  final bool showTime;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.time,
    this.showTime = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isMe ? Theme.of(context).primaryColor : Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: isMe
                  ? const Radius.circular(20)
                  : const Radius.circular(4),
              bottomRight: isMe
                  ? const Radius.circular(4)
                  : const Radius.circular(20),
            ),
          ),
          child: Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: isMe ? Colors.white : Colors.black,
            ),
          ),
        ),
        if (showTime)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _formatTime(time),
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDay = DateTime(time.year, time.month, time.day);

    if (messageDay == today) {
      return _formatHourMinute(time);
    } else if (messageDay == yesterday) {
      return 'Yesterday ${_formatHourMinute(time)}';
    } else {
      return '${_formatDate(time)} ${_formatHourMinute(time)}';
    }
  }

  String _formatHourMinute(DateTime time) {
    final hour = time.hour % 12;
    final minute = time.minute;
    final amPm = time.hour < 12 ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:${minute.toString().padLeft(2, '0')} $amPm';
  }

  String _formatDate(DateTime time) {
    return '${time.month}/${time.day}/${time.year.toString().substring(2)}';
  }
}
