// // ============================================================
// // models/match_model.dart
// // AI-detected match between a Lost and Found item
// // ============================================================
 
// import 'package:cloud_firestore/cloud_firestore.dart';
 
// class MatchModel {
//   final String id;
//   final String lostItemId;
//   final String foundItemId;
//   final String lostItemTitle;
//   final String foundItemTitle;
//   final String lostUserId;
//   final String foundUserId;
//   final String lostUserEmail;
//   final int confidenceScore;
//   final DateTime matchedAt;
//   final bool notificationSent;
 
//   const MatchModel({
//     required this.id,
//     required this.lostItemId,
//     required this.foundItemId,
//     required this.lostItemTitle,
//     required this.foundItemTitle,
//     required this.lostUserId,
//     required this.foundUserId,
//     required this.lostUserEmail,
//     required this.confidenceScore,
//     required this.matchedAt,
//     this.notificationSent = false,
//   });
 
//   // ── Firestore → MatchModel ─────────────────────────────
//   factory MatchModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>? ?? {};
//     return MatchModel(
//       id: doc.id,
//       lostItemId: (data['lostItemId'] as String?) ?? '',
//       foundItemId: (data['foundItemId'] as String?) ?? '',
//       lostItemTitle: (data['lostItemTitle'] as String?) ?? '',
//       foundItemTitle: (data['foundItemTitle'] as String?) ?? '',
//       lostUserId: (data['lostUserId'] as String?) ?? '',
//       foundUserId: (data['foundUserId'] as String?) ?? '',
//       lostUserEmail: (data['lostUserEmail'] as String?) ?? '',
//       confidenceScore: (data['confidenceScore'] as int?) ?? 0,
//       matchedAt: data['matchedAt'] != null
//           ? (data['matchedAt'] as Timestamp).toDate()
//           : DateTime.now(),
//       notificationSent: (data['notificationSent'] as bool?) ?? false,
//     );
//   }
 
//   // ── MatchModel → Firestore Map ─────────────────────────
//   Map<String, dynamic> toFirestore() {
//     return {
//       'lostItemId': lostItemId,
//       'foundItemId': foundItemId,
//       'lostItemTitle': lostItemTitle,
//       'foundItemTitle': foundItemTitle,
//       'lostUserId': lostUserId,
//       'foundUserId': foundUserId,
//       'lostUserEmail': lostUserEmail,
//       'confidenceScore': confidenceScore,
//       'matchedAt': Timestamp.fromDate(matchedAt),
//       'notificationSent': notificationSent,
//     };
//   }
// }

// ============================================================
// models/match_model.dart
// Represents an AI-detected match between Lost ↔ Found items
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String id;
  final String lostItemId;
  final String foundItemId;
  final String lostItemTitle;
  final String foundItemTitle;
  final String lostUserId;
  final String foundUserId;
  final String lostUserEmail;
  final int confidenceScore;
  final DateTime matchedAt;
  final bool notificationSent;

  const MatchModel({
    required this.id,
    required this.lostItemId,
    required this.foundItemId,
    required this.lostItemTitle,
    required this.foundItemTitle,
    required this.lostUserId,
    required this.foundUserId,
    required this.lostUserEmail,
    required this.confidenceScore,
    required this.matchedAt,
    this.notificationSent = false,
  });

  Map<String, dynamic> toFirestore() => {
    'lostItemId':       lostItemId,
    'foundItemId':      foundItemId,
    'lostItemTitle':    lostItemTitle,
    'foundItemTitle':   foundItemTitle,
    'lostUserId':       lostUserId,
    'foundUserId':      foundUserId,
    'lostUserEmail':    lostUserEmail,
    'confidenceScore':  confidenceScore,
    'matchedAt':        Timestamp.fromDate(matchedAt),
    'notificationSent': notificationSent,
  };

  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    return MatchModel(
      id:               doc.id,
      lostItemId:       (d['lostItemId']      as String?) ?? '',
      foundItemId:      (d['foundItemId']     as String?) ?? '',
      lostItemTitle:    (d['lostItemTitle']   as String?) ?? '',
      foundItemTitle:   (d['foundItemTitle']  as String?) ?? '',
      lostUserId:       (d['lostUserId']      as String?) ?? '',
      foundUserId:      (d['foundUserId']     as String?) ?? '',
      lostUserEmail:    (d['lostUserEmail']   as String?) ?? '',
      confidenceScore:  (d['confidenceScore'] as int?)    ?? 0,
      matchedAt: d['matchedAt'] != null
          ? (d['matchedAt'] as Timestamp).toDate()
          : DateTime.now(),
      notificationSent: (d['notificationSent'] as bool?) ?? false,
    );
  }
}