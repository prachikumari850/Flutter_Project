// // // ============================================================
// // // screens/home_screen.dart
// // // Main home dashboard with search, categories, recent items
// // // ============================================================

// // import 'package:flutter/material.dart';
// // import '../utils/theme.dart';
// // import '../widgets/common_widgets.dart';
// // import '../data/dummy_data.dart';
// // import '../models/item_model.dart';
// // import 'item_detail_screen.dart';
// // import 'report_item_screen.dart';
// // import 'item_listing_screen.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   final _searchController = TextEditingController();
// //   String _searchQuery = '';

// //   @override
// //   void dispose() {
// //     _searchController.dispose();
// //     super.dispose();
// //   }

// //   List<ItemModel> get _filteredItems {
// //     if (_searchQuery.isEmpty) return dummyItems.take(4).toList();
// //     return dummyItems
// //         .where((item) =>
// //             item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
// //             item.description
// //                 .toLowerCase()
// //                 .contains(_searchQuery.toLowerCase()))
// //         .toList();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;

// //     return Scaffold(
// //       body: CustomScrollView(
// //         slivers: [
// //           // ── App Bar with greeting ──────────────────────
// //           SliverAppBar(
// //             expandedHeight: 180,
// //             floating: false,
// //             pinned: true,
// //             automaticallyImplyLeading: false,
// //             flexibleSpace: FlexibleSpaceBar(
// //               background: Container(
// //                 decoration: const BoxDecoration(
// //                   gradient: LinearGradient(
// //                     colors: [Color(0xFF1A237E), Color(0xFF3F51B5)],
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                   ),
// //                 ),
// //                 child: Stack(
// //                   children: [
// //                     // Decorative circle
// //                     Positioned(
// //                       top: -30,
// //                       right: -30,
// //                       child: Container(
// //                         width: 160,
// //                         height: 160,
// //                         decoration: BoxDecoration(
// //                           shape: BoxShape.circle,
// //                           color: Colors.white.withOpacity(0.05),
// //                         ),
// //                       ),
// //                     ),
// //                     SafeArea(
// //                       child: Padding(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 20, vertical: 16),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Row(
// //                               mainAxisAlignment:
// //                                   MainAxisAlignment.spaceBetween,
// //                               children: [
// //                                 Column(
// //                                   crossAxisAlignment:
// //                                       CrossAxisAlignment.start,
// //                                   children: [
// //                                     Text(
// //                                       'Good Morning! 👋',
// //                                       style: TextStyle(
// //                                         color:
// //                                             Colors.white.withOpacity(0.75),
// //                                         fontSize: 14,
// //                                       ),
// //                                     ),
// //                                     const Text(
// //                                       'Demo User',
// //                                       style: TextStyle(
// //                                         color: Colors.white,
// //                                         fontSize: 22,
// //                                         fontWeight: FontWeight.w800,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                                 // Avatar
// //                                 Container(
// //                                   width: 46,
// //                                   height: 46,
// //                                   decoration: BoxDecoration(
// //                                     shape: BoxShape.circle,
// //                                     color: AppColors.accent,
// //                                     border: Border.all(
// //                                         color: Colors.white.withOpacity(0.3),
// //                                         width: 2),
// //                                   ),
// //                                   child: const Center(
// //                                     child: Text('🧑',
// //                                         style: TextStyle(fontSize: 22)),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                             const SizedBox(height: 16),
// //                             // Stats row
// //                             Row(
// //                               children: [
// //                                 _StatChip(
// //                                     label: '${dummyItems.where((i) => i.status == 'lost').length} Lost',
// //                                     color: AppColors.lost),
// //                                 const SizedBox(width: 10),
// //                                 _StatChip(
// //                                     label: '${dummyItems.where((i) => i.status == 'found').length} Found',
// //                                     color: AppColors.found),
// //                                 const SizedBox(width: 10),
// //                                 _StatChip(
// //                                     label: '${dummyItems.where((i) => i.isReturned).length} Returned',
// //                                     color: AppColors.accent),
// //                               ],
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),

// //           // ── Body ──────────────────────────────────────
// //           SliverToBoxAdapter(
// //             child: Padding(
// //               padding: const EdgeInsets.all(20),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   // Search Bar
// //                   CustomSearchBar(
// //                     controller: _searchController,
// //                     onChanged: (val) {
// //                       setState(() {
// //                       _searchQuery = val.trim();
// //                     });
// //                   },
// //                   ),
// //                   const SizedBox(height: 24),

// //                   // Quick Action Buttons
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: _QuickActionButton(
// //                           icon: '🔴',
// //                           label: 'Report Lost',
// //                           gradient: const LinearGradient(
// //                             colors: [Color(0xFFEF5350), Color(0xFFE57373)],
// //                           ),
// //                           onTap: () => Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (_) => const ReportItemScreen(
// //                                   initialStatus: 'lost'),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 14),
// //                       Expanded(
// //                         child: _QuickActionButton(
// //                           icon: '🟢',
// //                           label: 'Report Found',
// //                           gradient: const LinearGradient(
// //                             colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
// //                           ),
// //                           onTap: () => Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (_) => const ReportItemScreen(
// //                                   initialStatus: 'found'),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 24),

// //                   // Categories Section
// //                   const Text(
// //                     'Browse Categories',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.w800,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 14),
// //                   SizedBox(
// //                     height: 90,
// //                     child: ListView.separated(
// //                       scrollDirection: Axis.horizontal,
// //                       itemCount: categories.length,
// //                       separatorBuilder: (_, __) => const SizedBox(width: 12),
// //                       itemBuilder: (context, index) {
// //                         final cat = categories[index];
// //                         return _CategoryChip(
// //                           emoji: cat['icon'],
// //                           label: cat['label'],
// //                           color: Color(cat['color'] as int),
// //                           onTap: () => Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (_) => ItemListingScreen(
// //                                   filterCategory: cat['label']),
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                   const SizedBox(height: 24),

// //                   // Recent Items
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       const Text(
// //                         'Recent Activity',
// //                         style: TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.w800,
// //                         ),
// //                       ),
// //                       GestureDetector(
// //                         onTap: () => Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (_) => const ItemListingScreen(),
// //                           ),
// //                         ),
// //                         child: const Text(
// //                           'See All →',
// //                           style: TextStyle(
// //                             color: AppColors.primary,
// //                             fontWeight: FontWeight.w600,
// //                             fontSize: 13,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 14),
// //                 ],
// //               ),
// //             ),
// //           ),

// //           // ── Items List ────────────────────────────────
// //           SliverPadding(
// //             padding: const EdgeInsets.symmetric(horizontal: 20),
// //             sliver: _searchQuery.isNotEmpty && _filteredItems.isEmpty
// //                 ? const SliverToBoxAdapter(
// //                     child: Center(
// //                       child: Column(
// //                         children: [
// //                           SizedBox(height: 40),
// //                           Text('🔍', style: TextStyle(fontSize: 50)),
// //                           SizedBox(height: 12),
// //                           Text('No items found',
// //                               style: TextStyle(
// //                                   fontSize: 16, fontWeight: FontWeight.w600)),
// //                           Text('Try a different search term',
// //                               style: TextStyle(color: AppColors.textSecondary)),
// //                         ],
// //                       ),
// //                     ),
// //                   )
// //                 : SliverList(
// //                     delegate: SliverChildBuilderDelegate(
// //                       (context, index) {
// //                         final item = _filteredItems[index];
// //                         return ItemCard(
// //                           item: item,
// //                           onTap: () => Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (_) => ItemDetailScreen(item: item),
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                       childCount: _filteredItems.length,
// //                     ),
// //                   ),
// //           ),
// //           const SliverToBoxAdapter(child: SizedBox(height: 80)),
// //         ],
// //       ),

// //       // FAB to report item
// //       floatingActionButton: FloatingActionButton.extended(
// //         onPressed: () => Navigator.push(
// //           context,
// //           MaterialPageRoute(builder: (_) => const ReportItemScreen()),
// //         ),
// //         backgroundColor: AppColors.primary,
// //         icon: const Icon(Icons.add, color: Colors.white),
// //         label: const Text(
// //           'Report Item',
// //           style:
// //               TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ── Stat Chip ──────────────────────────────────────────────
// // class _StatChip extends StatelessWidget {
// //   final String label;
// //   final Color color;
// //   const _StatChip({required this.label, required this.color});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.15),
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: color.withOpacity(0.5)),
// //       ),
// //       child: Text(
// //         label,
// //         style: const TextStyle(
// //           color: Colors.white,
// //           fontSize: 12,
// //           fontWeight: FontWeight.w600,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ── Quick Action Button ────────────────────────────────────
// // class _QuickActionButton extends StatelessWidget {
// //   final String icon;
// //   final String label;
// //   final LinearGradient gradient;
// //   final VoidCallback onTap;

// //   const _QuickActionButton({
// //     required this.icon,
// //     required this.label,
// //     required this.gradient,
// //     required this.onTap,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(vertical: 18),
// //         decoration: BoxDecoration(
// //           gradient: gradient,
// //           borderRadius: BorderRadius.circular(16),
// //           boxShadow: [
// //             BoxShadow(
// //               color: gradient.colors.first.withOpacity(0.3),
// //               blurRadius: 12,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           children: [
// //             Text(icon, style: const TextStyle(fontSize: 26)),
// //             const SizedBox(height: 4),
// //             Text(
// //               label,
// //               style: const TextStyle(
// //                 color: Colors.white,
// //                 fontWeight: FontWeight.w700,
// //                 fontSize: 13,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ── Category Chip ──────────────────────────────────────────
// // class _CategoryChip extends StatelessWidget {
// //   final String emoji;
// //   final String label;
// //   final Color color;
// //   final VoidCallback onTap;

// //   const _CategoryChip({
// //     required this.emoji,
// //     required this.label,
// //     required this.color,
// //     required this.onTap,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         width: 80,
// //         decoration: BoxDecoration(
// //           color: isDark ? AppColors.darkCard : Colors.white,
// //           borderRadius: BorderRadius.circular(16),
// //           boxShadow: AppShadows.cardShadow,
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Container(
// //               width: 44,
// //               height: 44,
// //               decoration: BoxDecoration(
// //                 color: color.withOpacity(0.12),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
// //             ),
// //             const SizedBox(height: 6),
// //             Text(
// //               label,
// //               style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
// //               textAlign: TextAlign.center,
// //               overflow: TextOverflow.ellipsis,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // ============================================================
// // screens/home_screen.dart
// // Upgraded: StreamBuilder from Firestore, real user greeting,
// // live stats, personalized dashboard
// // ============================================================

// import 'package:flutter/material.dart';
// import '../utils/theme.dart';
// import '../utils/app_constants.dart';
// import '../widgets/common_widgets.dart';
// import '../services/auth_service.dart';
// import '../services/firestore_service.dart';
// import '../models/item_model.dart';
// import 'item_detail_screen.dart';
// import 'report_item_screen.dart';
// import 'item_listing_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final _searchCtrl = TextEditingController();
//   String _query     = '';
//   final _auth = AuthService();
//   final _fs   = FirestoreService();

//   @override
//   void dispose() {
//     _searchCtrl.dispose();
//     super.dispose();
//   }

//   // Greeting based on time of day
//   String get _greeting {
//     final h = DateTime.now().hour;
//     if (h < 12) return 'Good Morning! ☀️';
//     if (h < 17) return 'Good Afternoon! 👋';
//     return 'Good Evening! 🌙';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<List<ItemModel>>(
//         stream: _fs.streamAllItems(),
//         builder: (context, snap) {
//           final allItems = snap.data ?? [];
//           final lostCount     = allItems.where((i) => i.status == 'lost').length;
//           final foundCount    = allItems.where((i) => i.status == 'found').length;
//           final returnedCount = allItems.where((i) => i.isReturned).length;

//           // Filter for search
//           final displayItems = _query.isEmpty
//               ? allItems.take(6).toList()
//               : allItems.where((i) =>
//                   i.title.toLowerCase().contains(_query.toLowerCase()) ||
//                   i.description.toLowerCase().contains(_query.toLowerCase()))
//                   .toList();

//           return CustomScrollView(
//             slivers: [
//               // ── Gradient App Bar ───────────────────────
//               SliverAppBar(
//                 expandedHeight: 185,
//                 floating: false,
//                 pinned: true,
//                 automaticallyImplyLeading: false,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     decoration: const BoxDecoration(
//                       gradient: AppGradients.headerGradient,
//                     ),
//                     child: Stack(children: [
//                       Positioned(
//                         top: -30, right: -30,
//                         child: Container(
//                           width: 160, height: 160,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.white.withOpacity(0.05),
//                           ),
//                         ),
//                       ),
//                       SafeArea(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(_greeting,
//                                           style: TextStyle(
//                                               color: Colors.white
//                                                   .withOpacity(0.75),
//                                               fontSize: 13)),
//                                       Text(
//                                         _auth.displayName,
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 21,
//                                           fontWeight: FontWeight.w800,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Container(
//                                     width: 44, height: 44,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: AppColors.accent,
//                                       border: Border.all(
//                                           color: Colors.white.withOpacity(0.3),
//                                           width: 2),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         _auth.displayName
//                                                 .substring(0, 1)
//                                                 .toUpperCase(),
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w800,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 14),
//                               // Live stats
//                               Row(children: [
//                                 _StatChip(
//                                     label: '$lostCount Lost',
//                                     color: AppColors.lost),
//                                 const SizedBox(width: 10),
//                                 _StatChip(
//                                     label: '$foundCount Found',
//                                     color: AppColors.found),
//                                 const SizedBox(width: 10),
//                                 _StatChip(
//                                     label: '$returnedCount Returned',
//                                     color: AppColors.accent),
//                               ]),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ]),
//                   ),
//                 ),
//               ),

//               // ── Body ──────────────────────────────────
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomSearchBar(
//                         controller: _searchCtrl,
//                         onChanged: (v) =>
//                             setState(() => _query = v.trim()),
//                       ),
//                       const SizedBox(height: 24),

//                       // Quick actions
//                       Row(children: [
//                         Expanded(child: _QuickBtn(
//                           icon: '🔴', label: 'Report Lost',
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFFEF5350), Color(0xFFE57373)]),
//                           onTap: () => _pushReport('lost'),
//                         )),
//                         const SizedBox(width: 14),
//                         Expanded(child: _QuickBtn(
//                           icon: '🟢', label: 'Report Found',
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFF66BB6A), Color(0xFF81C784)]),
//                           onTap: () => _pushReport('found'),
//                         )),
//                       ]),
//                       const SizedBox(height: 24),

//                       // Categories
//                       const Text('Browse Categories',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.w800)),
//                       const SizedBox(height: 14),
//                       SizedBox(
//                         height: 90,
//                         child: ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: AppConstants.categories.length,
//                           separatorBuilder: (_, __) =>
//                               const SizedBox(width: 12),
//                           itemBuilder: (ctx, i) {
//                             final cat = AppConstants.categories[i];
//                             return _CategoryChip(
//                               emoji: cat['icon'] as String,
//                               label: cat['label'] as String,
//                               color: Color(cat['color'] as int),
//                               onTap: () => Navigator.push(ctx,
//                                 MaterialPageRoute(builder: (_) =>
//                                   ItemListingScreen(
//                                       filterCategory: cat['label'] as String)),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 24),

//                       // Recent header
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text('Recent Activity',
//                               style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w800)),
//                           GestureDetector(
//                             onTap: () => Navigator.push(context,
//                               MaterialPageRoute(
//                                   builder: (_) => const ItemListingScreen())),
//                             child: const Text('See All →',
//                                 style: TextStyle(
//                                     color: AppColors.primary,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 13)),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 14),
//                     ],
//                   ),
//                 ),
//               ),

//               // ── Item List ──────────────────────────────
//               if (snap.connectionState == ConnectionState.waiting)
//                 const SliverToBoxAdapter(
//                   child: Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(40),
//                       child: CircularProgressIndicator(
//                           color: AppColors.primary),
//                     ),
//                   ),
//                 )
//               else if (snap.hasError)
//                 SliverToBoxAdapter(
//                   child: ErrorState(message: 'Failed to load items.'),
//                 )
//               else if (displayItems.isEmpty && _query.isNotEmpty)
//                 const SliverToBoxAdapter(
//                   child: EmptyState(
//                     emoji: '🔍',
//                     title: 'No items found',
//                     subtitle: 'Try a different search term',
//                   ),
//                 )
//               else if (allItems.isEmpty)
//                 const SliverToBoxAdapter(
//                   child: EmptyState(
//                     emoji: '📭',
//                     title: 'No items yet',
//                     subtitle: 'Be the first to report a lost or found item!',
//                   ),
//                 )
//               else
//                 SliverPadding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   sliver: SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (ctx, i) => ItemCard(
//                         item: displayItems[i],
//                         onTap: () => Navigator.push(ctx,
//                           MaterialPageRoute(
//                             builder: (_) => ItemDetailScreen(
//                                 item: displayItems[i]))),
//                       ),
//                       childCount: displayItems.length,
//                     ),
//                   ),
//                 ),
//               const SliverToBoxAdapter(child: SizedBox(height: 80)),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => _pushReport(null),
//         backgroundColor: AppColors.primary,
//         icon: const Icon(Icons.add, color: Colors.white),
//         label: const Text('Report Item',
//             style: TextStyle(
//                 color: Colors.white, fontWeight: FontWeight.w700)),
//       ),
//     );
//   }

//   void _pushReport(String? status) {
//     Navigator.push(context,
//         MaterialPageRoute(
//             builder: (_) =>
//                 ReportItemScreen(initialStatus: status)));
//   }
// }

// // ── Stat Chip ──────────────────────────────────────────────
// class _StatChip extends StatelessWidget {
//   final String label; final Color color;
//   const _StatChip({required this.label, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.5)),
//       ),
//       child: Text(label,
//           style: const TextStyle(
//               color: Colors.white, fontSize: 12,
//               fontWeight: FontWeight.w600)),
//     );
//   }
// }

// // ── Quick Action Button ────────────────────────────────────
// class _QuickBtn extends StatelessWidget {
//   final String icon; final String label;
//   final LinearGradient gradient; final VoidCallback onTap;
//   const _QuickBtn({required this.icon, required this.label,
//       required this.gradient, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 18),
//         decoration: BoxDecoration(
//           gradient: gradient, borderRadius: BorderRadius.circular(16),
//           boxShadow: [BoxShadow(
//             color: gradient.colors.first.withOpacity(0.3),
//             blurRadius: 12, offset: const Offset(0, 4),
//           )],
//         ),
//         child: Column(children: [
//           Text(icon, style: const TextStyle(fontSize: 26)),
//           const SizedBox(height: 4),
//           Text(label, style: const TextStyle(
//               color: Colors.white, fontWeight: FontWeight.w700,
//               fontSize: 13)),
//         ]),
//       ),
//     );
//   }
// }

// // ── Category Chip ──────────────────────────────────────────
// class _CategoryChip extends StatelessWidget {
//   final String emoji; final String label;
//   final Color color; final VoidCallback onTap;
//   const _CategoryChip({required this.emoji, required this.label,
//       required this.color, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 80,
//         decoration: BoxDecoration(
//           color: isDark ? AppColors.darkCard : Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: AppShadows.cardShadow,
//         ),
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Container(
//             width: 44, height: 44,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.12), shape: BoxShape.circle),
//             child: Center(
//                 child: Text(emoji, style: const TextStyle(fontSize: 22))),
//           ),
//           const SizedBox(height: 6),
//           Text(label,
//               style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
//               textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
//         ]),
//       ),
//     );
//   }
// }

// ============================================================
// screens/home_screen.dart
// Firebase + Firestore upgraded Home Screen
// ============================================================

import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/app_constants.dart';
import '../widgets/common_widgets.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/item_model.dart';
import 'item_detail_screen.dart';
import 'report_item_screen.dart';
import 'item_listing_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();

  String _query = '';

  late final AuthService _auth;
  late final FirestoreService _fs;

  @override
  void initState() {
    super.initState();
    _auth = AuthService();
    _fs = FirestoreService();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String get _greeting {
    final h = DateTime.now().hour;

    if (h < 12) return 'Good Morning! ☀️';
    if (h < 17) return 'Good Afternoon! 👋';

    return 'Good Evening! 🌙';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<ItemModel>>(
        stream: _fs.streamAllItems(),
        builder: (context, snap) {
          final allItems =
              snap.hasData ? snap.data! : <ItemModel>[];

          final lostCount =
              allItems.where((i) => i.status == 'lost').length;

          final foundCount =
              allItems.where((i) => i.status == 'found').length;

          final returnedCount =
              allItems.where((i) => i.isReturned).length;

          final displayItems = _query.isEmpty
              ? allItems.take(6).toList()
              : allItems.where((i) {
                  return i.title
                          .toLowerCase()
                          .contains(_query.toLowerCase()) ||
                      i.description
                          .toLowerCase()
                          .contains(_query.toLowerCase());
                }).toList();

          return CustomScrollView(
            slivers: [
              // =========================================================
              // APP BAR
              // =========================================================

              SliverAppBar(
                expandedHeight: 185,
                pinned: true,
                floating: false,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppGradients.headerGradient,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -30,
                          right: -30,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Colors.white.withOpacity(0.05),
                            ),
                          ),
                        ),

                        SafeArea(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          _greeting,
                                          style: TextStyle(
                                            color: Colors.white
                                                .withOpacity(
                                                    0.75),
                                            fontSize: 13,
                                          ),
                                        ),

                                        Text(
                                          _auth
                                                  .displayName
                                                  .isNotEmpty
                                              ? _auth
                                                  .displayName
                                              : 'User',
                                          style:
                                              const TextStyle(
                                            color:
                                                Colors.white,
                                            fontSize: 21,
                                            fontWeight:
                                                FontWeight
                                                    .w800,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Avatar
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration:
                                          BoxDecoration(
                                        shape:
                                            BoxShape.circle,
                                        color:
                                            AppColors.accent,
                                        border: Border.all(
                                          color: Colors.white
                                              .withOpacity(
                                                  0.3),
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          (_auth.displayName
                                                      .isNotEmpty
                                                  ? _auth
                                                      .displayName[0]
                                                  : 'U')
                                              .toUpperCase(),
                                          style:
                                              const TextStyle(
                                            color:
                                                Colors.white,
                                            fontWeight:
                                                FontWeight
                                                    .w800,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                // Stats
                                Row(
                                  children: [
                                    _StatChip(
                                      label:
                                          '$lostCount Lost',
                                      color:
                                          AppColors.lost,
                                    ),

                                    const SizedBox(
                                        width: 10),

                                    _StatChip(
                                      label:
                                          '$foundCount Found',
                                      color:
                                          AppColors.found,
                                    ),

                                    const SizedBox(
                                        width: 10),

                                    _StatChip(
                                      label:
                                          '$returnedCount Returned',
                                      color:
                                          AppColors.accent,
                                    ),
                                  ],
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

              // =========================================================
              // BODY
              // =========================================================

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      CustomSearchBar(
                        controller: _searchCtrl,
                        onChanged: (v) {
                          setState(() {
                            _query = v.trim();
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      // =================================================
                      // QUICK ACTIONS
                      // =================================================

                      Row(
                        children: [
                          Expanded(
                            child: _QuickBtn(
                              icon: '🔴',
                              label: 'Report Lost',
                              gradient:
                                  const LinearGradient(
                                colors: [
                                  Color(0xFFEF5350),
                                  Color(0xFFE57373),
                                ],
                              ),
                              onTap: () =>
                                  _pushReport('lost'),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: _QuickBtn(
                              icon: '🟢',
                              label: 'Report Found',
                              gradient:
                                  const LinearGradient(
                                colors: [
                                  Color(0xFF66BB6A),
                                  Color(0xFF81C784),
                                ],
                              ),
                              onTap: () =>
                                  _pushReport('found'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // =================================================
                      // CATEGORIES
                      // =================================================

                      const Text(
                        'Browse Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 14),

                      SizedBox(
                        height: 90,
                        child: ListView.separated(
                          scrollDirection:
                              Axis.horizontal,
                          itemCount:
                              AppConstants.categories.length,
                          separatorBuilder:
                              (_, __) =>
                                  const SizedBox(
                                      width: 12),
                          itemBuilder: (ctx, i) {
                            final cat =
                                AppConstants.categories[i];

                            return _CategoryChip(
                              emoji:
                                  cat['icon'] as String,
                              label:
                                  cat['label'] as String,
                              color: Color(
                                  cat['color'] as int),
                              onTap: () {
                                Navigator.push(
                                  ctx,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ItemListingScreen(
                                      filterCategory:
                                          cat['label']
                                              as String,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // =================================================
                      // RECENT HEADER
                      // =================================================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          const Text(
                            'Recent Activity',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ItemListingScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'See All →',
                              style: TextStyle(
                                color:
                                    AppColors.primary,
                                fontWeight:
                                    FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),

              // =========================================================
              // STATES
              // =========================================================

              if (snap.connectionState ==
                  ConnectionState.waiting)
                const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child:
                          CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                )

              else if (snap.hasError)
                const SliverToBoxAdapter(
                  child: ErrorState(
                    message:
                        'Failed to load items.',
                  ),
                )

              else if (displayItems.isEmpty &&
                  _query.isNotEmpty)
                const SliverToBoxAdapter(
                  child: EmptyState(
                    emoji: '🔍',
                    title: 'No items found',
                    subtitle:
                        'Try a different search term',
                  ),
                )

              else if (allItems.isEmpty)
                const SliverToBoxAdapter(
                  child: EmptyState(
                    emoji: '📭',
                    title: 'No items yet',
                    subtitle:
                        'Be the first to report a lost or found item!',
                  ),
                )

              // =========================================================
              // ITEMS LIST
              // =========================================================

              else
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  sliver: SliverList(
                    delegate:
                        SliverChildBuilderDelegate(
                      (ctx, i) {
                        return ItemCard(
                          item: displayItems[i],
                          onTap: () {
                            Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ItemDetailScreen(
                                  item:
                                      displayItems[i],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount:
                          displayItems.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          );
        },
      ),

      // =============================================================
      // FAB
      // =============================================================

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () => _pushReport(null),
        backgroundColor: AppColors.primary,
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          'Report Item',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _pushReport(String? status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ReportItemScreen(initialStatus: status),
      ),
    );
  }
}

// ============================================================
// STAT CHIP
// ============================================================

class _StatChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.5),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ============================================================
// QUICK BUTTON
// ============================================================

class _QuickBtn extends StatelessWidget {
  final String icon;
  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _QuickBtn({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius:
              BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first
                  .withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              icon,
              style:
                  const TextStyle(fontSize: 26),
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CATEGORY CHIP
// ============================================================

class _CategoryChip extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkCard
              : Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color:
                    color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

