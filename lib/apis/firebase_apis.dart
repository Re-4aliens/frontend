import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



//FlutterLocalNotificationsPlugin 패키지 초기화
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


class FirebaseAPIs {
  final _firebaseMessaging = FirebaseMessaging.instance;

  /// 상단 알림을 위해 AndroidNotificationChannel 생성
  static AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.min,
  );


  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Initialized default app $app');



    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
    });

  }

  static Future<void> FCMBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();

    print('백그라운드 메세지 도착 ${message.data}');

    // 백그라운드에서 메세지 처리
    flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id, channel.name,
            icon: message.notification!.android!.smallIcon,
          ),
        ));
  }

}

