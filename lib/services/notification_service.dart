import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? _fcmToken;

  static Future<void> init() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('FCM permission: ${settings.authorizationStatus}');

    _fcmToken = await _messaging.getToken();
    debugPrint('FCM token: $_fcmToken');

    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }

  static String? get fcmToken => _fcmToken;

  static void _handleMessage(RemoteMessage message) {
    debugPrint('FCM message: ${message.notification?.title}');
  }

  @pragma('vm:entry-point')
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    debugPrint('FCM background: ${message.notification?.title}');
  }
}
