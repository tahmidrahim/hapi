// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hapi/providers/chat_provider.dart';
import 'theme.dart';
import 'router.dart' hide routerProvider; // ADD THIS IMPORT

class KapiApp extends ConsumerWidget {
  const KapiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router =
        ref.watch(routerProvider); // This needs the import from router.dart

    return MaterialApp.router(
      title: 'Kapi',
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
