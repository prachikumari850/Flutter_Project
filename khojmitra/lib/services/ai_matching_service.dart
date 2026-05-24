// ============================================================
// services/ai_matching_service.dart
// AI Matching Engine — NLP-style heuristics to match
// Lost ↔ Found items and generate confidence scores (0–100%)
// ============================================================

import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/item_model.dart';
import '../models/match_model.dart';
import '../utils/app_constants.dart';
import 'firestore_service.dart';
import 'notification_service.dart';

class AiMatchingService {
  static final AiMatchingService _i = AiMatchingService._();
  factory AiMatchingService() => _i;
  AiMatchingService._();

  final FirestoreService    _fs   = FirestoreService();
  // final NotificationService _notif = NotificationService();
  final _uuid = const Uuid();

  // ── Common stop words to ignore in matching ────────────
  static const _stopWords = {
    'a', 'an', 'the', 'is', 'it', 'in', 'on', 'at', 'to', 'for',
    'of', 'and', 'or', 'my', 'i', 'me', 'with', 'near', 'from',
    'was', 'were', 'has', 'have', 'had', 'this', 'that', 'found',
    'lost', 'item', 'very', 'last', 'seen', 'please', 'help',
  };

  // ══════════════════════════════════════════════════════
  //  PUBLIC: Run matching when a new item is added
  // ══════════════════════════════════════════════════════

  /// Call this right after saving a new item to Firestore.
  /// It fetches all opposing-status items and runs match logic.
  Future<void> runMatchingForNewItem(ItemModel newItem) async {
    final candidates = newItem.status == 'found'
        ? await _fs.fetchActiveLost()
        : await _fs.fetchActiveFound();

    for (final candidate in candidates) {
      // Skip same item or same user's items
      if (candidate.id == newItem.id)         continue;
      if (candidate.userId == newItem.userId) continue;

      final score = calculateScore(newItem, candidate);

      if (score >= AppConstants.matchThreshold) {
        final lostItem  = newItem.status == 'lost'  ? newItem : candidate;
        final foundItem = newItem.status == 'found' ? newItem : candidate;

        final match = MatchModel(
          id:             _uuid.v4(),
          lostItemId:     lostItem.id,
          foundItemId:    foundItem.id,
          lostItemTitle:  lostItem.title,
          foundItemTitle: foundItem.title,
          lostUserId:     lostItem.userId,
          foundUserId:    foundItem.userId,
          lostUserEmail:  lostItem.postedByEmail,
          confidenceScore:score,
          matchedAt:      DateTime.now(),
        );

        final matchId = await _fs.saveMatch(match);
        if (matchId != null) {
          // Reward both parties
          await _fs.addReward(lostItem.userId,  20);
          await _fs.addReward(foundItem.userId, 30);

          // Send in-app + FCM notification to person who lost the item
          // // await _notif.sendMatchNotification(
          //   lostUserId:   lostItem.userId,
          //   lostTitle:    lostItem.title,
          //   foundTitle:   foundItem.title,
          //   score:        score,
          // );
        }
      }
    }
  }

  // ══════════════════════════════════════════════════════
  //  PUBLIC: Compute match score between any two items
  // ══════════════════════════════════════════════════════

  /// Returns an integer 0–100 representing how likely item A
  /// matches item B. Higher = better match.
  int calculateScore(ItemModel a, ItemModel b) {
    double total = 0;

    // Weight 1 — Title similarity (40%)
    total += _tokenSimilarity(a.title, b.title) * 40;

    // Weight 2 — Description keyword overlap (35%)
    total += _keywordOverlap(a.description, b.description) * 35;

    // Weight 3 — Location similarity (15%)
    total += _tokenSimilarity(a.location, b.location) * 15;

    // Weight 4 — Same category exact match (10%)
    total += (a.category.toLowerCase() == b.category.toLowerCase()
        ? 1.0 : 0.0) * 10;

    return total.round().clamp(0, 100);
  }

  // ══════════════════════════════════════════════════════
  //  PRIVATE: NLP-style helpers
  // ══════════════════════════════════════════════════════

  /// Jaccard similarity on word tokens (ignores stop words)
  double _tokenSimilarity(String a, String b) {
    final tokA = _tokenize(a);
    final tokB = _tokenize(b);
    if (tokA.isEmpty && tokB.isEmpty) return 1.0;
    if (tokA.isEmpty || tokB.isEmpty) return 0.0;

    final intersection = tokA.intersection(tokB).length;
    final union        = tokA.union(tokB).length;
    return union == 0 ? 0.0 : intersection / union;
  }

  /// Keyword overlap: meaningful shared words / max possible
  double _keywordOverlap(String a, String b) {
    final kwA = _keywords(a);
    final kwB = _keywords(b);
    if (kwA.isEmpty && kwB.isEmpty) return 1.0;
    if (kwA.isEmpty || kwB.isEmpty) return 0.0;

    int matches = 0;
    for (final w in kwA) {
      // Partial match: "blue" matches "blueish", "bluish"
      if (kwB.any((k) => k.contains(w) || w.contains(k))) matches++;
    }
    return matches / max(kwA.length, kwB.length);
  }

  /// Tokenize: lowercase, split on non-letters, remove stop words
  Set<String> _tokenize(String text) =>
      text.toLowerCase()
          .split(RegExp(r'[^a-z0-9]'))
          .where((t) => t.length > 2 && !_stopWords.contains(t))
          .toSet();

  /// Extract meaningful keywords (length > 3, not stop words)
  Set<String> _keywords(String text) =>
      text.toLowerCase()
          .split(RegExp(r'[^a-z0-9]'))
          .where((t) => t.length > 3 && !_stopWords.contains(t))
          .toSet();

  // ══════════════════════════════════════════════════════
  //  PUBLIC: UI helper — score label and color hex
  // ══════════════════════════════════════════════════════

  String scoreLabel(int score) {
    if (score >= 85) return '🟢 High Match';
    if (score >= 75) return '🟡 Good Match';
    if (score >= 50) return '🟠 Possible Match';
    return '🔴 Low Similarity';
  }

  String scoreDetail(int score) {
    if (score >= 85) return 'High confidence match — very likely same item!';
    if (score >= 75) return 'Good match — AI detected strong similarity.';
    if (score >= 50) return 'Moderate match — reviewing similar items.';
    return 'Low confidence — unique item, monitoring for matches.';
  }
}