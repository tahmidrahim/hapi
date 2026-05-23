import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hapi/providers/user_provider.dart';
import 'package:hapi/widgets/animated_avatar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        slivers: [
          _buildHeader(user),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildMainActionsCard(),
                  const SizedBox(height: 16),
                  _buildSettingsCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(UserModel user) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1DE9B6), Color(0xFFA7FFEB)],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: AnimatedAvatar(
                    imageUrl: user.photoUrl,
                    radius: 20,
                    animationSize: 74,
                  ),
                  title: Text(
                    user.name.isNotEmpty ? user.name : 'No name set',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text("ID: ${user.id}"),
                  trailing: const Icon(Icons.chevron_right),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem("0", "Followers"),
                    _statItem("0", "Following"),
                    _statItem("0", "Visitors", badge: "+4"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statItem(String value, String label, {String? badge}) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (badge != null)
              Positioned(
                top: -10,
                right: -15,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
          ],
        ),
        Text(label, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }

  Widget _buildMainActionsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: Column(
        children: [
          _menuTile(Icons.account_balance_wallet, "Wallet", Colors.teal),
          _menuTile(
            Icons.card_giftcard,
            "Invite Friends",
            Colors.orange,
            trailing: _earnBadge(),
          ),
          _menuTile(Icons.stars, "SVIP", Colors.black, subtext: "Join Now"),
          _menuTile(Icons.military_tech, "Medal", Colors.blue),
          _menuTile(Icons.leaderboard, "Level", Colors.orangeAccent),
          _menuTile(Icons.favorite, "CP/Friend", Colors.pink),
          _menuTile(Icons.groups, "Family", Colors.orange, subtext: "Join Now"),
          _menuTile(Icons.shopping_bag, "Store", Colors.purple),
          _menuTile(Icons.checkroom, "My Items", Colors.lightBlue),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: Column(
        children: [
          _menuTile(
            Icons.language,
            "Language",
            Colors.grey,
            subtext: "English",
          ),
          _menuTile(Icons.email, "Feedback", Colors.grey),
          _menuTile(Icons.settings, "Settings", Colors.grey),
        ],
      ),
    );
  }

  Widget _menuTile(
    IconData icon,
    String title,
    Color color, {
    String? subtext,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (subtext != null)
            Text(subtext, style: const TextStyle(color: Colors.grey)),
          if (trailing != null) trailing,
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _earnBadge() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_fix_high, size: 12, color: Colors.orange),
          Text(
            " Earn Coins",
            style: TextStyle(color: Colors.orange, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
