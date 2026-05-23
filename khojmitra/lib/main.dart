// // ============================================================
// // main.dart
// // Entry point for KhojMitra.AI
// // ============================================================

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'utils/theme.dart';
// import 'screens/splash_screen.dart';
// import 'screens/main_wrapper.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Lock to portrait mode for consistent UI
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   // Make status bar transparent
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ),
//   );

//   runApp(const KhojMitraApp());
// }

// /// Root application widget with theme toggle support
// class KhojMitraApp extends StatefulWidget {
//   const KhojMitraApp({super.key});

//   @override
//   State<KhojMitraApp> createState() => KhojMitraAppState();
// }

// class KhojMitraAppState extends State<KhojMitraApp> {
//   @override
//   void initState() {
//     super.initState();
//     // Listen to theme changes and rebuild
//     themeNotifier.addListener(() {
//       if (mounted) setState(() {});
//     });
//   }

// @override
// Widget build(BuildContext context) {
//   return AnimatedBuilder(
//     animation: themeNotifier,
//     builder: (context, _) {
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'KhojMitra.AI',
//         theme: lightTheme,
//         darkTheme: darkTheme,
//         themeMode:
//             themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
//         home: const SplashScreen(),
//       );
//     },
//   );
// }
// }

// ============================================================
// main.dart
// Entry point — Firebase init, auth gate, theme toggle
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/main_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before running the app
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const KhojMitraApp());
}

// ── Theme notifier (ChangeNotifier for live switching) ─────
class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;
  void toggle() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

final themeNotifier = ThemeNotifier();

// ── Root App Widget ────────────────────────────────────────
class KhojMitraApp extends StatefulWidget {
  const KhojMitraApp({super.key});
  @override
  State<KhojMitraApp> createState() => _KhojMitraAppState();
}

class _KhojMitraAppState extends State<KhojMitraApp> {
  @override
  void initState() {
    super.initState();
    themeNotifier.addListener(() { if (mounted) setState(() {}); });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KhojMitra.AI',
      theme: lightTheme.copyWith(
  textTheme: GoogleFonts.poppinsTextTheme(
    lightTheme.textTheme,
  ),
),

darkTheme: darkTheme.copyWith(
  textTheme: GoogleFonts.poppinsTextTheme(
    darkTheme.textTheme,
  ),
),

themeMode: themeNotifier.isDark
    ? ThemeMode.dark
    : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}