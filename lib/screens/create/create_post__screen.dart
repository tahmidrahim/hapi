// lib/screens/create/create_post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _selectedImages = [];
  String? _selectedVideo;
  String _privacy = 'friends';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _canPost() ? _createPost : null,
            child: const Text('Post'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User info
            _buildUserInfo(),

            // Text input
            _buildTextInput(),

            // Media preview
            if (_selectedImages.isNotEmpty || _selectedVideo != null)
              _buildMediaPreview(),

            // Add media buttons
            _buildMediaButtons(),

            // Privacy settings
            _buildPrivacySettings(),

            // Location
            _buildLocation(),

            // Tag friends
            _buildTagFriends(),

            // Feeling/Activity
            _buildFeelingActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('assets/images/default_profile.png'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Name',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              DropdownButton<String>(
                value: _privacy,
                items: const [
                  DropdownMenuItem(value: 'public', child: Text('Public')),
                  DropdownMenuItem(value: 'friends', child: Text('Friends')),
                  DropdownMenuItem(value: 'private', child: Text('Only Me')),
                ],
                onChanged: (value) => setState(() => _privacy = value!),
                underline: Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextInput() {
    return TextField(
      controller: _textController,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: "What's on your mind?",
        border: InputBorder.none,
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
      ),
      style: GoogleFonts.poppins(fontSize: 16),
    );
  }

  Widget _buildMediaPreview() {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 16),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 8,
        ),
        itemCount: _selectedImages.length + (_selectedVideo != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (_selectedVideo != null && index == 0) {
            return _buildVideoPreview();
          }
          final imageIndex = _selectedVideo != null ? index - 1 : index;
          return _buildImagePreview(imageIndex);
        },
      ),
    );
  }

  Widget _buildVideoPreview() {
    return Stack(
      children: [
        Container(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.play_circle_filled,
            size: 48,
            color: Colors.white54,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => setState(() => _selectedVideo = null),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(int index) {
    return Stack(
      children: [
        Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(_selectedImages[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => setState(() => _selectedImages.removeAt(index)),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMediaButton(
              icon: Icons.photo_library,
              label: 'Photo',
              onPressed: _pickImage,
            ),
            _buildMediaButton(
              icon: Icons.videocam,
              label: 'Video',
              onPressed: _pickVideo,
            ),
            _buildMediaButton(
              icon: Icons.location_on,
              label: 'Check in',
              onPressed: _addLocation,
            ),
            _buildMediaButton(
              icon: Icons.tag,
              label: 'Tag',
              onPressed: _tagFriends,
            ),
            _buildMediaButton(
              icon: Icons.emoji_emotions,
              label: 'Feeling',
              onPressed: _addFeeling,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.blue),
          onPressed: onPressed,
        ),
        Text(label, style: GoogleFonts.poppins(fontSize: 12)),
      ],
    );
  }

  Widget _buildPrivacySettings() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.lock),
        title: const Text('Privacy'),
        subtitle: Text(_getPrivacyText()),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: _changePrivacy,
      ),
    );
  }

  Widget _buildLocation() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.location_on),
        title: const Text('Add Location'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: _addLocation,
      ),
    );
  }

  Widget _buildTagFriends() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person_add),
        title: const Text('Tag Friends'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: _tagFriends,
      ),
    );
  }

  Widget _buildFeelingActivity() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.emoji_emotions),
        title: const Text('Feeling/Activity'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: _addFeeling,
      ),
    );
  }

  String _getPrivacyText() {
    switch (_privacy) {
      case 'public':
        return 'Public';
      case 'friends':
        return 'Friends';
      case 'private':
        return 'Only Me';
      default:
        return 'Friends';
    }
  }

  bool _canPost() {
    return _textController.text.isNotEmpty ||
        _selectedImages.isNotEmpty ||
        _selectedVideo != null;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(pickedFile.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _selectedVideo = pickedFile.path);
    }
  }

  Future<void> _createPost() async {
    if (!_canPost()) return;


    try {
      // Upload media and create post
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      Navigator.pop(context, {
        'text': _textController.text,
        'images': _selectedImages,
        'video': _selectedVideo,
        'privacy': _privacy,
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating post: $e')));
    } finally {
    }
  }

  void _changePrivacy() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('Public'),
              subtitle: const Text('Anyone can see this post'),
              value: 'public',
              groupValue: _privacy,
              onChanged: (value) {
                setState(() => _privacy = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Friends'),
              subtitle: const Text('Only your friends can see this post'),
              value: 'friends',
              groupValue: _privacy,
              onChanged: (value) {
                setState(() => _privacy = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Only Me'),
              subtitle: const Text('Only you can see this post'),
              value: 'private',
              groupValue: _privacy,
              onChanged: (value) {
                setState(() => _privacy = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addLocation() {
    // Implement location picker
  }

  void _tagFriends() {
    // Implement friend tagging
  }

  void _addFeeling() {
    // Implement feeling/activity picker
  }
}
