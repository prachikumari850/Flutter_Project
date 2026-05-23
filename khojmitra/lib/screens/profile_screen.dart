// ============================================================
// screens/profile_screen.dart
// Real Firebase user data, StreamBuilder for reward points,
// real logout, my items from Firestore
// ============================================================

import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/common_widgets.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/item_model.dart';
import 'item_detail_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final fs   = FirestoreService();

    return Scaffold(
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: fs.streamUser(auth.uid),
        builder: (context, userSnap) {
          final userData    = userSnap.data;
          final name        = userData?['name']         as String? ?? auth.displayName;
          final email       = userData?['email']        as String? ?? auth.email;
          final points      = userData?['rewardPoints'] as int?    ?? 0;

          return CustomScrollView(slivers: [
            // ── Header ──────────────────────────────────
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
                  child: Stack(children: [
                    Positioned(
                      bottom: -50, left: -50,
                      child: Container(
                        width: 200, height: 200,
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
                            // Avatar initial
                            Container(
                              width: 88, height: 88,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppGradients.accentGradient,
                                border: Border.all(
                                    color: Colors.white, width: 3),
                              ),
                              child: Center(
                                child: Text(
                                  name.isNotEmpty
                                      ? name[0].toUpperCase() : '?',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text(email,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 13)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('🎓 ABESIT Group of Institutions',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),

            // ── Body ────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Live stats from Firestore streams
                    _MyItemsStats(fs: fs, uid: auth.uid, points: points),
                    const SizedBox(height: 24),

                    // Reward info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xFFFFC107).withOpacity(0.1),
                          const Color(0xFFFF9800).withOpacity(0.1),
                        ]),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFFFC107).withOpacity(0.3)),
                      ),
                      child: const Row(children: [
                        Text('🏆', style: TextStyle(fontSize: 32)),
                        SizedBox(width: 14),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reward System',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 15)),
                            SizedBox(height: 4),
                            Text(
                              '+10 pts reporting  •  +20 pts match found\n+30 pts for returning an item',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        )),
                      ]),
                    ),
                    const SizedBox(height: 24),

                    const Text('Account Settings',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800)),
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
                      onTap: () async {
                        await AuthService().signOut();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                            (_) => false,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    const Text('My Uploads',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // ── My items (real-time) ─────────────────────
            _MyItemsSliver(fs: fs, uid: auth.uid),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ]);
        },
      ),
    );
  }
}

// ── Live stats row ─────────────────────────────────────────
class _MyItemsStats extends StatelessWidget {
  final FirestoreService fs;
  final String uid;
  final int points;
  const _MyItemsStats(
      {required this.fs, required this.uid, required this.points});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ItemModel>>(
      stream: fs.streamMyItems(uid),
      builder: (ctx, snap) {
        final myItems = snap.data ?? [];
        final returned = myItems.where((i) => i.isReturned).length;
        return Row(children: [
          _StatCard(emoji: '⭐', value: '$points',
              label: 'Reward Points', color: const Color(0xFFFFC107)),
          const SizedBox(width: 12),
          _StatCard(emoji: '📤', value: '${myItems.length}',
              label: 'My Posts', color: AppColors.primary),
          const SizedBox(width: 12),
          _StatCard(emoji: '✅', value: '$returned',
              label: 'Returned', color: AppColors.found),
        ]);
      },
    );
  }
}

// ── My items sliver list ───────────────────────────────────
class _MyItemsSliver extends StatelessWidget {
  final FirestoreService fs;
  final String uid;
  const _MyItemsSliver({required this.fs, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ItemModel>>(
      stream: fs.streamMyItems(uid),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }
        final items = snap.data ?? [];
        if (items.isEmpty) {
          return const SliverToBoxAdapter(
            child: EmptyState(
              emoji: '📭',
              title: 'No uploads yet',
              subtitle: 'Start by reporting a lost or found item',
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx2, i) => ItemCard(
                item: items[i],
                onTap: () => Navigator.push(ctx2,
                    MaterialPageRoute(
                        builder: (_) => ItemDetailScreen(item: items[i]))),
              ),
              childCount: items.length,
            ),
          ),
        );
      },
    );
  }
}

// ── Stat Card ──────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String emoji, value, label;
  final Color color;
  const _StatCard(
      {required this.emoji, required this.value,
       required this.label,  required this.color});

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
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w900, color: color)),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

// ── Setting Row ────────────────────────────────────────────
class _SettingRow extends StatelessWidget {
  final String icon, label;
  final Color? color;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCard
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.cardShadow,
      ),

      // ✅ FIX
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),

        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          leading: Text(
            icon,
            style: const TextStyle(fontSize: 22),
          ),

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

          onTap: onTap ?? () {},
        ),
      ),
    );
  }
}


