import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 🔔 This method runs when message received in background or terminated state.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase reinitialize because background isolate separate thread.
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
    print("📩 Background FCM received");
    print("Data: ${message.data}");
  }

  await NotificationService().showBackgroundNotification(
    message.data['scope'] ?? 'General',
    message.data['message'] ?? 'No message body',
  );
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize Firebase Messaging and Local Notifications
  Future<void> init() async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _initLocalNotifications();
    await _requestNotificationPermission();
    await _getToken();
    _setupMessageHandlers();
  }

  /// Request permission (important for iOS)
  Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (kDebugMode) {
      print("🔐 Notification permission: ${settings.authorizationStatus}");
    }
  }

  /// Get FCM token
  Future<void> _getToken() async {
    String? token = await _messaging.getToken();
    if (kDebugMode) {
      print("📱 FCM Token: $token");
    }
  }

  /// Local notification initialization
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (kDebugMode) {
          print("🚀 Notification tapped: ${response.payload}");
        }
        // Add navigation handling here if needed
      },
    );
  }

  /// Show notification in foreground
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final data = message.data;
    final String title = data['scope'] ?? 'Notification';
    final String body = data['message'] ?? 'No message';

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'Used for important notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      platformDetails,
      payload: title,
    );
  }

  /// Show notification in background or terminated
  Future<void> showBackgroundNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'Used for important notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: title,
    );
  }

  /// Foreground / Background message handling
  void _setupMessageHandlers() {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("💥 Foreground message received: ${message.data}");
      }
      _showLocalNotification(message);
    });

    // Background tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("🚀 Notification opened from background: ${message.data}");
      }
    });

    // Terminated state
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null && kDebugMode) {
        print("🟢 App opened from killed state: ${message.data}");
      }
    });
  }
}
