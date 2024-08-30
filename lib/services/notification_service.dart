import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notification_article_model.dart';

class NotificationService extends APIService {
  /*

      fcm 토큰 등록

  */
  static Future<void> registerFCMToken() async {
    const url = '$domainUrl/notifications/fcm';
    String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': jwtToken,
          },
          body: jsonEncode({
            'fcmToken': fcmToken,
          }));

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final result = responseBody['result'];
      } else {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /*

  알림 리스트 > 알림 조회

  */
  static Future<List<NotificationArticle>> getNotiList() async {
    var url = '$domainUrl/notifications';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8'
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

      fcm 알림 상태 조회

   */
  static Future<bool> getNotificationStatus() async {
    const url = '$domainUrl/notifications/fcm';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': jwtToken,
      },
    );

    //success
    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final result = responseBody['result'];
      return result;
      //fail
    } else {
      return false;
    }
  }

  /*

    fcm 알림 상태 변경

   */
  static Future<void> setNotification(bool decision) async {
    final url = '$domainUrl/notifications/fcm?decision=$decision';
    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token') ?? '';
    print(jwtToken);

    var response = await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': jwtToken,
      },
    );

    //success
    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final result = responseBody['result'];
      print(result);
      //fail
    } else {
      print(utf8.decode(response.bodyBytes));
      print("실패");
    }
  }
}
