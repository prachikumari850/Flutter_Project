// ============================================================
// screens/profile_screen.dart
// User profile with reward points and my uploads
// ============================================================

import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/common_widgets.dart';
import '../data/dummy_data.dart';
import 'item_detail_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // My items = items posted by "Demo User" or "(You)"
    final myItems = dummyItems
        .where((i) =>
        i.postedBy.toLowerCase().contains('Demo User') ||
        i.postedBy.toLowerCase().contains('you'))
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF26A69A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -50,
                      left: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Avatar
                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppGradients.accentGradient,
                                border: Border.all(
                                    color: Colors.white, width: 3),
                              ),
                              child: const Center(
                                child: Text('🧑',
                                    style: TextStyle(fontSize: 44)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Demo User',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'demo.user@abesit.edu.in',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '🎓 CS 3rd Year • ABESIT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Body ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats cards
                  Row(
                    children: [
                      _StatCard(
                        emoji: '⭐',
                        value: '120',
                        label: 'Reward Points',
                        color: const Color(0xFFFFC107),
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        emoji: '📤',
                        value: '${myItems.length}',
                        label: 'My Posts',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        emoji: '✅',
                        value: '${dummyItems.where((i) => i.isReturned).length}',
                        label: 'Returned',
                        color: AppColors.found,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Reward info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFC107).withOpacity(0.1),
                          const Color(0xFFFF9800).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFFFFC107).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Text('🏆', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Reward System',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '+10 pts for reporting • +50 pts for returning an item',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Settings options
                  const Text(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SettingRow(icon: '🔔', label: 'Notifications'),
                  _SettingRow(icon: '🔒', label: 'Privacy Settings'),
                  _SettingRow(icon: '❓', label: 'Help & Support'),
                  _SettingRow(icon: '📊', label: 'Report History'),
                  const SizedBox(height: 8),
                  _SettingRow(
                    icon: '🚪',
                    label: 'Logout',
                    color: AppColors.lost,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                      },
                  ),
                  const SizedBox(height: 24),

                  // My uploads
                  const Text(
                    'My Uploads',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // My items list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: myItems.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        children: [
                          Text('📭',
                              style: TextStyle(fontSize: 48)),
                          SizedBox(height: 12),
                          Text('No uploads yet',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          Text(
                            'Start by reporting a lost or found item',
                            style: TextStyle(
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => ItemCard(
                        item: myItems[i],
                        onTap: () => Navigator.push(
                          ctx,
                          MaterialPageRoute(
                            builder: (_) =>
                                ItemDetailScreen(item: myItems[i]),
                          ),
                          
                        ),
                      ),
                      childCount: myItems.length,
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

// ── Stat Card ──────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Setting Row ────────────────────────────────────────────
class _SettingRow extends StatelessWidget {
  final String icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap; // 👈 ADD THIS

  const _SettingRow({
    required this.icon,
    required this.label,
    this.color,
    this.onTap, // 👈 ADD THIS
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.cardShadow,
      ),
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 22)),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: color,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppColors.textSecondary,
        ),
        onTap: onTap, // 👈 USE HERE
      ),
    );
  }
}