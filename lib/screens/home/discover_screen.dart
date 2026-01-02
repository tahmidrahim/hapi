// lib/screens/home/discover_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final List<DiscoverItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDiscoverItems();
  }

  Future<void> _loadDiscoverItems() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _items.addAll([
        DiscoverItem(
          id: '1',
          title: 'Live Streams',
          subtitle: 'Watch live videos from creators',
          imageUrl: 'https://picsum.photos/300/200',
          type: DiscoverType.live,
          viewers: 1250,
        ),
        DiscoverItem(
          id: '2',
          title: 'Trending Videos',
          subtitle: 'Most popular videos today',
          imageUrl: 'https://picsum.photos/301/200',
          type: DiscoverType.video,
          likes: 5400,
        ),
        DiscoverItem(
          id: '3',
          title: 'New Groups',
          subtitle: 'Join communities of interest',
          imageUrl: 'https://picsum.photos/302/200',
          type: DiscoverType.group,
          members: 320,
        ),
        DiscoverItem(
          id: '4',
          title: 'Nearby People',
          subtitle: 'Connect with people around you',
          imageUrl: 'https://picsum.photos/303/200',
          type: DiscoverType.nearby,
          distance: '2.5 km',
        ),
        DiscoverItem(
          id: '5',
          title: 'Games',
          subtitle: 'Play with friends',
          imageUrl: 'https://picsum.photos/304/200',
          type: DiscoverType.game,
          players: 890,
        ),
      ]);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discover',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search discover...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // Categories
          _buildCategories(),

          // Discover items
          _buildDiscoverItems(),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ['All', 'Live', 'Videos', 'Groups', 'People', 'Games'];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(categories[index]),
              selected: index == 0,
              onSelected: (_) {},
            ),
          );
        },
      ),
    );
  }

  Widget _buildDiscoverItems() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildDiscoverCard(item);
      },
    );
  }

  Widget _buildDiscoverCard(DiscoverItem item) {
    return GestureDetector(
      onTap: () => _handleItemTap(item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey.shade200, height: 120),
                  ),
                  // Live badge
                  if (item.type == DiscoverType.live)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'LIVE',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Viewers count
                  if (item.type == DiscoverType.live)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${item.viewers} viewers',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Stats
                  Row(
                    children: [
                      Icon(
                        _getIconForType(item.type),
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getStatsText(item),
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
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(DiscoverType type) {
    switch (type) {
      case DiscoverType.live:
        return Icons.remove_red_eye;
      case DiscoverType.video:
        return Icons.thumb_up;
      case DiscoverType.group:
        return Icons.group;
      case DiscoverType.nearby:
        return Icons.location_on;
      case DiscoverType.game:
        return Icons.sports_esports;
    }
  }

  String _getStatsText(DiscoverItem item) {
    switch (item.type) {
      case DiscoverType.live:
        return '${item.viewers} viewers';
      case DiscoverType.video:
        return '${item.likes} likes';
      case DiscoverType.group:
        return '${item.members} members';
      case DiscoverType.nearby:
        return item.distance;
      case DiscoverType.game:
        return '${item.players} playing';
    }
  }

  void _handleItemTap(DiscoverItem item) {
    switch (item.type) {
      case DiscoverType.live:
        Navigator.pushNamed(context, '/live-stream');
        break;
      case DiscoverType.video:
        // Open video
        break;
      case DiscoverType.group:
        // Open group
        break;
      case DiscoverType.nearby:
        // Open nearby people
        break;
      case DiscoverType.game:
        // Open games
        break;
    }
  }
}

enum DiscoverType { live, video, group, nearby, game }

class DiscoverItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final DiscoverType type;
  final int viewers;
  final int likes;
  final int members;
  final String distance;
  final int players;

  DiscoverItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.type,
    this.viewers = 0,
    this.likes = 0,
    this.members = 0,
    this.distance = '',
    this.players = 0,
  });
}
