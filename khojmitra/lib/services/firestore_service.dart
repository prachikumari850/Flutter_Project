// // ============================================================
// // services/firestore_service.dart
// // All Firestore operations — items, matches, users
// // ============================================================
 
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/item_model.dart';
// import '../models/match_model.dart';
// import '../utils/app_constants.dart';
 
// class FirestoreService {
//   // ── Singleton ──────────────────────────────────────────
//   static final FirestoreService _i = FirestoreService._internal();
//   factory FirestoreService() => _i;
//   FirestoreService._internal();
 
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
 
//   // ── Collection references ──────────────────────────────
//   CollectionReference get _items =>
//       _db.collection(AppConstants.itemsCollection);
//   CollectionReference get _matches =>
//       _db.collection(AppConstants.matchesCollection);
//   CollectionReference get _users =>
//       _db.collection(AppConstants.usersCollection);
 
//   // ================================================================
//   // ITEM OPERATIONS
//   // ================================================================
 
//   /// Add a new item. Returns the new document ID or null on failure.
//   Future<String?> addItem(ItemModel item) async {
//     try {
//       final doc = await _items.add(item.toFirestore());
//       return doc.id;
//     } catch (e) {
//       return null;
//     }
//   }
 
//   /// Mark an item as returned.
//   Future<bool> markAsReturned(String itemId) async {
//     try {
//       await _items.doc(itemId).update({'isReturned': true});
//       return true;
//     } catch (_) {
//       return false;
//     }
//   }
 
//   /// Delete an item.
//   Future<bool> deleteItem(String itemId) async {
//     try {
//       await _items.doc(itemId).delete();
//       return true;
//     } catch (_) {
//       return false;
//     }
//   }
 
//   // ── Real-time streams ──────────────────────────────────
 
//   /// Stream all items ordered by newest first.
//   Stream<List<ItemModel>> streamAllItems() {
//     return _items
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map((s) => s.docs.map(ItemModel.fromFirestore).toList());
//   }
 
//   /// Stream items filtered by status ('lost' or 'found').
//   Stream<List<ItemModel>> streamItemsByStatus(String status) {
//     return _items
//         .where('status', isEqualTo: status)
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map((s) => s.docs.map(ItemModel.fromFirestore).toList());
//   }
 
//   /// Stream only the current user's items.
//   Stream<List<ItemModel>> streamMyItems(String userId) {
//     return _items
//         .where('userId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map((s) => s.docs.map(ItemModel.fromFirestore).toList());
//   }
 
//   // ── One-time fetches for AI matching ──────────────────
 
//   /// Fetch all active (not returned) lost items.
//   Future<List<ItemModel>> getActiveLostItems() async {
//     try {
//       final snap = await _items
//           .where('status', isEqualTo: 'lost')
//           .where('isReturned', isEqualTo: false)
//           .get();
//       return snap.docs.map(ItemModel.fromFirestore).toList();
//     } catch (_) {
//       return [];
//     }
//   }
 
//   /// Fetch all active (not returned) found items.
//   Future<List<ItemModel>> getActiveFoundItems() async {
//     try {
//       final snap = await _items
//           .where('status', isEqualTo: 'found')
//           .where('isReturned', isEqualTo: false)
//           .get();
//       return snap.docs.map(ItemModel.fromFirestore).toList();
//     } catch (_) {
//       return [];
//     }
//   }
 
//   // ================================================================
//   // MATCH OPERATIONS
//   // ================================================================
 
//   /// Save an AI match (deduplicates automatically).
//   Future<String?> saveMatch(MatchModel match) async {
//     try {
//       // Check for existing match between these two items
//       final existing = await _matches
//           .where('lostItemId', isEqualTo: match.lostItemId)
//           .where('foundItemId', isEqualTo: match.foundItemId)
//           .limit(1)
//           .get();
//       if (existing.docs.isNotEmpty) return existing.docs.first.id;
 
//       final doc = await _matches.add(match.toFirestore());
//       return doc.id;
//     } catch (_) {
//       return null;
//     }
//   }
 
//   /// Stream matches where the current user is the loser (needs alerts).
//   Stream<List<MatchModel>> streamMyMatches(String userId) {
//     return _matches
//         .where('lostUserId', isEqualTo: userId)
//         .orderBy('matchedAt', descending: true)
//         .snapshots()
//         .map((s) => s.docs.map(MatchModel.fromFirestore).toList());
//   }
 
//   // ================================================================
//   // USER OPERATIONS
//   // ================================================================
 
//   /// Increment reward points for a user.
//   Future<void> addRewardPoints(String userId, int points) async {
//     try {
//       await _users
//           .doc(userId)
//           .update({'rewardPoints': FieldValue.increment(points)});
//     } catch (_) {}
//   }
 
//   /// Stream a user's profile document in real-time.
//   Stream<Map<String, dynamic>?> streamUserData(String userId) {
//     return _users.doc(userId).snapshots().map((snap) {
//       if (!snap.exists) return null;
//       return snap.data() as Map<String, dynamic>?;
//     });
//   }
 
//   /// One-time fetch of user data.
//   Future<Map<String, dynamic>?> getUserData(String userId) async {
//     try {
//       final doc = await _users.doc(userId).get();
//       if (!doc.exists) return null;
//       return doc.data() as Map<String, dynamic>?;
//     } catch (_) {
//       return null;
//     }
//   }
// }

// ============================================================
// services/firestore_service.dart
// Firestore CRUD + real-time streams for items, matches, users
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';
import '../models/match_model.dart';
import '../utils/app_constants.dart';

class FirestoreService {
  static final FirestoreService _i = FirestoreService._();
  factory FirestoreService() => _i;
  FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _items   => _db.collection(AppConstants.colItems);
  CollectionReference get _matches => _db.collection(AppConstants.colMatches);
  CollectionReference get _users   => _db.collection(AppConstants.colUsers);

  // ══════════════════════════════════════════════════════
  //  ITEMS
  // ══════════════════════════════════════════════════════

  /// Add new item → returns Firestore doc ID or null on error
  Future<String?> addItem(ItemModel item) async {
    try {
      final doc = await _items.add(item.toFirestore());
      return doc.id;
    } catch (e) {
      return null;
    }
  }

  /// Mark an item as returned
  Future<bool> markAsReturned(String itemId) async {
    try {
      await _items.doc(itemId).update({'isReturned': true});
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Delete item
  Future<bool> deleteItem(String itemId) async {
    try {
      await _items.doc(itemId).delete();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Real-time streams ──────────────────────────────────

  /// Stream ALL items ordered by newest first
  Stream<List<ItemModel>> streamAllItems() =>
      _items
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map(_toDocs);

  /// Stream items filtered by status ('lost' | 'found')
  Stream<List<ItemModel>> streamByStatus(String status) =>
      _items
          .where('status', isEqualTo: status)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map(_toDocs);

  /// Stream items belonging to a specific user
  Stream<List<ItemModel>> streamMyItems(String userId) =>
      _items
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map(_toDocs);

  /// One-time fetch of active lost items (for AI matching)
  Future<List<ItemModel>> fetchActiveLost() async {
    try {
      final s = await _items
          .where('status',     isEqualTo: 'lost')
          .where('isReturned', isEqualTo: false)
          .get();
      return s.docs.map((d) => ItemModel.fromFirestore(d)).toList();
    } catch (_) {
      return [];
    }
  }

  /// One-time fetch of active found items (for AI matching)
  Future<List<ItemModel>> fetchActiveFound() async {
    try {
      final s = await _items
          .where('status',     isEqualTo: 'found')
          .where('isReturned', isEqualTo: false)
          .get();
      return s.docs.map((d) => ItemModel.fromFirestore(d)).toList();
    } catch (_) {
      return [];
    }
  }

  // ══════════════════════════════════════════════════════
  //  MATCHES
  // ══════════════════════════════════════════════════════

  /// Save a new AI match (skips if duplicate already exists)
  Future<String?> saveMatch(MatchModel match) async {
    try {
      final dup = await _matches
          .where('lostItemId',  isEqualTo: match.lostItemId)
          .where('foundItemId', isEqualTo: match.foundItemId)
          .get();
      if (dup.docs.isNotEmpty) return dup.docs.first.id;

      final doc = await _matches.add(match.toFirestore());
      return doc.id;
    } catch (_) {
      return null;
    }
  }

  /// Stream matches where the current user is the one who lost the item
  Stream<List<MatchModel>> streamMyMatches(String userId) =>
      _matches
          .where('lostUserId', isEqualTo: userId)
          .orderBy('matchedAt', descending: true)
          .snapshots()
          .map((s) => s.docs
              .map((d) => MatchModel.fromFirestore(d))
              .toList());

  // ══════════════════════════════════════════════════════
  //  USERS
  // ══════════════════════════════════════════════════════

  /// Stream user document (real-time reward points etc.)
  Stream<Map<String, dynamic>?> streamUser(String uid) =>
      _users.doc(uid).snapshots().map((s) =>
          s.exists ? s.data() as Map<String, dynamic>? : null);

  /// Add reward points atomically
  Future<void> addReward(String userId, int pts) async {
    if (userId.isEmpty) return;
    await _users
        .doc(userId)
        .update({'rewardPoints': FieldValue.increment(pts)})
        .catchError((_) {});
  }

  // ── Helper ─────────────────────────────────────────────
  List<ItemModel> _toDocs(QuerySnapshot s) =>
      s.docs.map((d) => ItemModel.fromFirestore(d)).toList();
}