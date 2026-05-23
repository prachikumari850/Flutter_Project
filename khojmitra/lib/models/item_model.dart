// // ============================================================
// // models/item_model.dart
// // Data model for Lost/Found items
// // ============================================================

// class ItemModel {
//   final String id;
//   final String title;
//   final String description;
//   final String status; // 'lost' or 'found'
//   final String location;
//   final String category;
//   final String imagePlaceholder; // emoji or icon name for demo
//   final String postedBy;
//   final String postedDate;
//   final int confidenceScore; // AI confidence (demo)
//   bool isReturned;

//   ItemModel({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.status,
//     required this.location,
//     required this.category,
//     required this.imagePlaceholder,
//     required this.postedBy,
//     required this.postedDate,
//     required this.confidenceScore,
//     this.isReturned = false,
//   });
// }

// ============================================================
// models/item_model.dart
// Firestore-backed data model — upgraded from local dummy model
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String title;
  final String description;
  final String status; // 'lost' | 'found'
  final String location;
  final String category;
  final String? imageUrl;         // Firebase Storage URL (nullable)
  final String userId;            // Firebase Auth UID
  final String postedBy;          // Display name
  final String postedByEmail;
  final DateTime timestamp;
  final bool isReturned;
  final int confidenceScore;      // AI-generated score

  const ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.location,
    required this.category,
    this.imageUrl,
    required this.userId,
    required this.postedBy,
    required this.postedByEmail,
    required this.timestamp,
    this.isReturned = false,
    this.confidenceScore = 0,
  });

  // ── Emoji placeholder when no image ───────────────────
  String get emojiPlaceholder {
    switch (category) {
      case 'Electronics': return '💻';
      case 'Documents':   return '📄';
      case 'Bags':        return '🎒';
      case 'Accessories': return '⌚';
      case 'Stationery':  return '✏️';
      default:            return '📦';
    }
  }

  // ── Human-readable date ────────────────────────────────
  String get postedDate {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inMinutes < 1)  return 'Just now';
    if (diff.inHours < 1)    return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)   return '${diff.inHours}h ago';
    if (diff.inDays == 1)    return 'Yesterday';
    return '${diff.inDays} days ago';
  }

  // ── Firestore → ItemModel ──────────────────────────────
  factory ItemModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    return ItemModel(
      id:             doc.id,
      title:          (d['title']          as String?) ?? 'Untitled',
      description:    (d['description']    as String?) ?? '',
      status:         (d['status']         as String?) ?? 'lost',
      location:       (d['location']       as String?) ?? 'Unknown',
      category:       (d['category']       as String?) ?? 'Others',
      imageUrl:        d['imageUrl']        as String?,
      userId:         (d['userId']         as String?) ?? '',
      postedBy:       (d['postedBy']       as String?) ?? 'Anonymous',
      postedByEmail:  (d['postedByEmail']  as String?) ?? '',
      timestamp: d['timestamp'] != null
          ? (d['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      isReturned:     (d['isReturned']     as bool?) ?? false,
      confidenceScore:(d['confidenceScore']as int?)  ?? 0,
    );
  }

  // ── ItemModel → Firestore Map ──────────────────────────
  Map<String, dynamic> toFirestore() => {
    'title':          title,
    'description':    description,
    'status':         status,
    'location':       location,
    'category':       category,
    'imageUrl':       imageUrl,
    'userId':         userId,
    'postedBy':       postedBy,
    'postedByEmail':  postedByEmail,
    'timestamp':      Timestamp.fromDate(timestamp),
    'isReturned':     isReturned,
    'confidenceScore':confidenceScore,
  };

  ItemModel copyWith({
    String? id, String? title, String? description, String? status,
    String? location, String? category, String? imageUrl,
    String? userId, String? postedBy, String? postedByEmail,
    DateTime? timestamp, bool? isReturned, int? confidenceScore,
  }) => ItemModel(
    id:             id             ?? this.id,
    title:          title          ?? this.title,
    description:    description    ?? this.description,
    status:         status         ?? this.status,
    location:       location       ?? this.location,
    category:       category       ?? this.category,
    imageUrl:       imageUrl       ?? this.imageUrl,
    userId:         userId         ?? this.userId,
    postedBy:       postedBy       ?? this.postedBy,
    postedByEmail:  postedByEmail  ?? this.postedByEmail,
    timestamp:      timestamp      ?? this.timestamp,
    isReturned:     isReturned     ?? this.isReturned,
    confidenceScore:confidenceScore?? this.confidenceScore,
  );
}