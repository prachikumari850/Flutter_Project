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