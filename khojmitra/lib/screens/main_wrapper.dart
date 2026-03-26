// ============================================================
// screens/main_wrapper.dart
// Bottom navigation bar wrapper with dark mode toggle
// ============================================================

import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'home_screen.dart';
import 'item_listing_screen.dart';
import 'report_item_screen.dart';
import 'profile_screen.dart';

// ── Simple Theme Notifier ──────────────────────────────────
class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  void toggle() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

// Global singleton accessible from main.dart
final themeNotifier = ThemeNotifier();

// ── Main Wrapper ───────────────────────────────────────────
class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  // 3 actual screens: Home, Browse, Profile
  final List<Widget> _screens = const [
    HomeScreen(),
    ItemListingScreen(),
    ProfileScreen(),
  ];

  void _onNavTap(int navIndex) {
    if (navIndex == 2) {
      // Central "+" → open Report screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ReportItemScreen(),
        ),
      );
    } else if (navIndex == 3) {
      // Theme toggle handled in nav item
    } else if (navIndex == 4) {
      setState(() => _currentIndex = 2);
    } else {
      setState(() => _currentIndex = navIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// ── Custom Bottom Nav Bar ──────────────────────────────────
class _CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CustomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: '🏠',
                  label: 'Home',
                  isActive: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: '📋',
                  label: 'Browse',
                  isActive: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
              ),

              // Center "+" button
              GestureDetector(
                onTap: () => onTap(2),
                child: Container(
                  width: 56,
                  height: 56,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    gradient: AppGradients.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.buttonShadow,
                  ),
                  child: const Center(
                    child: Text(
                      '➕',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: _NavItem(
                  icon: isDark ? '☀️' : '🌙',
                  label: isDark ? 'Light' : 'Dark',
                  isActive: false,
                  onTap: () => themeNotifier.toggle(),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: '👤',
                  label: 'Profile',
                  isActive: currentIndex == 2,
                  onTap: () => onTap(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Nav Item Widget ────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}