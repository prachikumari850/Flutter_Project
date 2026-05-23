// // ============================================================
// // services/notification_service.dart
// // Firebase Cloud Messaging + Flutter Local Notifications
// // No circular imports — uses FirebaseFirestore directly
// // ============================================================
 
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../models/match_model.dart';
// import 'auth_service.dart';
 
// // ── Background message handler (must be top-level) ────────
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(
//     RemoteMessage message) async {
//   // Firebase is already initialised before this fires.
//   // Show a local notification for the incoming FCM message.
//   final plugin = FlutterLocalNotificationsPlugin();
//   const androidDetails = AndroidNotificationDetails(
//     'khojmitra_channel',
//     'KhojMitra Alerts',
//     channelDescription: 'Match alerts',
//     importance: Importance.high,
//     priority: Priority.high,
//   );
//   await plugin.show(
//     message.hashCode,
//     message.notification?.title ?? 'KhojMitra.AI',
//     message.notification?.body ?? 'You have a new update!',
//     const NotificationDetails(android: androidDetails),
//   );
// }
 
// // ── Notification Service ───────────────────────────────────
// class NotificationService {
//   // Singleton
//   static final NotificationService _i =
//       NotificationService._internal();
//   factory NotificationService() => _i;
//   NotificationService._internal();
 
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _local =
//       FlutterLocalNotificationsPlugin();
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final AuthService _auth = AuthService();
 
//   // ── Initialise once from main() ────────────────────────
//   Future<void> init() async {
//     // 1. Request permissions (iOS + Android 13+)
//     await _fcm.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );
 
//     // 2. Set up local notifications
//     const androidInit =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosInit = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//     await _local.initialize(
//       const InitializationSettings(android: androidInit, iOS: iosInit),
//     );
 
//     // 3. Create Android notification channel
//     const channel = AndroidNotificationChannel(
//       'khojmitra_channel',
//       'KhojMitra Alerts',
//       description: 'Real-time AI match alerts',
//       importance: Importance.high,
//       playSound: true,
//     );
//     await _local
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
 
//     // 4. Register background FCM handler
//     FirebaseMessaging.onBackgroundMessage(
//         _firebaseMessagingBackgroundHandler);
 
//     // 5. Handle FCM messages while app is in foreground
//     FirebaseMessaging.onMessage.listen((msg) {
//       showLocalNotification(
//         title: msg.notification?.title ?? 'KhojMitra.AI',
//         body: msg.notification?.body ?? '',
//       );
//     });
 
//     // 6. Save FCM token to Firestore for Cloud Function targeting
//     final token = await _fcm.getToken();
//     if (token != null && _auth.isLoggedIn) {
//       await _auth.saveFcmToken(token);
//     }
 
//     // Refresh token if it rotates
//     _fcm.onTokenRefresh.listen((newToken) {
//       if (_auth.isLoggedIn) _auth.saveFcmToken(newToken);
//     });
//   }
 
//   // ── Show a local notification ──────────────────────────
//   Future<void> showLocalNotification({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'khojmitra_channel',
//       'KhojMitra Alerts',
//       channelDescription: 'Real-time AI match alerts',
//       importance: Importance.high,
//       priority: Priority.high,
//       showWhen: true,
//       icon: '@mipmap/ic_launcher',
//     );
//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//     await _local.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       title,
//       body,
//       const NotificationDetails(
//           android: androidDetails, iOS: iosDetails),
//       payload: payload,
//     );
//   }
 
//   // ── Write match notification to Firestore ──────────────
//   /// The Cloud Function (index.js) listens on `notifications/{id}`
//   /// and sends the actual FCM push to the lost-item owner.
//   /// We also immediately show a local notification if the
//   /// currently logged-in user owns the lost item.
//   Future<void> sendMatchNotification({
//     required MatchModel match,
//     required String lostItemTitle,
//     required int score,
//   }) async {
//     try {
//       final title = '🎉 Match Found for "$lostItemTitle"';
//       final body =
//           'AI is $score% confident your lost item was found! Open KhojMitra.AI to check.';
 
//       // 1. Write to Firestore → Cloud Function picks it up and
//       //    sends FCM to the lost-item owner's device token.
//       await _db.collection('notifications').add({
//         'to': match.lostUserId,
//         'toEmail': match.lostUserEmail,
//         'type': 'match',
//         'title': title,
//         'body': body,
//         'matchId': match.id,
//         'lostItemId': match.lostItemId,
//         'foundItemId': match.foundItemId,
//         'confidenceScore': score,
//         'createdAt': FieldValue.serverTimestamp(),
//         'sent': false,
//       });
 
//       // 2. If the lost-item owner is the *current* user,
//       //    also show a local notification right now
//       //    (no need to wait for Cloud Function round-trip).
//       if (match.lostUserId == _auth.userId) {
//         await showLocalNotification(
//           title: title,
//           body: body,
//           payload: match.id,
//         );
//       }
//     } catch (_) {
//       // Notification failure must never crash the app
//     }
//   }
// }

// ============================================================
// services/notification_service.dart
// FCM push notifications + flutter_local_notifications
// Free, no paid services used.
// ============================================================

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

// Top-level handler required by FCM for background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase is already initialized by this point
  // Local notification can be shown here if needed
}

class NotificationService {
  static final NotificationService _i = NotificationService._();
  factory NotificationService() => _i;
  NotificationService._();

  final FirebaseMessaging             _fcm   = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore             _db    = FirebaseFirestore.instance;

  // ── Initialize (call once in main.dart) ───────────────
  Future<void> init() async {
    // 1. Request permission
    await _fcm.requestPermission(
      alert: true, badge: true, sound: true,
    );

    // 2. Init local notifications
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios     = DarwinInitializationSettings();
    await _local.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    // 3. Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 4. Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForeground);

    // 5. Save FCM token
    final token = await _fcm.getToken();
    if (token != null) {
      await AuthService().saveFcmToken(token);
    }

    // 6. Refresh token listener
    _fcm.onTokenRefresh.listen((t) => AuthService().saveFcmToken(t));
  }

  // ── Show local notification when app is in foreground ─
  Future<void> _handleForeground(RemoteMessage msg) async {
    final notif = msg.notification;
    if (notif == null) return;

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notif.title ?? 'KhojMitra.AI',
      notif.body  ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'khojmitra_channel',
          'KhojMitra Alerts',
          channelDescription: 'AI match and item alerts',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  // ── Save match notification to Firestore ──────────────
  // The Cloud Function reads this and sends FCM via Admin SDK.
  // This is the FREE approach: write to Firestore → Cloud Function triggers.
  Future<void> sendMatchNotification({
    required String lostUserId,
    required String lostTitle,
    required String foundTitle,
    required int    score,
  }) async {
    try {
      await _db.collection('notifications').add({
        'type':        'MATCH_FOUND',
        'targetUserId': lostUserId,
        'title':       '🎉 Match Found for "$lostTitle"!',
        'body':        'A found item "$foundTitle" matched with $score% confidence. Check KhojMitra.AI now!',
        'score':        score,
        'createdAt':   FieldValue.serverTimestamp(),
        'sent':         false,
      });
    } catch (_) {}
  }

  // ── Show local in-app alert (no FCM needed) ────────────
  Future<void> showLocalMatchAlert({
    required String lostTitle,
    required String foundTitle,
    required int    score,
  }) async {
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '🎉 Match Found!',
      'Your "$lostTitle" may have been found ($score% match).',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'khojmitra_channel',
          'KhojMitra Alerts',
          channelDescription: 'AI match alerts',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}