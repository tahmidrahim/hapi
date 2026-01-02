// lib/screens/create/create_room_screen.dart
import 'package:flutter/material.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _roomNameController = TextEditingController();
  String _selectedPrivacy = 'public';
  final List<String> _selectedFriends = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Room'),
        actions: [
          TextButton(
            onPressed: _canCreateRoom() ? _createRoom : null,
            child: const Text('Create'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRoomNameField(),
                  const SizedBox(height: 24),
                  _buildPrivacySettings(),
                  const SizedBox(height: 24),
                  _buildInviteFriends(),
                  const SizedBox(height: 24),
                  _buildRoomSettings(),
                ],
              ),
            ),
    );
  }

  Widget _buildRoomNameField() {
    return TextField(
      controller: _roomNameController,
      decoration: const InputDecoration(
        labelText: 'Room Name',
        hintText: 'Enter room name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.chat_bubble_outline),
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Privacy',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RadioListTile(
          title: const Text('Public Room'),
          subtitle: const Text('Anyone can join'),
          value: 'public',
          groupValue: _selectedPrivacy,
          onChanged: (value) => setState(() => _selectedPrivacy = value!),
        ),
        RadioListTile(
          title: const Text('Private Room'),
          subtitle: const Text('Only invited friends can join'),
          value: 'private',
          groupValue: _selectedPrivacy,
          onChanged: (value) => setState(() => _selectedPrivacy = value!),
        ),
      ],
    );
  }

  Widget _buildInviteFriends() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Invite Friends',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: _inviteFriends,
              child: const Text('Add Friends'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_selectedFriends.isEmpty) const Text('No friends selected'),
        // List of selected friends would go here
      ],
    );
  }

  Widget _buildRoomSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Room Settings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Allow Microphone'),
          subtitle: const Text('Let participants speak'),
          value: true,
          onChanged: (value) {},
        ),
        SwitchListTile(
          title: const Text('Allow Camera'),
          subtitle: const Text('Let participants share video'),
          value: true,
          onChanged: (value) {},
        ),
        SwitchListTile(
          title: const Text('Moderate Room'),
          subtitle: const Text('Approve participants before they join'),
          value: false,
          onChanged: (value) {},
        ),
      ],
    );
  }

  bool _canCreateRoom() {
    return _roomNameController.text.trim().isNotEmpty;
  }

  void _inviteFriends() {
    // Show friend selection dialog
  }

  Future<void> _createRoom() async {
    setState(() => _isLoading = true);
    try {
      // Create room logic
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context, {
        'name': _roomNameController.text,
        'privacy': _selectedPrivacy,
        'friends': _selectedFriends,
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating room: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
