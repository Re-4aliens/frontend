import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../config/firebase_options.dart';
import '../repository/sql_message_database.dart';

// Firebase 푸시 알림 설정, 토큰 관리, 알림 처리와 관련된 로직 관리

class FirebaseAPIs {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static late AndroidNotificationChannel _channel;
  static bool _isFlutterLocalNotificationsInitialized = false;
  static const _storage = FlutterSecureStorage();

  static Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }
    _channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // 토큰 요청
    getToken();

    _isFlutterLocalNotificationsInitialized = true;
  }

  static Future<void> getToken() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    }
  }

  static void initializeFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Message Notification: ${message.notification}');
      }

      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked! ${message.messageId}');
    });
  }

  @pragma('vm:entry-point')
  static Future<void> FCMBackgroundHandler(RemoteMessage message) async {
    if (message.notification != null) {
      print('Message Notification: ${message.notification}');
    }

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await setupFlutterNotifications();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    var androidDetails = const AndroidNotificationDetails(
      'channel_id', // 채널 ID
      'Channel name', // 채널 이름
      priority: Priority.high,
      importance: Importance.max,
    );
    var platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    var notification = await _storage.read(key: 'notifications');
    print('Notification Settings: $notification'); // 저장된 알림 설정 출력

    if (message.data['type'] == 'bulkRead' && message.data['type'] == 'read') {
      print(
          'Received bulkRead or read notification'); // 타입이 bulkRead 또는 read일 경우 출력
    } else if (message.data['type'] == 'notice') {
      print('Received notice notification'); // 타입이 notice일 경우 출력
      if (json.decode(notification!)['matchingNotification'] == true) {
        _showNotification(message, platformDetails);
        SqlMessageDataBase.instance.deleteDB();
      }
    } else if (message.data['type'] == 'chat') {
      print('Received chat notification'); // 타입이 chat일 경우 출력
      if (json.decode(notification!)['chatNotification'] == true) {
        _showNotification(message, platformDetails);
      }
    } else if (message.data['type'] == 'ARTICLE_LIKE') {
      print('Received article like notification'); // 타입이 ARTICLE_LIKE일 경우 출력
      if (json.decode(notification!)['communityNotification'] == true) {
        await _flutterLocalNotificationsPlugin.show(
          0, // 알림 ID
          'Friendship', // 제목
          '${message.data['name']}님이 회원님의 게시글을 좋아합니다.', // 본문
          platformDetails, // 알림 설정
        );
      }
    } else if (message.data['type'] == 'ARTICLE_COMMENT_REPLY') {
      print(
          'Received article comment reply notification'); // 타입이 ARTICLE_COMMENT_REPLY일 경우 출력
      if (json.decode(notification!)['communityNotification'] == true) {
        _showNotification(message, platformDetails);
      }
    } else if (message.data['type'] == 'ARTICLE_COMMENT') {
      print(
          'Received article comment notification'); // 타입이 ARTICLE_COMMENT일 경우 출력
      if (json.decode(notification!)['communityNotification'] == true) {
        _showNotification(message, platformDetails);
      }
    }
  }

  static void _showNotification(RemoteMessage message,
      [NotificationDetails? platformDetails]) {
    print(
        'Showing notification with title: ${message.data['title']} and body: ${message.data['body']}');
    _flutterLocalNotificationsPlugin.show(
      0, // 알림 ID
      message.data['title'], // 제목
      message.data['body'], // 본문
      platformDetails ?? const NotificationDetails(), // 알림 설정
    );
  }
}