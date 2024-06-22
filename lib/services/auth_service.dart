import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/auth_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService extends APIService {
  /*
  
  로그인

   */
  static Future<bool> logIn(Auth auth, String fcmToken) async {
    const url = 'http://3.34.2.246:8080/api/v1/auth/authentication'; //mocksever

    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "FcmToken": fcmToken,
        },
        body: jsonEncode({
          "email": auth.email,
          "password": auth.password,
        }));

    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));

      //로그인 정보 저장
      await APIService.storage.write(
        key: 'auth',
        value: jsonEncode(auth),
      );
      //토큰 저장
      await APIService.storage.write(
        key: 'token',
        value: jsonEncode(json.decode(utf8.decode(response.bodyBytes))),
      );
      return true;
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return false;
    }
  }

  /*

  로그아웃

   */
  static Future<void> logOut(BuildContext context) async {
    print('로그아웃 시도');
    const url = 'http://3.34.2.246:8080/api/v1/auth/logout'; //mocksever

    //토큰 읽어오기
    var accessToken = await APIService.storage.read(key: 'token');
    var refreshToken = await APIService.storage.read(key: 'token');

    accessToken = json.decode(accessToken!)['data']['accessToken'];
    refreshToken = json.decode(refreshToken!)['data']['refreshToken'];

    final fcmToken = await FirebaseMessaging.instance.getToken();
    var response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'RefreshToken': '$refreshToken',
        "FcmToken": '$fcmToken'
      },
    );

    if (response.statusCode == 200) {
      // 토큰 및 정보 삭제
      await APIService.storage.delete(key: 'auth');
      await APIService.storage.delete(key: 'token');
      await APIService.storage.delete(key: 'notifications');
      print('로그아웃, 정보 지움');
      print('로그아웃, 정보 지움');

      //스택 비우고 화면 이동
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } else {
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        await getAccessToken();
        await logOut(context);
      }
    }
  }

  /*

  토큰 재발급

   */
  static Future<bool> getAccessToken() async {
    const url = '$domainUrl/authentication/reissue';

    // 토큰 읽어오기
    var accessToken = await APIService.storage.read(key: 'token');
    var refreshToken = await APIService.storage.read(key: 'refreshToken');

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'RefreshToken': '$refreshToken',
      },
    );

    if (response.statusCode == 200) {
      // 발급받은 새로운 access token 저장
      var responseData = json.decode(utf8.decode(response.bodyBytes));

      String newAccessToken = responseData["result"]["accessToken"];
      String newRefreshToken = responseData["result"]["refreshToken"];

      await APIService.storage.write(key: 'token', value: newAccessToken);
      await APIService.storage
          .write(key: 'refreshToken', value: newRefreshToken);

      return true;
    }
    print(json.decode(utf8.decode(response.bodyBytes)));
    //refresh token이 만료되었다면 재로그인
    if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-005') {
      //start page로 이동
      throw 'AT-C-005';
    } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
        'AT-C-006') {
      //start page로 이동
      return false;
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return false;
    }
  }
  /*

  임시 비밀번호 발급

   */

  static Future<bool> temporaryPassword(email, name) async {
    var url =
        'http://3.34.2.246:8080/api/v1/member/$email/password/temp'; //mocksever

    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
        }));
    print('발급 요청');

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return false;
    }
  }

  /*

  비밀번호 변경

   */
  static Future<bool> changePassword(newPassword) async {
    var url0 = 'http://3.34.2.246:8080/api/v1/member/password'; //mocksever

    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');
    var userInfo = await APIService.storage.read(key: 'auth');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.put(Uri.parse(url0),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "currentPassword": json.decode(userInfo!)['password'],
          "newPassword": newPassword,
        }));

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {}
      return false;
    }
  }

  /*

  탈퇴 

   */
  static Future<bool> withdraw(password) async {
    var url = 'http://3.34.2.246:8080/api/v1/member/withdraw'; //mocksever

    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');
    //accessToken
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var refreshToken = await APIService.storage.read(key: 'token');
    refreshToken = json.decode(refreshToken!)['data']['refreshToken'];

    var response = await http.delete(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
          'RefreshToken': '$refreshToken',
        },
        body: jsonEncode({
          "password": password,
        }));

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return false;
    }
  }
}
