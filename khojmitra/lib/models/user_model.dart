// ============================================================
// models/user_model.dart
// KhojMitra user profile stored in Firestore
// ============================================================
 
import 'package:cloud_firestore/cloud_firestore.dart';
 
class UserModel {
  final String uid;
  final String name;
  final String email;
  final int rewardPoints;
  final String? fcmToken;
  final DateTime createdAt;
 
  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.rewardPoints = 0,
    this.fcmToken,
    required this.createdAt,
  });
 
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      uid: doc.id,
      name: (data['name'] as String?) ?? 'User',
      email: (data['email'] as String?) ?? '',
      rewardPoints: (data['rewardPoints'] as int?) ?? 0,
      fcmToken: data['fcmToken'] as String?,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
 
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'rewardPoints': rewardPoints,
      'fcmToken': fcmToken,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}