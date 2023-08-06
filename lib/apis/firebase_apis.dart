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


  static Future<void> FCMBackgroundHandler(RemoteMessage message) async {


    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidDetails = AndroidNotificationDetails(
      'channel_id', // 채널 ID
      'Channel name', // 채널 이름
      priority: Priority.high,
      importance: Importance.max,
    );
    var platformDetails = NotificationDetails(android: androidDetails);


    if(message.data['type'] != 'bulkRead'){
      // 알림 표시
      flutterLocalNotificationsPlugin.show(
        0, // 알림 ID
        '${message.data['title']}', // 제목
        '${message.data['body']}', // 본문
        platformDetails, // 알림 설정
      );
    }

  }

}

