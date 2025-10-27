import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAebIczLvdHI1zy2Vz11oMoed6Zme2pg7Y",
      appId: "1:989733009995:android:6a8a68c52af08bcb996bce",
      messagingSenderId: "989733009995",
      projectId: "bringessedeliverypartner",
      storageBucket: "bringessedeliverypartner.firebasestorage.app",
    ),
  );
  if (kDebugMode) {
    print('🔔 Background message: ${message.notification?.title}');
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await Firebase.initializeApp(
       options: const FirebaseOptions(
      apiKey: "AIzaSyAebIczLvdHI1zy2Vz11oMoed6Zme2pg7Y",
      appId: "1:989733009995:android:6a8a68c52af08bcb996bce",
      messagingSenderId: "989733009995",
      projectId: "bringessedeliverypartner",
      storageBucket: "bringessedeliverypartner.firebasestorage.app",
    ),
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _initLocalNotifications();
    await _requestNotificationPermission();
    await _getToken();
    _setupMessageHandlers();
  }

  Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      print('🔐 Notification permission: ${settings.authorizationStatus}');
    }
  }

  /// Get FCM token (send this to your backend)
  Future<void> _getToken() async {
    String? token = await _messaging.getToken();
    if (kDebugMode) {
      print('📱 FCM Token: $token');
    }
  }

  /// Initialize local notifications for foreground use
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(initSettings);
  }

  /// Display a local notification when app is in foreground
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      platformDetails,
    );
  }

  /// Listen for foreground, background, and tap events
  void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('💥 Foreground message: ${message.notification?.title}');
      }
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('🚀 Notification opened: ${message.notification?.title}');
      }
    });

    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null && kDebugMode) {
        print(
            '🟢 App launched by notification: ${message.notification?.title}');
      }
    });
  }
}
