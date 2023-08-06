import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';




//FlutterLocalNotificationsPlugin 패키지 초기화
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


class FirebaseAPIs {

  static final storage = FlutterSecureStorage();
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

    var notification = await storage.read(key: 'notification');

    if(message.data['type'] != 'bulkRead'){
      // 알림 표시
      flutterLocalNotificationsPlugin.show(
        0, // 알림 ID
        '${message.data['title']}', // 제목
        '${message.data['body']}', // 본문
        platformDetails, // 알림 설정
      );
    }
    else if(message.data['type'] == 'notice'){
      if(json.decode(notification!)['matchingNotification'] == true){
        // 알림 표시
        flutterLocalNotificationsPlugin.show(
          0, // 알림 ID
          '${message.data['title']}', // 제목
          '${message.data['body']}', // 본문
          platformDetails, // 알림 설정
        );
      }
      else{
        return;
      }
    }

  }

}

