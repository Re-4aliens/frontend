import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../firebase_options.dart';
import '../repository/sql_message_database.dart';




//FlutterLocalNotificationsPlugin 패키지 초기화
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

class FirebaseAPIs {

  static Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
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

    isFlutterLocalNotificationsInitialized = true;
  }
  static Future<void> getToken() async {
    if (Platform.isIOS) {
      print('ios');
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true,);
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      print("apnsToken: " + apnsToken.toString());
    }

    await FirebaseMessaging.instance.getToken().then((value) {
      print("deviceToken: " + value.toString());
    })!;
  }

  static final storage = FlutterSecureStorage();
  final _firebaseMessaging = FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  static Future<void> FCMBackgroundHandler(RemoteMessage message) async {


    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
    await setupFlutterNotifications();

    var initialzationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    var initialzationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var initializationSettings = InitializationSettings(
        android: initialzationSettingsAndroid, iOS: initialzationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );


    var androidDetails = AndroidNotificationDetails(
      'channel_id', // 채널 ID
      'Channel name', // 채널 이름
      priority: Priority.high,
      importance: Importance.max,
    );
    var platformDetails = NotificationDetails(android: androidDetails,iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),);

    var notification = await storage.read(key: 'notifications');
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
      //다 대문자인가?
      if(json.decode(notification!)['chatNotification'] == true){
        flutterLocalNotificationsPlugin.show(
          0, // 알림 ID
          '${message.data['title']}', // 제목
          '${message.data['body']}', // 본문
          platformDetails, // 알림 설정
        );
      }
    }else if(message.data['type']=='ARTICLE_LIKE'){

      if(json.decode(notification!)['communityNotification'] == true){
        await flutterLocalNotificationsPlugin.show(
          0, // 알림 ID
          'Friendship', // 제목
          '${message.data['name']}님이 회원님의 게시글을 좋아합니다.', // 본문
          platformDetails, // 알림 설정
        );
      }
    }else if(message.data['type']=='ARTICLE_COMMENT_REPLY'){

      if(json.decode(notification!)['communityNotification'] == true){
        flutterLocalNotificationsPlugin.show(
          0, // 알림 ID
          'Friendship', // 제목
          '${message.data['name']}님이 회원님의 댓글에 답글을 달았습니다.', // 본문
          platformDetails, // 알림 설정
        );
      }
    }else if(message.data['type']=='ARTICLE_COMMENT'){
      if(json.decode(notification!)['communityNotification'] == true){
        flutterLocalNotificationsPlugin.show(
          0, // 알림 ID
          'Friendship', // 제목
          '${message.data['name']}님이 회원님의 게시글에 댓글을 달았습니다.', // 본문
          platformDetails, // 알림 설정
        );
      }
    }
  }

}

