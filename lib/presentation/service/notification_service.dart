import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// ------------------------------------------------------
///  BACKGROUND FCM HANDLER
/// ------------------------------------------------------
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("📩 BACKGROUND FCM RECEIVED");
    print("➡ Data: ${message.data}");
  }

  await NotificationService().showBackgroundNotification(
    message.data['scope'] ?? 'Notification',
    message.data['message'] ?? '',
  );
}

/// ------------------------------------------------------
///  NOTIFICATION SERVICE SINGLETON
/// ------------------------------------------------------
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_importance",
    "High Importance Notifications",
    description: "Shows important notifications",
    importance: Importance.max,
  );

  /// ------------------------------------------------------
  ///  INIT METHOD (CALL IN main.dart)
  /// ------------------------------------------------------
  Future<void> init() async {
    // Background handler must be registered first
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _initializeLocalNotifications();
    await _requestPermissions();
    await _printToken();

    _setupForegroundHandler();
    _setupOnMessageOpenedApp();
    _setupInitialMessage();
  }

  /// ------------------------------------------------------
  ///  REQUEST PERMISSION (iOS only, Android auto-granted)
  /// ------------------------------------------------------
  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      print("🔐 Permission Status → ${settings.authorizationStatus}");
    }
  }

  /// ------------------------------------------------------
  ///  FETCH AND PRINT DEVICE FCM TOKEN
  /// ------------------------------------------------------
  Future<void> _printToken() async {
    final token = await _messaging.getToken();
    if (kDebugMode) print("📱 FCM TOKEN → $token");
  }

  /// ------------------------------------------------------
  ///  LOCAL NOTIFICATION INIT
  /// ------------------------------------------------------
  Future<void> _initializeLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (kDebugMode) {
          print("👉 Notification tapped: ${response.payload}");
        }
      },
    );

    // Create Android notification channel
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// ------------------------------------------------------
  ///  FOREGROUND FCM HANDLER
  /// ------------------------------------------------------
  void _setupForegroundHandler() {
    print("sdfsdf");
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print("💥 FOREGROUND MESSAGE");
        print("➡ Data: ${message}");
      }
      showForegroundNotification(message);
    });
  }

  /// ------------------------------------------------------
  ///  FOREGROUND LOCAL NOTIFICATION
  /// ------------------------------------------------------
  Future<void> showForegroundNotification(RemoteMessage message) async {
    final data = message.data;

    final String title = data['scope'] ?? "Notification";
    final String body = data['message'] ?? "";

    const androidDetails = AndroidNotificationDetails(
      "high_importance",
      "High Importance Notifications",
      channelDescription: "This channel is used for important notifications",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _local.show(
      message.hashCode,
      title,
      body,
      details,
      payload: body,
    );
  }

  /// ------------------------------------------------------
  ///  BACKGROUND / TERMINATED NOTIFICATION
  /// ------------------------------------------------------
  Future<void> showBackgroundNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      "high_importance",
      "High Importance Notifications",
      channelDescription: "This channel is used for important notifications",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformDetails,
    );
  }

  /// ------------------------------------------------------
  ///  WHEN USER TAPS NOTIFICATION (APP IN BACKGROUND)
  /// ------------------------------------------------------
  void _setupOnMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) {
        print("🚀 Notification opened from background");
        print("➡ ${message.data}");
      }
    });
  }

  /// ------------------------------------------------------
  ///  APP OPENED FROM TERMINATED STATE
  /// ------------------------------------------------------
  void _setupInitialMessage() {
    _messaging.getInitialMessage().then((message) {
      if (message != null) {
        if (kDebugMode) {
          print("🟢 App launched from TERMINATED by tapping the notification");
          print("➡ ${message.data}");
        }
      }
    });
  }
}
