import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notification_article_model.dart';

class NotificationService extends APIService {
  /*

  알림 리스트 > 알림 조회

  */
  static Future<List<NotificationArticle>> getNotiList() async {
    var url = '$domainUrl/notifications';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken)['data']['accessToken'];

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));

      List<dynamic> body = responseBody['result'];
      List<NotificationArticle> notifications = body
          .map((dynamic item) => NotificationArticle.fromJson(item))
          .toList();
      return notifications;
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (responseBody['code'] == 'AT-C-002') {
        // 액세스 토큰 만료
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        // 로그아웃된 토큰 만료
        throw 'AT-C-007';
      } else {
        throw Exception('요청 오류');
      }
    }
  }

  /*

  알림 읽음 조회 > 알림 읽음 요청

   */
  static Future<bool> readNotification(int personalNoticeId) async {
    var url = '$domainUrl/notifications?id=$personalNoticeId';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    // 액세스 토큰만 보내기
    jwtToken = json.decode(jwtToken)['data']['accessToken'];

    var response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /*

  채팅 알림 설정 조회

   */
  static Future<void> getChatNotificationStatus() async {
    const url = 'http://3.34.2.246:8080/api/v1/notification/chat'; //mocksever

    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');
    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    final fcmToken = await FirebaseMessaging.instance.getToken();

    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
      "FcmToken": '$fcmToken'
    });

    //success
    if (response.statusCode == 200) {
      //fail
    } else {
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        // 액세스 토큰 만료
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        // 로그아웃된 토큰
        throw 'AT-C-007';
      } else {}
    }
  }

  /*

  채팅 알림 설정

   */
  static Future<bool> setChatNotification(bool notification, bool all) async {
    const url = 'http://3.34.2.246:8080/api/v1/notification/chat'; //mocksever

    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');
    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    final fcmToken = await FirebaseMessaging.instance.getToken();

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
          "FcmToken": '$fcmToken'
        },
        body: jsonEncode({
          "chatNotification": notification.toString(),
        }));

    //success
    if (response.statusCode == 200) {
      //알림값 읽어오기
      var notification = await APIService.storage.read(key: 'notifications');

      await getChatNotificationStatus();
      await APIService.storage.delete(key: 'notifications');
      if (all) {
      } else {}

      return true;
      //fail
    } else {
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        // 액세스 토큰 만료
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        // 로그아웃된 토큰
        throw 'AT-C-007';
      } else {}
      return false;
    }
  }
}
