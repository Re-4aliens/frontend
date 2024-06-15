import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/widgets.dart';
import 'package:aliens/models/memberDetails_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
/*
class MemberProvider with ChangeNotifier {
  Member member = new Member();
  static final storage = FlutterSecureStorage();
  var response;

  Future<Map<String, dynamic>> memberInfo() async {
    print('멤버 정보 요청');
    try {
      const url =
          'http://13.125.205.59:8080/api/v1/member'; //mocksever

      //토큰 읽어오기
      var jwtToken = await storage.read(key: 'token');

      //accessToken만 보내기
      jwtToken = json.decode(jwtToken!)['accessToken'];


      response = await http.get(Uri.parse(url),
        headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json'},
      );

      //success
      if (response.statusCode == 200) {
        print('멤버 정보 요청 성공');
        member = Member.fromJson(json.decode(utf8.decode(response.bodyBytes))['response']);


        //fail
      } else {
        //오류 생기면 바디 확인
        print("요청 오류: " + response.statusCode.toString());
      }
    } catch (error) {
      print(error);
      throw error;
    }
    //변경되었다고 알리기
    notifyListeners();
    return json.decode(utf8.decode(response.bodyBytes))['response'];
  }
}


 */