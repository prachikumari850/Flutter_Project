// // ============================================================
// // services/storage_service.dart
// // Firebase Storage — image upload with progress callback
// // ============================================================
 
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import '../utils/app_constants.dart';
 
// class StorageService {
//   // ── Singleton ──────────────────────────────────────────
//   static final StorageService _i = StorageService._internal();
//   factory StorageService() => _i;
//   StorageService._internal();
 
//   final FirebaseStorage _storage = FirebaseStorage.instance;
 
//   // ── Upload item image ──────────────────────────────────
//   /// Uploads [imageFile] to Firebase Storage under the path
//   /// item_images/{userId}/{itemId}.{ext}
//   /// Returns the public download URL, or null on failure.
//   Future<String?> uploadItemImage({
//     required File imageFile,
//     required String userId,
//     required String itemId,
//     void Function(double progress)? onProgress,
//   }) async {
//     try {
//       final ext = imageFile.path.split('.').last.toLowerCase();
//       final safeExt = ['jpg', 'jpeg', 'png', 'webp'].contains(ext)
//           ? ext
//           : 'jpg';
//       final path =
//           '${AppConstants.itemImagesPath}/$userId/${itemId}_${DateTime.now().millisecondsSinceEpoch}.$safeExt';
 
//       final ref = _storage.ref().child(path);
//       final task = ref.putFile(
//         imageFile,
//         SettableMetadata(contentType: 'image/$safeExt'),
//       );
 
//       // Track upload progress if a callback was given
//       if (onProgress != null) {
//         task.snapshotEvents.listen((snap) {
//           if (snap.totalBytes > 0) {
//             onProgress(snap.bytesTransferred / snap.totalBytes);
//           }
//         });
//       }
 
//       final snapshot = await task;
//       return await snapshot.ref.getDownloadURL();
//     } catch (_) {
//       return null;
//     }
//   }
 
//   // ── Delete image by URL ────────────────────────────────
//   Future<void> deleteByUrl(String url) async {
//     try {
//       await _storage.refFromURL(url).delete();
//     } catch (_) {}
//   }
// }

// ============================================================
// services/storage_service.dart
// Firebase Storage — image upload with progress callback
// ============================================================

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../utils/app_constants.dart';

class StorageService {
  static final StorageService _i = StorageService._();
  factory StorageService() => _i;
  StorageService._();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload item image → returns download URL or null on failure
  Future<String?> uploadItemImage({
    required File   imageFile,
    required String userId,
    required String itemId,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final ext  = imageFile.path.split('.').last.toLowerCase();
      final path = '${AppConstants.storageItems}/$userId/$itemId.$ext';
      final ref  = _storage.ref().child(path);

      final task = ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/$ext'),
      );

      // Report upload progress
      if (onProgress != null) {
        task.snapshotEvents.listen((snap) {
          if (snap.totalBytes > 0) {
            onProgress(snap.bytesTransferred / snap.totalBytes);
          }
        });
      }

      final snap = await task;
      return await snap.ref.getDownloadURL();
    } catch (_) {
      return null;
    }
  }

  /// Delete a stored image by its download URL
  Future<void> deleteImage(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (_) {}
  }
}