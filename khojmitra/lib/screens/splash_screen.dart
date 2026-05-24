// ============================================================
// screens/splash_screen.dart
// Splash → checks Firebase auth state → routes accordingly
// ============================================================

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/theme.dart';
// import '../services/notification_service.dart';
import 'login_screen.dart';
import 'main_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double>  _logoScale;
  late Animation<double>  _logoOpacity;
  late Animation<double>  _textOpacity;
  late Animation<Offset>  _textSlide;
  late Animation<double>  _pulse;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn));

    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(_textCtrl);
    _textSlide   = Tween<Offset>(
      begin: const Offset(0, 0.4), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));

    _logoCtrl.forward().then((_) => _textCtrl.forward());

    // After 2.8s → check auth state and navigate
    Future.delayed(const Duration(milliseconds: 2800), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;

    // Init notifications
    // await NotificationService().init(); 

    // Check if user is already signed in (persistent login)
    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            user != null ? const MainWrapper() : const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF3F51B5), Color(0xFF26A69A)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(top: -80, right: -80,
              child: _circle(280)),
            Positioned(bottom: -120, left: -60,
              child: _circle(320)),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pulsing logo
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, child) =>
                        Transform.scale(scale: _pulse.value, child: child),
                    child: FadeTransition(
                      opacity: _logoOpacity,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Container(
                          width: 130, height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3), width: 2),
                          ),
                          child: const Center(
                            child: Text('🔍', style: TextStyle(fontSize: 60)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: Column(children: [
                        const Text('KhojMitra',
                            style: TextStyle(
                              color: Colors.white, fontSize: 38,
                              fontWeight: FontWeight.w900, letterSpacing: 1.0,
                            )),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('.AI',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(height: 12),
                        Text('✨ Smart AI Locator',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 17)),
                        const SizedBox(height: 6),
                        Text('ABESIT Group of Institutions',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 13)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 80),

                  // Loading
                  FadeTransition(
                    opacity: _textOpacity,
                    child: Column(children: [
                      SizedBox(
                        width: 40, height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.6)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Initializing AI Engine...',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12)),
                    ]),
                  ),
                ],
              ),
            ),

            // Version
            Positioned(
              bottom: 30, left: 0, right: 0,
              child: FadeTransition(
                opacity: _textOpacity,
                child: Text('v2.0.0 • Firebase Edition',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.35), fontSize: 11)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(double size) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(0.05),
    ),
  );
}