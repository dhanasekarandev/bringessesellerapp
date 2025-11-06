import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// ✅ Background FCM Handler
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

  final data = message.data;
  final String scope = data['scope'] ?? 'General';
  final String body = data['message'] ?? 'No message body';

  if (kDebugMode) {
    print('🔔 Background FCM received!');
    print('➡️ Scope: $scope');
    print('➡️ Message: $body');
  }

  // Show background local notification
  await NotificationService().showBackgroundNotification(scope, body);
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// ✅ Initialize Firebase Messaging & Local Notifications
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

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _initLocalNotifications();
    await _requestNotificationPermission();
    await _getToken();
    _setupMessageHandlers();
  }

  /// ✅ Request permission for notifications
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

  /// ✅ Get and print the FCM Token
  Future<void> _getToken() async {
    String? token = await _messaging.getToken();
    if (kDebugMode) {
      print('📱 FCM Token: $token');
    }
  }

  /// ✅ Initialize local notifications
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (kDebugMode) {
          print('🚀 Notification tapped: ${response.payload}');
        }
        // handle navigation based on payload if needed
      },
    );
  }

  /// ✅ Foreground local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final data = message.data;
    final String title = data['scope'] ?? 'Notification';
    final String body = data['message'] ?? 'No message';

    if (kDebugMode) {
      print('📩 Foreground notification:');
      print('➡️ Scope: $title');
      print('➡️ Message: $body');
    }

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
      payload: title, // Optional for deep linking
    );
  }

  /// ✅ Show background local notification
  Future<void> showBackgroundNotification(String scope, String message) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'Used for important notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      scope,
      message,
      notificationDetails,
      payload: scope,
    );
  }

  /// ✅ Message listeners (foreground, background, tap)
  void _setupMessageHandlers() {
    // Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('💥 Foreground message received!');
        print('Data: ${message.data}');
      }
      _showLocalNotification(message);
    });

    // Notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('🚀 Notification opened from background!');
        print('Data: ${message.data}');
      }
      _handleNotificationTap(message.data);
    });

    // Notification tap when app was terminated
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        if (kDebugMode) {
          print('🟢 App launched by notification!');
          print('Data: ${message.data}');
        }
        _handleNotificationTap(message.data);
      }
    });
  }

  /// ✅ Optional: Handle deep linking / navigation
  void _handleNotificationTap(Map<String, dynamic> data) {
    final scope = data['scope'] ?? '';
    if (kDebugMode) {
      print('🧭 Handling navigation for scope: $scope');
    }

    // Example:
    // if (scope == 'order_update') {
    //   GoRouter.of(context).go('/orders');
    // } else if (scope == 'payment_alert') {
    //   GoRouter.of(context).go('/payments');
    // }
  }
}
