import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hapi/screens/home/profile_screen.dart';
import 'package:hapi/screens/message/message_screen.dart';

// Provider to ensure the dialog only shows once per session
final dailyRewardShownProvider = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedTab = 0;
  String _selectedCategory = 'Popular';

  final List<Widget> _screens = [
    const HomeContent(),
    const MessageScreen(),
    const ProfileScreen(),
  ];

  // In a real app, this data would come from a Firestore StreamProvider
  final List<Map<String, dynamic>> _liveRooms = [
    {
      'hostName': 'Cristiano Ronaldo',
      'title': 'CR7 Fans Club',
      'viewers': '1.2K',
      'level': '39',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/8/8c/Cristiano_Ronaldo_2018.jpg',
    },
    {
      'hostName': 'Lionel Messi',
      'title': 'Messi Magic',
      'viewers': '980',
      'level': '36',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/c/c1/Lionel_Messi_20180626.jpg',
    },
    {
      'hostName': 'Neymar Jr',
      'title': 'Brazilian Skills',
      'viewers': '856',
      'level': '32',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/b/b1/Neymar_2018.jpg',
    },
    {
      'hostName': 'Kylian Mbappe',
      'title': 'Speed King',
      'viewers': '2.1K',
      'level': '28',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/7/7e/Kylian_Mbapp%C3%A9_2018.jpg',
    },
    {
      'hostName': 'Erling Haaland',
      'title': 'Goal Machine',
      'viewers': '1.8K',
      'level': '27',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/6/6c/Erling_Haaland_2023.jpg',
    },
    {
      'hostName': 'Kevin De Bruyne',
      'title': 'Masterclass',
      'viewers': '654',
      'level': '33',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/5/5e/Kevin_De_Bruyne_2018.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hasShown = ref.read(dailyRewardShownProvider);
      if (!hasShown) {
        _showDailyRewardPopup();
      }
    });
  }

  void _showDailyRewardPopup() {
    ref.read(dailyRewardShownProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: _screens[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        selectedItemColor: const Color(0xFF1DE9B6),
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Message'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

// Extract your home content to a separate widget
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _selectedCategory = 'Popular';

  final List<Map<String, dynamic>> _liveRooms = [
    {
      'hostName': 'Cristiano Ronaldo',
      'title': 'CR7 Fans Club',
      'viewers': '1.2K',
      'level': '39',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/8/8c/Cristiano_Ronaldo_2018.jpg',
    },
    {
      'hostName': 'Lionel Messi',
      'title': 'Messi Magic',
      'viewers': '980',
      'level': '36',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/c/c1/Lionel_Messi_20180626.jpg',
    },
    {
      'hostName': 'Neymar Jr',
      'title': 'Brazilian Skills',
      'viewers': '856',
      'level': '32',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/b/b1/Neymar_2018.jpg',
    },
    {
      'hostName': 'Kylian Mbappe',
      'title': 'Speed King',
      'viewers': '2.1K',
      'level': '28',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/7/7e/Kylian_Mbapp%C3%A9_2018.jpg',
    },
    {
      'hostName': 'Erling Haaland',
      'title': 'Goal Machine',
      'viewers': '1.8K',
      'level': '27',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/6/6c/Erling_Haaland_2023.jpg',
    },
    {
      'hostName': 'Kevin De Bruyne',
      'title': 'Masterclass',
      'viewers': '654',
      'level': '33',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/5/5e/Kevin_De_Bruyne_2018.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildEventBanner(),
                const SizedBox(height: 16),
                _buildQuickAccessGrid(),
                const SizedBox(height: 16),
                _buildTabSwitch(),
              ],
            ),
          ),
        ),
        _buildLiveRoomsGrid(),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: const Color(0xFF1DE9B6),
      elevation: 0,
      title: const Text("Hapi", style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildEventBanner() {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "LEVEL UP RACING",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "FOR COINS",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              child: const Text("Go"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessGrid() {
    return Row(
      children: [
        _quickTile("Ranking", Colors.cyan[50]!, Colors.cyan),
        const SizedBox(width: 8),
        _quickTile("Family", Colors.orange[50]!, Colors.orange),
        const SizedBox(width: 8),
        _quickTile("CP / Friend", Colors.purple[50]!, Colors.purple),
      ],
    );
  }

  Widget _quickTile(String label, Color bg, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.star_outline, color: iconColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSwitch() {
    final tabs = ['Popular', 'Game', 'Video/Music'];
    return Row(
      children: tabs.map((tab) {
        bool isSelected = _selectedCategory == tab;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => setState(() => _selectedCategory = tab),
            child: Column(
              children: [
                Text(
                  tab,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                if (isSelected)
                  Container(
                    height: 2,
                    width: 20,
                    color: const Color(0xFF1DE9B6),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLiveRoomsGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final room = _liveRooms[index % _liveRooms.length];
          return _buildRoomCard(room);
        }, childCount: 10),
      ),
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                room['imageUrl'],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room['hostName'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  room['title'],
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.bar_chart,
                      size: 14,
                      color: Color(0xFF1DE9B6),
                    ),
                    const SizedBox(width: 4),
                    Text(room['viewers'], style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Temporary placeholder for Message screen
class MessagePlaceholder extends StatelessWidget {
  const MessagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Messages - Coming Soon'));
  }
}
