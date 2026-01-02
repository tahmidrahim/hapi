// lib/models/call_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CallModel {
  final String id;
  final String callerId;
  final String receiverId;
  final String type;
  final String status;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int duration;
  final List<String> participants;
  final String? roomId;
  final DateTime createdAt;

  CallModel({
    required this.id,
    required this.callerId,
    required this.receiverId,
    required this.type,
    required this.status,
    required this.startedAt,
    this.endedAt,
    required this.duration,
    required this.participants,
    this.roomId,
    required this.createdAt,
  });

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      id: map['id'] ?? '',
      callerId: map['callerId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      type: map['type'] ?? 'audio',
      status: map['status'] ?? 'ringing',
      startedAt: (map['startedAt'] ?? Timestamp.now()).toDate(),
      endedAt: map['endedAt']?.toDate(),
      duration: map['duration'] ?? 0,
      participants: List<String>.from(map['participants'] ?? []),
      roomId: map['roomId'],
      createdAt: (map['createdAt'] ?? Timestamp.now()).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'callerId': callerId,
      'receiverId': receiverId,
      'type': type,
      'status': status,
      'startedAt': startedAt,
      'endedAt': endedAt,
      'duration': duration,
      'participants': participants,
      'roomId': roomId,
      'createdAt': createdAt,
    };
  }

  bool get isVideoCall => type == 'video';
  bool get isAudioCall => type == 'audio';
  bool get isActive => status == 'ringing' || status == 'accepted';
  bool get isEnded =>
      status == 'ended' || status == 'missed' || status == 'rejected';
}
