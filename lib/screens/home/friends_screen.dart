// lib/screens/home/friends_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/common/user_card.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  final List<User> _friends = [];
  final List<User> _friendRequests = [];
  final List<User> _suggestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriendsData();
  }

  Future<void> _loadFriendsData() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Friends
      _friends.addAll([
        User(
          id: '1',
          name: 'John Doe',
          username: 'johndoe',
          profileImage: 'https://picsum.photos/200',
          isOnline: true,
          mutualFriends: 12,
          lastSeen: '2 hours ago',
        ),
        User(
          id: '2',
          name: 'Sarah Smith',
          username: 'sarahs',
          profileImage: 'https://picsum.photos/201',
          isOnline: true,
          mutualFriends: 8,
          lastSeen: '30 minutes ago',
        ),
        User(
          id: '3',
          name: 'Mike Johnson',
          username: 'mikej',
          profileImage: 'https://picsum.photos/202',
          isOnline: false,
          mutualFriends: 5,
          lastSeen: '1 day ago',
        ),
      ]);

      // Friend requests
      _friendRequests.addAll([
        User(
          id: '4',
          name: 'Emma Wilson',
          username: 'emmaw',
          profileImage: 'https://picsum.photos/203',
          isOnline: true,
          mutualFriends: 15,
          lastSeen: 'just now',
        ),
        User(
          id: '5',
          name: 'David Brown',
          username: 'davidb',
          profileImage: 'https://picsum.photos/204',
          isOnline: false,
          mutualFriends: 3,
          lastSeen: '2 days ago',
        ),
      ]);

      // Suggestions
      _suggestions.addAll([
        User(
          id: '6',
          name: 'Lisa Taylor',
          username: 'lisat',
          profileImage: 'https://picsum.photos/205',
          isOnline: true,
          mutualFriends: 7,
          lastSeen: '1 hour ago',
        ),
        User(
          id: '7',
          name: 'Robert Clark',
          username: 'robertc',
          profileImage: 'https://picsum.photos/206',
          isOnline: false,
          mutualFriends: 4,
          lastSeen: '3 days ago',
        ),
      ]);

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Friends',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            IconButton(icon: const Icon(Icons.person_add), onPressed: () {}),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Friends'),
              Tab(text: 'Requests'),
              Tab(text: 'Suggestions'),
            ],
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildFriendsList(),
                  _buildRequestsList(),
                  _buildSuggestionsList(),
                ],
              ),
      ),
    );
  }

  Widget _buildFriendsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _friends.length,
      itemBuilder: (context, index) {
        final friend = _friends[index];
        return UserCard(
          userId: friend.id,
          name: friend.name,
          username: friend.username,
          profileImage: friend.profileImage,
          isOnline: friend.isOnline,
          subtitle: friend.isOnline ? 'Online' : 'Last seen ${friend.lastSeen}',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.video_call, color: Colors.green),
                onPressed: () => _startVideoCall(friend.id),
              ),
              IconButton(
                icon: const Icon(Icons.message, color: Colors.blue),
                onPressed: () => _startChat(friend.id),
              ),
            ],
          ),
          onTap: () => _viewProfile(friend.id),
        );
      },
    );
  }

  Widget _buildRequestsList() {
    if (_friendRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.group_add, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No friend requests',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _friendRequests.length,
      itemBuilder: (context, index) {
        final request = _friendRequests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: CachedNetworkImageProvider(
                        request.profileImage,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.name,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${request.mutualFriends} mutual friends',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _acceptRequest(request.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _rejectRequest(request.id),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = _suggestions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: CachedNetworkImageProvider(
                        suggestion.profileImage,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion.name,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${suggestion.mutualFriends} mutual friends',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _sendRequest(suggestion.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text('Add Friend'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startVideoCall(String userId) {
    Navigator.pushNamed(context, '/video-call', arguments: userId);
  }

  void _startChat(String userId) {
    Navigator.pushNamed(context, '/chat', arguments: userId);
  }

  void _viewProfile(String userId) {
    Navigator.pushNamed(context, '/profile', arguments: userId);
  }

  void _acceptRequest(String userId) {
    setState(() {
      _friendRequests.removeWhere((user) => user.id == userId);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Friend request accepted')));
  }

  void _rejectRequest(String userId) {
    setState(() {
      _friendRequests.removeWhere((user) => user.id == userId);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Friend request deleted')));
  }

  void _sendRequest(String userId) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Friend request sent')));
  }
}

class User {
  final String id;
  final String name;
  final String username;
  final String profileImage;
  final bool isOnline;
  final int mutualFriends;
  final String lastSeen;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.profileImage,
    required this.isOnline,
    required this.mutualFriends,
    required this.lastSeen,
  });
}
