// lib/services/firebase/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collections
  static CollectionReference get users => _firestore.collection('users');
  static CollectionReference get friends => _firestore.collection('friends');
  static CollectionReference get chats => _firestore.collection('chats');
  static CollectionReference get calls => _firestore.collection('calls');
  static CollectionReference get posts => _firestore.collection('posts');
  static CollectionReference get stories => _firestore.collection('stories');
  static CollectionReference get notifications =>
      _firestore.collection('notifications');

  // User Operations
  static Future<DocumentSnapshot> getUser(String userId) async {
    return await users.doc(userId).get();
  }

  static Future<void> updateUser(
    String userId,
    Map<String, dynamic> data,
  ) async {
    await users.doc(userId).update(data);
  }

  static Stream<DocumentSnapshot> userStream(String userId) {
    return users.doc(userId).snapshots();
  }

  static Future<List<DocumentSnapshot>> searchUsers(String query) async {
    final snapshot = await users
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: '${query}z')
        .limit(20)
        .get();
    return snapshot.docs;
  }

  // Friend Operations
  static Future<void> sendFriendRequest(String friendId) async {
    final currentUserId = _auth.currentUser!.uid;
    final batch = _firestore.batch();

    batch.set(friends.doc('$currentUserId-$friendId'), {
      'userId': currentUserId,
      'friendId': friendId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    batch.set(friends.doc('$friendId-$currentUserId'), {
      'userId': friendId,
      'friendId': currentUserId,
      'status': 'requested',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  static Future<void> acceptFriendRequest(String friendId) async {
    final currentUserId = _auth.currentUser!.uid;
    final batch = _firestore.batch();

    batch.update(friends.doc('$currentUserId-$friendId'), {
      'status': 'accepted',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    batch.update(friends.doc('$friendId-$currentUserId'), {
      'status': 'accepted',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  static Stream<QuerySnapshot> getFriendsStream() {
    final currentUserId = _auth.currentUser!.uid;
    return friends
        .where('userId', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'accepted')
        .snapshots();
  }

  static Stream<QuerySnapshot> getFriendRequestsStream() {
    final currentUserId = _auth.currentUser!.uid;
    return friends
        .where('userId', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'requested')
        .snapshots();
  }

  // Chat Operations
  static Future<String> createChat(
    List<String> participants,
    String type,
  ) async {
    final chatId = participants.join('-');

    await chats.doc(chatId).set({
      'id': chatId,
      'participants': participants,
      'type': type,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return chatId;
  }

  static Stream<QuerySnapshot> getUserChatsStream() {
    final currentUserId = _auth.currentUser!.uid;
    return chats
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage({
    required String chatId,
    required String text,
    String type = 'text',
    String? mediaUrl,
  }) async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final currentUserId = _auth.currentUser!.uid;

    await chats.doc(chatId).collection('messages').doc(messageId).set({
      'id': messageId,
      'chatId': chatId,
      'senderId': currentUserId,
      'text': text,
      'mediaUrl': mediaUrl ?? '',
      'type': type,
      'readBy': [currentUserId],
      'createdAt': FieldValue.serverTimestamp(),
    });

    await chats.doc(chatId).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getChatMessagesStream(String chatId) {
    return chats
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Call Operations
  static Future<String> createCall({
    required String receiverId,
    required String type,
  }) async {
    final callId = DateTime.now().millisecondsSinceEpoch.toString();
    final currentUserId = _auth.currentUser!.uid;

    await calls.doc(callId).set({
      'id': callId,
      'callerId': currentUserId,
      'receiverId': receiverId,
      'type': type,
      'status': 'ringing',
      'startedAt': FieldValue.serverTimestamp(),
      'participants': [currentUserId],
      'createdAt': FieldValue.serverTimestamp(),
    });

    return callId;
  }

  static Future<void> updateCallStatus(
    String callId,
    String status, {
    int? duration,
  }) async {
    final updateData = {
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (status == 'ended') {
      updateData['endedAt'] = FieldValue.serverTimestamp();
      if (duration != null) {
        updateData['duration'] = duration;
      }
    } else if (status == 'accepted') {
      final currentUserId = _auth.currentUser!.uid;
      updateData['participants'] = FieldValue.arrayUnion([currentUserId]);
    }

    await calls.doc(callId).update(updateData);
  }

  // Post Operations
  static Future<String> createPost({
    required String text,
    required String type,
    required String privacy,
    List<String> mediaUrls = const [],
  }) async {
    final postId = DateTime.now().millisecondsSinceEpoch.toString();
    final currentUserId = _auth.currentUser!.uid;

    await posts.doc(postId).set({
      'id': postId,
      'userId': currentUserId,
      'text': text,
      'mediaUrls': mediaUrls,
      'type': type,
      'privacy': privacy,
      'likes': [],
      'comments': 0,
      'shares': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return postId;
  }

  static Stream<QuerySnapshot> getPostsStream() {
    return posts.orderBy('createdAt', descending: true).limit(20).snapshots();
  }

  static Future<void> likePost(String postId, String userId) async {
    await posts.doc(postId).update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }

  static Future<void> unlikePost(String postId, String userId) async {
    await posts.doc(postId).update({
      'likes': FieldValue.arrayRemove([userId]),
    });
  }

  // Story Operations
  static Future<String> createStory({
    required String mediaUrl,
    required String type,
    int duration = 5,
  }) async {
    final storyId = DateTime.now().millisecondsSinceEpoch.toString();
    final currentUserId = _auth.currentUser!.uid;
    final expiresAt = DateTime.now().add(const Duration(hours: 24));

    await stories.doc(storyId).set({
      'id': storyId,
      'userId': currentUserId,
      'mediaUrl': mediaUrl,
      'type': type,
      'duration': duration,
      'views': [],
      'expiresAt': expiresAt,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return storyId;
  }

  static Stream<QuerySnapshot> getStoriesStream() {
    final twentyFourHoursAgo = DateTime.now().subtract(
      const Duration(hours: 24),
    );

    return stories
        .where('createdAt', isGreaterThan: twentyFourHoursAgo)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<void> viewStory(String storyId, String userId) async {
    await stories.doc(storyId).update({
      'views': FieldValue.arrayUnion([userId]),
    });
  }

  // Notification Operations
  static Future<void> sendNotification({
    required String userId,
    required String type,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    await notifications.add({
      'userId': userId,
      'type': type,
      'title': title,
      'body': body,
      'data': data,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getUserNotificationsStream() {
    final currentUserId = _auth.currentUser!.uid;
    return notifications
        .where('userId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<void> markNotificationAsRead(String notificationId) async {
    await notifications.doc(notificationId).update({'read': true});
  }
}
