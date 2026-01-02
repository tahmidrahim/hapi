// lib/services/utils/image_picker_service.dart
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      return await _picker.pickImage(source: source, imageQuality: 85);
    } catch (e) {
      return null;
    }
  }

  static Future<XFile?> pickVideo({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      return await _picker.pickVideo(source: source);
    } catch (e) {
      return null;
    }
  }

  static Future<List<XFile>> pickMultipleImages() async {
    try {
      return await _picker.pickMultiImage(imageQuality: 85);
    } catch (e) {
      return [];
    }
  }
}
