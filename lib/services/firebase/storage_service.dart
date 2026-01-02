// lib/services/firebase/storage_service.dart
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload profile picture
  static Future<String> uploadProfilePicture(
    File imageFile,
    String userId,
  ) async {
    try {
      final Reference ref = _storage
          .ref()
          .child('profile_pictures')
          .child('$userId-${DateTime.now().millisecondsSinceEpoch}.jpg');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'userId': userId},
      );

      final uploadTask = ref.putFile(imageFile, metadata);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Upload post media
  static Future<List<String>> uploadPostMedia(
    List<File> mediaFiles,
    String userId,
  ) async {
    try {
      final List<String> urls = [];

      for (var i = 0; i < mediaFiles.length; i++) {
        final file = mediaFiles[i];
        final extension = file.path.split('.').last;

        final Reference ref = _storage
            .ref()
            .child('posts')
            .child(userId)
            .child('${DateTime.now().millisecondsSinceEpoch}-$i.$extension');

        final metadata = SettableMetadata(
          contentType: extension == 'mp4' ? 'video/mp4' : 'image/jpeg',
        );

        final uploadTask = ref.putFile(file, metadata);
        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        urls.add(downloadUrl);
      }

      return urls;
    } catch (e) {
      rethrow;
    }
  }

  // Upload story
  static Future<String> uploadStory(
    File mediaFile,
    String userId,
    bool isVideo,
  ) async {
    try {
      final extension = isVideo ? 'mp4' : 'jpg';

      final Reference ref = _storage
          .ref()
          .child('stories')
          .child(userId)
          .child('${DateTime.now().millisecondsSinceEpoch}.$extension');

      final metadata = SettableMetadata(
        contentType: isVideo ? 'video/mp4' : 'image/jpeg',
      );

      final uploadTask = ref.putFile(mediaFile, metadata);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Upload chat media
  static Future<String> uploadChatMedia(
    File mediaFile,
    String chatId,
    String type,
  ) async {
    try {
      final extension = type == 'video'
          ? 'mp4'
          : type == 'audio'
          ? 'mp3'
          : 'jpg';

      final Reference ref = _storage
          .ref()
          .child('messages')
          .child(chatId)
          .child('${DateTime.now().millisecondsSinceEpoch}.$extension');

      final metadata = SettableMetadata(
        contentType: type == 'video'
            ? 'video/mp4'
            : type == 'audio'
            ? 'audio/mpeg'
            : 'image/jpeg',
      );

      final uploadTask = ref.putFile(mediaFile, metadata);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Delete file
  static Future<void> deleteFile(String url) async {
    try {
      final Reference ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }

  // Get download URL
  static Future<String> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }
}
