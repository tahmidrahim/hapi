// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hapi/models/user_model.dart';
import '../../widgets/common/custom_bottom_nav.dart';
import '../../widgets/home/story_circle.dart';
import '../../widgets/home/post_card.dart';
import '../../widgets/home/friend_request_card.dart';
import '../../providers/user_provider.dart';
import '../../utils/enums.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  AppTab _currentTab = AppTab.home;
  final List<Story> _stories = [];
  final List<Post> _posts = [];
  final List<FriendRequest> _friendRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate loading data
    await Future.delayed(const Duration(seconds: 1));

    // Mock data
    setState(() {
      _stories.addAll([
        Story(userId: '1', userName: 'You', imageUrl: '', isMyStory: true),
        Story(
          userId: '2',
          userName: 'John',
          imageUrl: 'https://picsum.photos/200',
        ),
        Story(
          userId: '3',
          userName: 'Sarah',
          imageUrl: 'https://picsum.photos/201',
        ),
        Story(
          userId: '4',
          userName: 'Mike',
          imageUrl: 'https://picsum.photos/202',
        ),
        Story(
          userId: '5',
          userName: 'Lisa',
          imageUrl: 'https://picsum.photos/203',
        ),
      ]);

      _posts.addAll([
        Post(
          id: '1',
          userId: '2',
          userName: 'John Doe',
          userImage: 'https://picsum.photos/200',
          content: 'Beautiful day at the beach! 🏖️',
          imageUrl: 'https://picsum.photos/300',
          likes: 245,
          comments: 32,
          shares: 5,
          timeAgo: '2 hours ago',
        ),
        Post(
          id: '2',
          userId: '3',
          userName: 'Sarah Smith',
          userImage: 'https://picsum.photos/201',
          content:
              'Just finished my morning workout! 💪\n#fitness #healthylifestyle',
          imageUrl: '',
          likes: 89,
          comments: 12,
          shares: 2,
          timeAgo: '5 hours ago',
        ),
      ]);

      _friendRequests.addAll([
        FriendRequest(
          userId: '6',
          userName: 'David Wilson',
          userImage: 'https://picsum.photos/204',
          mutualFriends: 12,
          timeAgo: '1 day ago',
        ),
        FriendRequest(
          userId: '7',
          userName: 'Emma Johnson',
          userImage: 'https://picsum.photos/205',
          mutualFriends: 8,
          timeAgo: '2 days ago',
        ),
      ]);

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: _buildAppBar(user),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
      bottomNavigationBar: CustomBottomNav(
        currentTab: _currentTab,
        onTabSelected: (tab) => setState(() => _currentTab = tab),
        badgeCounts: {AppTab.chat: 3, AppTab.discover: 1},
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar(UserModel? user) {
    return AppBar(
      title: Row(
        children: [
          Text(
            'Kapi',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Text(
            ' Hapi',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.search, size: 28), onPressed: () {}),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 28),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              radius: 18,
              backgroundImage:
                  user?.profileImage != null && user!.profileImage.isNotEmpty
                      ? CachedNetworkImageProvider(user.profileImage)
                      : const AssetImage('assets/images/default_profile.png')
                          as ImageProvider,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Stories
          _buildStoriesSection(),

          // Create Post
          _buildCreatePost(),

          // Friend Requests
          if (_friendRequests.isNotEmpty) _buildFriendRequests(),

          // Posts
          _buildPostsSection(),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStoriesSection() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          final story = _stories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: StoryCircle(
              userId: story.userId,
              userName: story.userName,
              imageUrl: story.imageUrl,
              isMyStory: story.isMyStory,
              onTap: () {},
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreatePost() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/default_profile.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  "What's on your mind?",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.photo_library_outlined, color: Colors.green),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFriendRequests() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Friend Requests',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: _friendRequests.map((request) {
              return FriendRequestCard(
                userId: request.userId,
                userName: request.userName,
                userImage: request.userImage,
                mutualFriends: request.mutualFriends,
                timeAgo: request.timeAgo,
                onAccept: () {},
                onReject: () {},
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsSection() {
    return Column(
      children: _posts.map((post) {
        return PostCard(
          postId: post.id,
          userId: post.userId,
          userName: post.userName,
          userImage: post.userImage,
          content: post.content,
          imageUrl: post.imageUrl,
          likes: post.likes,
          comments: post.comments,
          shares: post.shares,
          timeAgo: post.timeAgo,
          onLike: () {},
          onComment: () {},
          onShare: () {},
        );
      }).toList(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.video_call, size: 28),
    );
  }
}

// Models for this screen
class Story {
  final String userId;
  final String userName;
  final String imageUrl;
  final bool isMyStory;

  Story({
    required this.userId,
    required this.userName,
    required this.imageUrl,
    this.isMyStory = false,
  });
}

class Post {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final String content;
  final String imageUrl;
  final int likes;
  final int comments;
  final int shares;
  final String timeAgo;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.content,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.timeAgo,
  });
}

class FriendRequest {
  final String userId;
  final String userName;
  final String userImage;
  final int mutualFriends;
  final String timeAgo;

  FriendRequest({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.mutualFriends,
    required this.timeAgo,
  });
}
