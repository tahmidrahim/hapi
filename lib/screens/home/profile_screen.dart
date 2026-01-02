// lib/screens/home/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:hapi/models/user_model.dart';
import 'package:hapi/screens/home/friends_screen.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final List<Post> _posts = [];
  final List<User> _friends = [];
  bool _isLoading = true;
  final bool _isMyProfile = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _posts.addAll([
        Post(
          id: '1',
          content: 'Amazing sunset today! 🌅',
          imageUrl: 'https://picsum.photos/300/200',
          likes: 245,
          comments: 32,
          timeAgo: '1 day ago',
        ),
        Post(
          id: '2',
          content: 'Working on my new project! 💻',
          imageUrl: '',
          likes: 89,
          comments: 12,
          timeAgo: '3 days ago',
        ),
      ]);

      _friends.addAll([
        User(
          id: '1',
          name: 'John Doe',
          profileImage: 'https://picsum.photos/200',
          isOnline: true,
          username: '',
          mutualFriends: 5,
          lastSeen: '',
        ),
        User(
          id: '2',
          name: 'Sarah Smith',
          profileImage: 'https://picsum.photos/201',
          isOnline: true,
          username: '',
          mutualFriends: 3,
          lastSeen: '',
        ),
        User(
          id: '3',
          name: 'Mike Johnson',
          profileImage: 'https://picsum.photos/202',
          isOnline: false,
          username: '',
          mutualFriends: 7,
          lastSeen: '',
        ),
      ]);

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 350,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: _buildProfileHeader(user),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          tabs: [
                            Tab(
                              child: Text(
                                'Posts',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Friends',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          indicatorColor: Theme.of(context).primaryColor,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Colors.grey,
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: [_buildPostsTab(), _buildFriendsTab()],
                ),
              ),
        floatingActionButton: _isMyProfile
            ? FloatingActionButton(
                onPressed: _editProfile,
                child: const Icon(Icons.edit),
              )
            : null,
      ),
    );
  }

  Widget _buildProfileHeader(UserModel? user) {
    final country = user?.country != null
        ? CountryPickerUtils.getCountryByIsoCode(user!.country)
        : null;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Cover photo
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorDark,
                ],
              ),
            ),
            child: _isMyProfile
                ? Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: _changeCoverPhoto,
                    ),
                  )
                : null,
          ),

          // Profile info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile image and name
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: user?.profileImage != null &&
                              user!.profileImage.isNotEmpty
                          ? CachedNetworkImageProvider(user.profileImage)
                          : const AssetImage(
                              'assets/images/default_profile.png',
                            ) as ImageProvider,
                    ),
                    if (_isMyProfile)
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                          onPressed: _changeProfilePhoto,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  user?.name ?? 'User Name',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (user?.username != null && user!.username.isNotEmpty)
                  Text(
                    '@${user.username}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),

                const SizedBox(height: 8),

                if (user?.bio != null && user!.bio!.isNotEmpty)
                  Text(
                    user.bio ?? '',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),

                const SizedBox(height: 16),

                // Location and joined date
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (country != null) ...[
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        country.name,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Joined ${DateTime.now().year}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('Posts', '12'),
                    _buildStatItem('Friends', '245'),
                    _buildStatItem('Following', '156'),
                    _buildStatItem('Followers', '1.2K'),
                  ],
                ),

                const SizedBox(height: 16),

                // Action buttons
                _isMyProfile
                    ? _buildMyProfileActions()
                    : _buildOtherProfileActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildMyProfileActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _editProfile,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Theme.of(context).primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Edit Profile',
              style: GoogleFonts.poppins(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _shareProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Share',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherProfileActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _sendMessage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text('Message'),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton(
          onPressed: _toggleFriendStatus,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text('Friend'),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: _showMoreOptions,
        ),
      ],
    );
  }

  Widget _buildPostsTab() {
    if (_posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.post_add, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No posts yet',
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
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post content
                if (post.content.isNotEmpty)
                  Text(post.content, style: GoogleFonts.poppins(fontSize: 16)),

                // Post image
                if (post.imageUrl.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: post.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],

                // Post stats
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.likes}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.comment, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${post.comments}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      post.timeAgo,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
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

  Widget _buildFriendsTab() {
    if (_friends.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.group, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No friends yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: _friends.length,
      itemBuilder: (context, index) {
        final friend = _friends[index];
        return GestureDetector(
          onTap: () => _viewFriendProfile(friend.id),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: CachedNetworkImageProvider(
                  friend.profileImage,
                ),
                child: friend.isOnline
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                friend.name,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  void _editProfile() {
    Navigator.pushNamed(context, '/edit-profile');
  }

  void _changeCoverPhoto() {
    // Implement cover photo change
  }

  void _changeProfilePhoto() {
    // Implement profile photo change
  }

  void _shareProfile() {
    // Implement share profile
  }

  void _sendMessage() {
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {'userId': widget.userId, 'userName': 'User Name'},
    );
  }

  void _toggleFriendStatus() {
    // Implement friend status toggle
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Block User'),
            onTap: () {
              Navigator.pop(context);
              _blockUser();
            },
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Report User'),
            onTap: () {
              Navigator.pop(context);
              _reportUser();
            },
          ),
        ],
      ),
    );
  }

  void _viewFriendProfile(String userId) {
    Navigator.pushNamed(context, '/profile', arguments: userId);
  }

  void _blockUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: const Text('Are you sure you want to block this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _reportUser() {
    Navigator.pushNamed(context, '/report');
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class Post {
  final String id;
  final String content;
  final String imageUrl;
  final int likes;
  final int comments;
  final String timeAgo;

  Post({
    required this.id,
    required this.content,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.timeAgo,
  });
}
