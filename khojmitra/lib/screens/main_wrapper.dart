// ============================================================
// screens/main_wrapper.dart
// Bottom nav wrapper — same structure as v1, kept intact
// ============================================================

import 'package:flutter/material.dart';
import '../main.dart' show themeNotifier;
import '../utils/theme.dart';
import 'home_screen.dart';
import 'item_listing_screen.dart';
import 'report_item_screen.dart';
import 'profile_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});
  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _idx = 0;

  // 3 persistent screens (IndexedStack keeps state alive)
  final List<Widget> _screens = const [
    HomeScreen(),
    ItemListingScreen(),
    ProfileScreen(),
  ];

  void _onTap(int navIdx) {
    if (navIdx == 2) {
      // Central "+" → push Report screen as new route
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ReportItemScreen()));
    } else if (navIdx == 3) {
      themeNotifier.toggle(); // dark/light toggle
    } else if (navIdx == 4) {
      setState(() => _idx = 2); // Profile
    } else {
      setState(() => _idx = navIdx);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _screens),
      bottomNavigationBar: _NavBar(currentIdx: _idx, onTap: _onTap),
    );
  }
}

// ── Custom Nav Bar ─────────────────────────────────────────
class _NavBar extends StatelessWidget {
  final int currentIdx;
  final ValueChanged<int> onTap;
  const _NavBar({required this.currentIdx, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20, offset: const Offset(0, -5),
        )],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(children: [
            Expanded(child: _NavItem(icon: '🏠', label: 'Home',
                isActive: currentIdx == 0, onTap: () => onTap(0))),
            Expanded(child: _NavItem(icon: '📋', label: 'Browse',
                isActive: currentIdx == 1, onTap: () => onTap(1))),
            // Central FAB-style button
            GestureDetector(
              onTap: () => onTap(2),
              child: Container(
                width: 56, height: 56,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.buttonShadow,
                ),
                child: const Center(
                    child: Text('➕', style: TextStyle(fontSize: 24))),
              ),
            ),
            Expanded(child: _NavItem(
                icon: isDark ? '☀️' : '🌙',
                label: isDark ? 'Light' : 'Dark',
                isActive: false, onTap: () => onTap(3))),
            Expanded(child: _NavItem(icon: '👤', label: 'Profile',
                isActive: currentIdx == 2, onTap: () => onTap(4))),
          ]),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon; final String label;
  final bool isActive; final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label,
      required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          )),
        ]),
      ),
    );
  }
}