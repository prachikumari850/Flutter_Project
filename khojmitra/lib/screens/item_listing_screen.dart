// // ============================================================
// // screens/item_listing_screen.dart
// // Shows all items with filter options
// // ============================================================

// import 'package:flutter/material.dart';
// import '../utils/theme.dart';
// import '../widgets/common_widgets.dart';
// import '../data/dummy_data.dart';
// import '../models/item_model.dart';
// import 'item_detail_screen.dart';

// class ItemListingScreen extends StatefulWidget {
//   final String? filterCategory;

//   const ItemListingScreen({super.key, this.filterCategory});

//   @override
//   State<ItemListingScreen> createState() => _ItemListingScreenState();
// }

// class _ItemListingScreenState extends State<ItemListingScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   // Filter items based on tab and search
//   List<ItemModel> _getFilteredItems(String tab) {
//     List<ItemModel> items = dummyItems;

//     // Filter by category if given
//     if (widget.filterCategory != null) {
//       items = items
//           .where((i) => i.category == widget.filterCategory)
//           .toList();
//     }

//     // Filter by tab
//     if (tab == 'lost') {
//       items = items.where((i) => i.status == 'lost').toList();
//     } else if (tab == 'found') {
//       items = items.where((i) => i.status == 'found').toList();
//     }

//     // Filter by search
//     if (_searchQuery.isNotEmpty) {
//       items = items
//           .where((i) =>
//               i.title
//                   .toLowerCase()
//                   .contains(_searchQuery.toLowerCase()) ||
//               i.description
//                   .toLowerCase()
//                   .contains(_searchQuery.toLowerCase()))
//           .toList();
//     }

//     return items;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.filterCategory ?? 'All Items'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new),
//           onPressed: () => Navigator.pop(context),
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: AppColors.primary,
//           unselectedLabelColor: AppColors.textSecondary,
//           indicatorColor: AppColors.primary,
//           indicatorWeight: 3,
//           tabs: const [
//             Tab(text: 'All'),
//             Tab(text: '🔴 Lost'),
//             Tab(text: '🟢 Found'),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           // Search bar
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: CustomSearchBar(
//               controller: _searchController,
//               onChanged: (v) => setState(() => _searchQuery = v),
//             ),
//           ),

//           // Tab views
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _ItemList(items: _getFilteredItems('all')),
//                 _ItemList(items: _getFilteredItems('lost')),
//                 _ItemList(items: _getFilteredItems('found')),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Item List ──────────────────────────────────────────────
// class _ItemList extends StatelessWidget {
//   final List<ItemModel> items;
//   const _ItemList({required this.items});

//   @override
//   Widget build(BuildContext context) {
//     if (items.isEmpty) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('📭', style: TextStyle(fontSize: 60)),
//             SizedBox(height: 16),
//             Text(
//               'No items here',
//               style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
//             ),
//             SizedBox(height: 6),
//             Text(
//               'Nothing matching your filters',
//               style: TextStyle(color: AppColors.textSecondary),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         final item = items[index];
//         return ItemCard(
//           item: item,
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ItemDetailScreen(item: item),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// ============================================================
// screens/item_listing_screen.dart
// Upgraded: StreamBuilder from Firestore, client-side filter
// ============================================================

import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/common_widgets.dart';
import '../services/firestore_service.dart';
import '../models/item_model.dart';
import 'item_detail_screen.dart';

class ItemListingScreen extends StatefulWidget {
  final String? filterCategory;
  const ItemListingScreen({super.key, this.filterCategory});

  @override
  State<ItemListingScreen> createState() => _ItemListingScreenState();
}

class _ItemListingScreenState extends State<ItemListingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _searchCtrl = TextEditingController();
  String _query = '';
  final _fs = FirestoreService();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ItemModel> _filter(List<ItemModel> all, String tab) {
    var items = all;
    // Category filter (from HomeScreen category chip)
    if (widget.filterCategory != null) {
      items = items
          .where((i) => i.category == widget.filterCategory)
          .toList();
    }
    // Tab filter
    if (tab == 'lost')  items = items.where((i) => i.status == 'lost').toList();
    if (tab == 'found') items = items.where((i) => i.status == 'found').toList();
    // Search filter
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      items = items.where((i) =>
          i.title.toLowerCase().contains(q) ||
          i.description.toLowerCase().contains(q)).toList();
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filterCategory ?? 'All Items'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: '🔴 Lost'),
            Tab(text: '🟢 Found'),
          ],
        ),
      ),
      body: StreamBuilder<List<ItemModel>>(
        stream: _fs.streamAllItems(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (snap.hasError) {
            return ErrorState(message: 'Could not load items.',
                onRetry: () => setState(() {}));
          }
          final all = snap.data ?? [];

          return Column(children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomSearchBar(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _ItemList(items: _filter(all, 'all')),
                  _ItemList(items: _filter(all, 'lost')),
                  _ItemList(items: _filter(all, 'found')),
                ],
              ),
            ),
          ]);
        },
      ),
    );
  }
}

// ── Item List ──────────────────────────────────────────────
class _ItemList extends StatelessWidget {
  final List<ItemModel> items;
  const _ItemList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyState(
        emoji: '📭',
        title: 'No items here',
        subtitle: 'Nothing matching your filters',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (ctx, i) => ItemCard(
        item: items[i],
        onTap: () => Navigator.push(ctx,
            MaterialPageRoute(
                builder: (_) => ItemDetailScreen(item: items[i]))),
      ),
    );
  }
}