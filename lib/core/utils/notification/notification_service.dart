import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ipc_delegates/core/utils/url_container.dart';

/// ============================================================
/// BACKGROUND FCM HANDLER /// IMPORTANT: This must be a top-level function.
/// ============================================================
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message,) async {
  await Firebase.initializeApp();
  debugPrint('====================================');
  debugPrint('BACKGROUND FCM MESSAGE');
  debugPrint('Message ID: ${message.messageId}');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Data: ${message.data}');
  debugPrint('====================================');
}

class NotificationService
{
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final AwesomeNotifications _awesomeNotifications = AwesomeNotifications();
  static bool _initialized = false;

  /// ==========================================================
  /// INITIALIZE
  /// ==========================================================
  static Future<void> init(BuildContext context) async
  {
    if (_initialized) {
      return;
    }
    _initialized = true;
    // Request Firebase permission
    await _requestFirebasePermission();
    // Initialize Awesome Notifications
    await _initializeAwesomeNotifications();
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler,);
    // Register foreground/background listeners
    _registerFirebaseListeners();
    //Get FCM token
    await _getFCMToken();
    // Listen for token changes
    _listenForTokenRefresh();
  }

  /// ==========================================================
  /// FIREBASE PERMISSION
  /// ==========================================================
  static Future<void> _requestFirebasePermission() async {
    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true, badge: true, sound: true, provisional: false,);

    debugPrint('Firebase Notification Permission: ' '${settings.authorizationStatus}',);
  }

  static Future<void> _initializeAwesomeNotifications() async {
    await _awesomeNotifications.initialize(null, [
      NotificationChannel(
        channelKey: UrlContainer.notificationChannel,
        channelName: 'General Notifications',
        channelDescription: 'Notification channel for app',
        importance: NotificationImportance.High,
        playSound: true,
        defaultRingtoneType: DefaultRingtoneType.Notification,
        enableVibration: true,
        defaultColor: Colors.red,
        ledColor: Colors.white,
        enableLights: true,
        channelShowBadge: true,),
    ],);

    // Check Awesome Notification permission
    final bool isAllowed = await _awesomeNotifications.isNotificationAllowed();
    debugPrint('Awesome Notification Permission: $isAllowed',);
    if (!isAllowed) {
      final prefs = await SharedPreferences.getInstance();
      final bool alreadyAsked = prefs.getBool(
        'notification_permission_requested',) ?? false;
      if (!alreadyAsked) {
        await prefs.setBool('notification_permission_requested', true,);
        await _awesomeNotifications.requestPermissionToSendNotifications(
          channelKey: UrlContainer.notificationChannel,
          permissions: [
            NotificationPermission.Alert,
            NotificationPermission.Sound,
            NotificationPermission.Badge,
            NotificationPermission.Vibration,
          ],);
      }
    }
    // Notification click listener
    await _awesomeNotifications.setListeners(
      onActionReceivedMethod: _handleNotificationTap,);
  }

  /// ==========================================================
  /// GET FCM TOKEN
  /// ==========================================================
  static Future<void> _getFCMToken() async {
    try {
      final String? token = await _messaging.getToken();
      debugPrint('====================================');
      debugPrint('FCM TOKEN:');
      debugPrint(token ?? 'TOKEN IS NULL');
      debugPrint('====================================');
      if (token != null && token.isNotEmpty) {
        // TODO:
        // Send this token to your PHP API //
        // Example:
        // await ApiClient().updateFCMToken(token);
      }
    }
    catch (e) {
      debugPrint('FCM Token Error: $e',);
    }
  }

  /// TOKEN REFRESH
  static void _listenForTokenRefresh() {
    _messaging.onTokenRefresh.listen((String newToken) {
      debugPrint('NEW FCM TOKEN: $newToken',);
      // TODO:
      // Update token in PHP/MySQL
    },);
  }

  /// REGISTER FIREBASE LISTENERS
  static void _registerFirebaseListeners() {
    FirebaseMessaging.onMessage.listen(_handleIncomingMessage,);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationNavigation,);
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationNavigation(message,);
      }
    },);
  }

  /// FOREGROUND MESSAGE
  static Future<void> _handleIncomingMessage(RemoteMessage message,) async {
    debugPrint('====================================');
    debugPrint('FOREGROUND FCM MESSAGE');
    debugPrint('Message ID: ${message.messageId}',);
    debugPrint('Title: ${message.notification?.title}',);
    debugPrint('Body: ${message.notification?.body}',);
    debugPrint('Data: ${message.data}',);
    debugPrint('====================================');

    await _createGeneralNotification(message,);
  }

  /// CREATE LOCAL NOTIFICATION
  static Future<void> _createGeneralNotification(RemoteMessage message,) async {
    final String title = message.notification?.title ??
        message.data['title']?.toString() ?? 'Notification';
    final String body = message.notification?.body ??
        message.data['body']?.toString() ?? '';

    debugPrint('Creating Awesome Notification',);
    await _awesomeNotifications.createNotification(content: NotificationContent(
      id: Random().nextInt(2147483647),
      channelKey: UrlContainer.notificationChannel,
      actionType: ActionType.Default,
      title: title,
      body: body,
      payload: {
        'screen': message.data['screen']?.toString() ?? 'basic_notification',
        'value': message.data['value']?.toString() ?? '123',
        ...message.data.map((key, value) => MapEntry(key, value.toString()),),
      },),);
  }

  /// NOTIFICATION CLICK
  @pragma('vm:entry-point')
  static Future<void> _handleNotificationTap(ReceivedAction receivedAction,) async
  {
    final Map<String, String?> payload = receivedAction.payload ?? {};
    debugPrint('====================================');
    debugPrint('AWESOME NOTIFICATION CLICKED');
    debugPrint('Payload: $payload');
    debugPrint('====================================');

    final String? screen = payload['screen'];
    if (screen == 'basic_notification') {
      // Handle basic notification
    }
    // Example:
    // // if (screen == 'session') {
    // final sessionId = payload['session_id'];
    // Get.toNamed( // Routes.sessionDetail, // arguments: sessionId, // ); // }
  }

  /// FCM NOTIFICATION CLICK
  static void _handleNotificationNavigation(RemoteMessage message,)
  {
    debugPrint('====================================');
    debugPrint('NOTIFICATION CLICKED');
    debugPrint('Title: ${message.notification?.title}',);
    debugPrint('Body: ${message.notification?.body}',);
    debugPrint('Data: ${message.data}',);
    debugPrint('====================================');

    final Map<String, dynamic> data = message.data;
    final String? screen = data['screen']?.toString();
    if (screen == 'basic_notification') {
      // Navigate here
    }
  }

  static void dispose() {
    _initialized = false;
    _awesomeNotifications.dispose();
  }

}
