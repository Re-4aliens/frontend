import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'package:aliens/models/message_model.dart';
import 'package:aliens/services/auth_service.dart';
import 'package:flutter/material.dart';

class ChatService extends APIService {
  /*

  메세지 받아오기

   */
  static Future<List<MessageModel>> getMessages(roomId, context) async {
    var url = 'http://3.34.2.246:8081/api/v1/chat/$roomId'; //mocksever

    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];
    String chatToken = '';
    try {
      chatToken = await getChatToken();
    } catch (e) {
      if (e == "AT-C-002") {
        try {
          await AuthService.getAccessToken();
        } catch (e) {
          if (e == "AT-C-005") {
            //토큰 및 정보 삭제
            await APIService.storage.delete(key: 'auth');
            await APIService.storage.delete(key: 'token');

            //스택 비우고 화면 이동
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          }
        }
        chatToken = await getChatToken();
      }
    }

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
        'ChattingToken': chatToken
      },
    );

    //success
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => MessageModel.fromJson(item)).toList();
      //fail
    } else {
      throw Exception('요청 오류');
    }
  }

  /*
  
    채팅 토큰 받아오기

   */
  static Future<String> getChatToken() async {
    var url = 'http://3.34.2.246:8080/api/v1/chat/token';
    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json'
      },
    );

    //success
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes))['data'];

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

      throw Exception('요청 오류');
    }
  }

  /* 

    채팅 정보 받아오기

  */
  static Future<Map<String, dynamic>> getChatSummary(context) async {
    var url = 'http://3.34.2.246:8081/api/v1/chat/summary';
    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');
    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    String chatToken = '';
    try {
      chatToken = await getChatToken();
    } catch (e) {
      if (e == "AT-C-002") {
        print(e);
        try {
          await AuthService.getAccessToken();
        } catch (e) {
          if (e == "AT-C-005") {
            //토큰 및 정보 삭제
            await APIService.storage.delete(key: 'auth');
            await APIService.storage.delete(key: 'token');

            //스택 비우고 화면 이동
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          }
        }
        chatToken = await getChatToken();
      }
    }

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
        'ChattingToken': chatToken
      },
    );

    //success
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));

      //fail
    } else {
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        throw 'AT-C-007';
      } else {}
      throw Exception('요청 오류');
    }
  }
}
