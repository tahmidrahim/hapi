import 'package:flutter/material.dart';
import 'package:hapi/models/game_model.dart';
import 'package:hapi/services/game_api_service.dart';
import 'package:hapi/widgets/game/game_overlay.dart';

class GameSelector {
  static Future<void> show(BuildContext context, String userId) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Allows content wrapping
      builder: (context) => FutureBuilder<List<GameModel>>(
        future: GameApiService().fetchGames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSheetWrapper(
              child: const SizedBox(
                height: 180,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF1DE9B6)),
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildSheetWrapper(
              child: const SizedBox(
                height: 150,
                child: Center(
                  child: Text(
                    'No games available',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ),
              ),
            );
          }

          final games = snapshot.data!;

          return _buildSheetWrapper(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pull Bar / Notch Indicator (Top Center)
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Section Title matching the SS style
                const Text(
                  'Party Game',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Dynamic 4-column Grid for your backend games list
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: games.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        4, // 4 games per row matching the screenshot
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8, // Elegant vertical profile ratio
                  ),
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return _gameItem(
                      context,
                      game.name,
                      _getGameIcon(game.name),
                      _getGameColor(game.name),
                      () {
                        Navigator.pop(context);
                        final gameUrl =
                            // "${game.curl}?userid=$userId&token=187871878";
                            "${game.curl}?userid=2?token=187871878";
                        _openGame(context, gameUrl, game.name);
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  // Edge-to-edge pure white presentation container wrapping your content safely
  static Widget _buildSheetWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 20),
      child: SafeArea(child: child),
    );
  }

  // Color dynamic assignment to give game boxes that rich distinct UI pop
  static Color _getGameColor(String name) {
    switch (name.toLowerCase()) {
      case 'lucky fruit':
        return const Color(0xFFFF5252); // Soft Vibrant Red
      case 'ludo':
        return const Color(0xFFFFB300); // Amber Yellow
      case 'super 777':
        return const Color(0xFFE040FB); // Neon Purple
      default:
        return const Color(0xFF1DE9B6); // Teal Hapi Accent
    }
  }

  static IconData _getGameIcon(String gameName) {
    switch (gameName.toLowerCase()) {
      case 'super 777':
        return Icons.casino;
      case 'lucky fruit':
        return Icons.blur_on;
      case 'ludo':
        return Icons.extension;
      default:
        return Icons.videogame_asset;
    }
  }

  // Custom UI block rendering elegant background layers and text limits
  static Widget _gameItem(
    BuildContext context,
    String title,
    IconData icon,
    Color accentColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(
                0.12,
              ), // Subtle elegant color tint background
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: accentColor, size: 30),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  static void _openGame(BuildContext context, String gameUrl, String gameName) {
    GameOverlay.show(
      context,
      gameUrl,
      gameName,
    ); // Use bottom sheet instead of dialog
  }
}
