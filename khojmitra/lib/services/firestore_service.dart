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