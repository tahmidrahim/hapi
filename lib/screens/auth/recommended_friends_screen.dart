import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendedFriendsScreen extends ConsumerStatefulWidget {
  const RecommendedFriendsScreen({super.key});

  @override
  ConsumerState<RecommendedFriendsScreen> createState() =>
      _RecommendedFriendsScreenState();
}

class _RecommendedFriendsScreenState
    extends ConsumerState<RecommendedFriendsScreen> {
  final List<Map<String, dynamic>> _recommendedFriends = [];
  final Set<String> _selectedFriends = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendedFriends();
  }

  Future<void> _loadRecommendedFriends() async {
    try {
      // Simulate loading from Firebase
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _recommendedFriends.addAll([
          {
            'id': '1',
            'name': 'John Doe',
            'username': 'john_doe',
            'profileImage': 'https://picsum.photos/200',
            'mutualFriends': 12,
          },
          {
            'id': '2',
            'name': 'Sarah Smith',
            'username': 'sarah_smith',
            'profileImage': 'https://picsum.photos/201',
            'mutualFriends': 8,
          },
          {
            'id': '3',
            'name': 'Mike Johnson',
            'username': 'mike_johnson',
            'profileImage': 'https://picsum.photos/202',
            'mutualFriends': 5,
          },
          {
            'id': '4',
            'name': 'Lisa Taylor',
            'username': 'lisa_taylor',
            'profileImage': 'https://picsum.photos/203',
            'mutualFriends': 15,
          },
          {
            'id': '5',
            'name': 'David Wilson',
            'username': 'david_wilson',
            'profileImage': 'https://picsum.photos/204',
            'mutualFriends': 3,
          },
        ]);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recommended Friends',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recommendedFriends.length,
      itemBuilder: (context, index) {
        final friend = _recommendedFriends[index];
        final isSelected = _selectedFriends.contains(friend['id']);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: CachedNetworkImageProvider(
                friend['profileImage'],
              ),
            ),
            title: Text(
              friend['name'],
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${friend['username']}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${friend['mutualFriends']} mutual friends',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (value) => _toggleFriendSelection(friend['id']),
            ),
            onTap: () => _toggleFriendSelection(friend['id']),
          ),
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _selectedFriends.isNotEmpty ? _finishSetup : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Finish',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _toggleFriendSelection(String friendId) {
    setState(() {
      if (_selectedFriends.contains(friendId)) {
        _selectedFriends.remove(friendId);
      } else {
        _selectedFriends.add(friendId);
      }
    });
  }

  Future<void> _finishSetup() async {
    try {
      // Add selected friends to Firebase
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final firestore = FirebaseFirestore.instance;

      for (final friendId in _selectedFriends) {
        await firestore.collection('friends').add({
          'userId': userId,
          'friendId': friendId,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Navigate to home screen
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding friends: $e')));
    }
  }
}
