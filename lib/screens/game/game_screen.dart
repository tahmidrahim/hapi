import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hapi/models/game_model.dart';
import 'package:hapi/providers/user_provider.dart';
import 'package:hapi/screens/game/WebViewScreen.dart';
import 'package:hapi/services/game_api_service.dart';

class GameContent extends ConsumerWidget {
  const GameContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(gamesFutureProvider);
    final user = ref.watch(userProvider);

    return gamesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFF1DE9B6)),
      ),
      error: (err, stack) => Center(child: Text("Error: $err")),
      data: (games) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 15,
            childAspectRatio: 0.75,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return GestureDetector(
              onTap: () => _onGameClick(context, ref, game),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 8),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.videogame_asset,
                        size: 40,
                        color: Color(0xFF1DE9B6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    game.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onGameClick(BuildContext context, WidgetRef ref, GameModel game) async {
    final user = ref.read(userProvider);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Loading game...')));

    try {
      final apiService = ref.read(gameApiServiceProvider);
      final success = await apiService.integrateUser(
        userId: user.id,
        username: user.name,
        avatar: user.photoUrl ?? '',
      );

      if (success && context.mounted) {
        final gameUrl = "${game.curl}?userid=2&token=187871878";

        // Open in WebView inside app
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                GameWebViewScreen(gameName: game.name, gameUrl: gameUrl),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
