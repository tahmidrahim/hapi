import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GameOverlay extends StatefulWidget {
  final String gameUrl;
  final String gameName;

  const GameOverlay({super.key, required this.gameUrl, required this.gameName});

  static void show(BuildContext context, String url, String name) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.3),
      enableDrag: false, // Disable dragging
      builder: (context) => GameOverlay(gameUrl: url, gameName: name),
    );
  }

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  late final WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print("=== GAME OVERLAY DEBUG ===");
    print("Game Name: ${widget.gameName}");
    print("Game URL: ${widget.gameUrl}");

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.gameUrl));
  }

  @override
  Widget build(BuildContext context) {
    final double targetHeight = MediaQuery.of(context).size.height * 0.60;

    return Container(
      height: targetHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header with close button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1DE9B6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(Icons.gamepad, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.gameName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // WebView
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _webViewController),
                if (_isLoading)
                  Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1DE9B6),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
