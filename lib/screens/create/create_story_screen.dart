// lib/screens/create/create_story_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  String? _selectedImage;
  String? _selectedVideo;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Story'),
        actions: [
          if (_selectedImage != null || _selectedVideo != null)
            TextButton(onPressed: _postStory, child: const Text('Post')),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_selectedImage != null) {
      return _buildImagePreview();
    } else if (_selectedVideo != null) {
      return _buildVideoPreview();
    } else {
      return _buildEmptyState();
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library, size: 100, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          const Text(
            'Create a Story',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Share a photo or video that disappears after 24 hours',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.photo_camera,
                label: 'Camera',
                onPressed: _takePhoto,
              ),
              _buildActionButton(
                icon: Icons.video_camera_back,
                label: 'Video',
                onPressed: _takeVideo,
              ),
              _buildActionButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onPressed: _pickFromGallery,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue.shade100,
          child: IconButton(
            icon: Icon(icon, color: Colors.blue),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        Image.network(
          _selectedImage!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPreviewButton(
                icon: Icons.edit,
                label: 'Edit',
                onPressed: _editMedia,
              ),
              _buildPreviewButton(
                icon: Icons.text_fields,
                label: 'Text',
                onPressed: _addText,
              ),
              _buildPreviewButton(
                icon: Icons.emoji_emotions,
                label: 'Stickers',
                onPressed: _addStickers,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPreview() {
    return Stack(
      children: [
        Container(
          color: Colors.black,
          child: Center(
            child: Icon(
              Icons.play_circle_filled,
              size: 100,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPreviewButton(
                icon: Icons.edit,
                label: 'Edit',
                onPressed: _editMedia,
              ),
              _buildPreviewButton(
                icon: Icons.text_fields,
                label: 'Text',
                onPressed: _addText,
              ),
              _buildPreviewButton(
                icon: Icons.tram,
                label: 'Trim',
                onPressed: _trimVideo,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white.withOpacity(0.3),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile.path;
        _selectedVideo = null;
      });
    }
  }

  Future<void> _takeVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedVideo = pickedFile.path;
        _selectedImage = null;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickMedia();
    if (pickedFile != null) {
      if (pickedFile.path.endsWith('.mp4') ||
          pickedFile.path.endsWith('.mov')) {
        setState(() {
          _selectedVideo = pickedFile.path;
          _selectedImage = null;
        });
      } else {
        setState(() {
          _selectedImage = pickedFile.path;
          _selectedVideo = null;
        });
      }
    }
  }

  void _editMedia() {
    // Implement media editing
  }

  void _addText() {
    // Implement text overlay
  }

  void _addStickers() {
    // Implement stickers
  }

  void _trimVideo() {
    // Implement video trimming
  }

  Future<void> _postStory() async {
    setState(() => _isLoading = true);
    try {
      // Upload story logic
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error posting story: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
