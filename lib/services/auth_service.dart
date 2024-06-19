import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/auth_model.dart';

class AuthService extends APIService {
  /*
  
  로그인

   */
  static Future<bool> logIn(Auth auth) async {
    const url = '$domainUrl/authentication';

    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
          },
          body: jsonEncode({
            "email": auth.email,
            "password": auth.password,
          }));

      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        APIService.token = responseBody['result']['accessToken'];
        APIService.refreshToken = responseBody['result']['refreshToken'];

        // 로그인 성공 시 토큰 저장
        await APIService.storage.write(key: 'token', value: APIService.token!);
        await APIService.storage
            .write(key: 'refreshToken', value: APIService.refreshToken!);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /*

  로그아웃

   */
  static Future<void> logOut(BuildContext context) async {
    const url = '$domainUrl/authentication/logout';

    // 토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token') ?? '';
    APIService.refreshToken =
        await APIService.storage.read(key: 'refreshToken') ?? '';

    var body = jsonEncode({
      'accessToken': jwtToken,
      'refreshToken': APIService.refreshToken,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // 토큰 및 정보 삭제
      await APIService.storage.delete(key: 'auth');
      await APIService.storage.delete(key: 'jwtToken');
      await APIService.storage.delete(key: 'refreshToken');
      await APIService.storage.delete(key: 'notifications');
      print('로그아웃, 정보 지움');

      // 스택 비우고 화면 이동
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } else {
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
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
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      }),
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
    } else {
      // 토큰 재발급 실패
      return false;
    }
  }
  /*

  임시 비밀번호 발급

   */

  static Future<String> temporaryPassword(email, name) async {
    var url = '$domainUrl/members/temporary-password';

    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "name": name,
        }));

    if (response.statusCode == 200) {
      return "M003"; // 성공 코드
    } else {
      return "Error: ${response.statusCode}";
    }
  }

  /*

  비밀번호 변경

   */
  static Future<bool> changePassword(String newPassword) async {
    var url = '$domainUrl/members/password';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode({
        "newPassword": newPassword,
      }),
    );

    var responseBody = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return true;
    } else {
      if (responseBody['code'] == 'AT-C-002') {
        // 엑세스 토큰 만료
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        // 로그아웃된 토큰
        throw 'AT-C-007';
      } else {
        // 예외
      }
      return false;
    }
  }

  /*

  탈퇴 //테스트실패

   */
  static Future<bool> withdraw(password) async {
    var url = '$domainUrl/members/withdraw';

    // 토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
      },
    );

    // 성공
    if (response.statusCode == 200) {
      return true;
    }
    // 실패
    else {
      return false;
    }
  }
}
