import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      enableDrag: false,
      builder: (context) => GameOverlay(gameUrl: url, gameName: name),
    );
  }

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  late final WebViewController _webViewController;
  bool _isLoading = true;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLoad();
    _initWebView();
  }

  Future<void> _checkFirstLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'game_loaded_${widget.gameUrl.hashCode}';
    _isFirstLoad = !(prefs.getBool(key) ?? false);
  }

  Future<void> _markAsLoaded() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'game_loaded_${widget.gameUrl.hashCode}';
    await prefs.setBool(key, true);
  }

  void _initWebView() {
    print("=== GAME OVERLAY DEBUG ===");
    print("Game Name: ${widget.gameName}");
    print("Game URL: ${widget.gameUrl}");
    print("First Load: $_isFirstLoad");

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent("Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36")
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (String url) async {
            if (mounted) setState(() => _isLoading = false);
            if (_isFirstLoad) {
              await _markAsLoaded();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.gameUrl));
  }

  @override
  Widget build(BuildContext context) {
    final double targetHeight = MediaQuery.of(context).size.height * 0.6;

    return Container(
      height: targetHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Stack(
          children: [
            WebViewWidget(controller: _webViewController),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Color(0xFF1DE9B6)),
                      const SizedBox(height: 16),
                      Text(
                        _isFirstLoad
                            ? 'loading...Please wait'
                            : 'Loading game...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
