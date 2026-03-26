// ============================================================
// main.dart
// Entry point for KhojMitra.AI
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/main_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode for consistent UI
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Make status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const KhojMitraApp());
}

/// Root application widget with theme toggle support
class KhojMitraApp extends StatefulWidget {
  const KhojMitraApp({super.key});

  @override
  State<KhojMitraApp> createState() => KhojMitraAppState();
}

class KhojMitraAppState extends State<KhojMitraApp> {
  @override
  void initState() {
    super.initState();
    // Listen to theme changes and rebuild
    themeNotifier.addListener(() {
      if (mounted) setState(() {});
    });
  }

@override
Widget build(BuildContext context) {
  return AnimatedBuilder(
    animation: themeNotifier,
    builder: (context, _) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KhojMitra.AI',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode:
            themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
        home: const SplashScreen(),
      );
    },
  );
}
}