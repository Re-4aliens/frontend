import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../repository/sql_message_database.dart';




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
    print('알림 도착 ${message.data}');

    //상대방의 일괄 읽음 알림 (상대방이 채팅창 들어왔을 때의 알림)
    //상대방이 채팅 읽었을 때의 알림
    if(message.data['type'] == 'bulkRead' && message.data['type'] == 'read'){
      //알림 안보냄
      print('일괄읽음 도착 ${message.data}');
    }
    //일괄적으로 보내는 notice
    else if(message.data['type'] == 'notice'){

      print('notice 도착 ${message.data}');
      //매칭 알림이 켜져있는 경우에만 보냄
      if(json.decode(notification!)['matchingNotification'] == true){
        // 알림 표시
        flutterLocalNotificationsPlugin.show(
          0, // 알림 ID
          '${message.data['title']}', // 제목
          '${message.data['body']}', // 본문
          platformDetails, // 알림 설정
        );
        SqlMessageDataBase.instance.deleteDB();
      }
      else{
        return;
      }
    }else if(message.data['type'] == 'chat'){

      print('채팅 도착 ${message.data}');
      // 알림 표시
      if(json.decode(notification!)['chatNotification'] == true){
        flutterLocalNotificationsPlugin.show(
          0, // 알림 ID
          '${message.data['title']}', // 제목
          '${message.data['body']}', // 본문
          platformDetails, // 알림 설정
        );
      }
    }
  }

}

