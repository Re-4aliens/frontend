import 'package:aliens/models/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models/applicant_model.dart';
import 'models/auth_model.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import 'models/memberDetails_model.dart';
import 'models/partner_model.dart';
import 'models/screenArgument.dart';

class APIs {
  static final storage = FlutterSecureStorage();

  /*

  이메일 중복 확인

   */
  static Future<bool> checkExistence(String email) async {
    var _url =
        'http://13.125.205.59:8080/api/v1/member/email/${email}/existence'; //mocksever

    var response = await http.get(Uri.parse(_url));

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));

      return json.decode(utf8.decode(response.bodyBytes))['data']['existence'];
      //fail
    } else {
      print(response.body);
      return json.decode(utf8.decode(response.bodyBytes))['data']['existence'];
    }
  }

  /*

  이메일 인증 요청

   */
  static Future<bool> verifyEmail(String email) async {
    var _url =
        'http://13.125.205.59:8080/api/v1/email/${email}/verification'; //mocksever

    var response = await http.post(Uri.parse(_url));

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
      //fail
    } else {
      print(response.body);
      return false;
    }
  }

  /*

  이메일 인증 상태 요청

   */
  static Future<String> getAuthenticationStatus(String email) async {
    var _url =
        'http://13.125.205.59:8080/api/v1/member/${email}/authentication-status'; //mocksever

    var response = await http.get(Uri.parse(_url));

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return json.decode(utf8.decode(response.bodyBytes))['data']['status'];
      //fail
    } else {
      print(response.body);
      return json.decode(utf8.decode(response.bodyBytes))['data']['status'];
    }
  }


  /*

  회원가입

   */
  static Future<bool> signUp(SignUpModel member) async {
    const url = 'http://13.125.205.59:8080/api/v1/member';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // FormData 텍스트 필드 추가
    request.fields['email'] = member.email!;
    request.fields['password'] = member.password!;
    request.fields['mbti'] = member.mbti!;
    request.fields['gender'] = member.gender!;
    request.fields['nationality'] = '1';
    request.fields['birthday'] = member.birthday!;
    request.fields['name'] = member.name!;

    // FormData 파일 필드 추가
    if (member.profileImage != null) {
      var file = await http.MultipartFile.fromPath(
        'profileImage',
        member.profileImage!
      );
      request.files.add(file);
    }

    // request 전송
    var response = await request.send();

    // success
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    // fail
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }
  /*

  로그인

   */
  static Future<bool> logIn(Auth auth) async {
    const url =
        'http://13.125.205.59:8080/api/v1/member/authentication'; //mocksever

    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": auth.email,
          "password": auth.password,
        }));

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));

      //로그인 정보 저장
      await storage.write(
        key: 'auth',
        value: jsonEncode(auth),
      );

      //토큰 저장
      await storage.write(
        key: 'token',
        value: jsonEncode(json.decode(utf8.decode(response.bodyBytes))['data']),
      );

      return true;
      //fail
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
    const url =
        'http://13.125.205.59:8080/api/v1/member/authentication'; //mocksever

    //토큰 읽어오기
    var accessToken = await storage.read(key: 'token');
    var refreshToken = await storage.read(key: 'token');

    accessToken = json.decode(accessToken!)['accessToken'];
    refreshToken = json.decode(refreshToken!)['refreshToken'];


    var response = await http.delete(Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'RefreshToken': '$refreshToken',
      },
    );

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));

      //토큰 및 정보 삭제
      await storage.delete(key: 'auth');
      await storage.delete(key: 'token');
      print('로그아웃, 정보 지움');

      //스택 비우고 화면 이동
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
      );

      //fail
    } else {
      print(response.body);
    }
  }

  /*

  임시 비밀번호 발급

   */
  static Future<bool> temporaryPassword(email, name) async {
    var _url =
        'http://13.125.205.59:8080/api/v1/member/${email}/password/temp'; //mocksever

    var response = await http.post(Uri.parse(_url),
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
    var _url = 'http://13.125.205.59:8080/api/v1/member/password'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');
    var userInfo = await storage.read(key: 'auth');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['accessToken'];

    var response = await http.put(
      Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "currentPassword":json.decode(userInfo!)['password'],
          "newPassword" : newPassword,
        })
    );

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

  탈퇴

   */
  static Future<bool> withdraw(password) async {
    var _url = 'http://13.125.205.59:8080/api/v1/member/withdraw'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');
    //accessToken
    jwtToken = json.decode(jwtToken!)['accessToken'];

    var refreshToken = await storage.read(key: 'token');
    refreshToken = json.decode(refreshToken!)['refreshToken'];


    var response = await http.post(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
        'RefreshToken': '$refreshToken',
      },
        body: jsonEncode({
          "password" : password,
        })
    );

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



  //유저 정보 요청
  static Future<Map<String, dynamic>> getMemberDetails() async {
    var _url = 'http://13.125.205.59:8080/api/v1/member'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['accessToken'];

    var response = await http.get(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json'
      },
    );

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return json.decode(utf8.decode(response.bodyBytes))['data'];

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes))['message']);
      throw Exception('요청 오류');
    }
  }

  //매칭 상태 요청
  static Future<String> getApplicantStatus() async {
    var _url = 'http://13.125.205.59:8080/api/v1/matching/status'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['accessToken'];

    var response = await http.get(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json'
      },
    );

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return json.decode(utf8.decode(response.bodyBytes))['data']['status'];

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes))['message']);
      throw Exception('요청 오류');
    }
  }

  //매칭 정보 요청
  static Future<Map<String, dynamic>> getApplicantInfo() async {
    const url =
        'http://13.125.205.59:8080/api/v1/matching/applicant'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['accessToken'];

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json'
      },
    );

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return json.decode(utf8.decode(response.bodyBytes))['data'];
      //fail
    } else {
      //오류 생기면 바디 확인
      print(json.decode(utf8.decode(response.bodyBytes))['message']);
      throw Exception('요청 오류');
    }
  }

  //상대 정보 요청
  static Future<List<Partner>> getApplicantPartners() async {
      const url = 'http://13.125.205.59:8080/api/v1/matching/partners';

      //토큰 읽어오기
      var jwtToken = await storage.read(key: 'token');

      //accessToken만 보내기
      jwtToken = json.decode(jwtToken!)['accessToken'];

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'
        },
      );

      //success
      if (response.statusCode == 200) {
        print(json.decode(utf8.decode(response.bodyBytes)));
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes))['data']['partners'];
        return body.map((dynamic item) => Partner.fromJson(item)).toList();

        //fail
      } else {
        //오류 생기면 바디 확인
        print(json.decode(utf8.decode(response.bodyBytes))['message']);
        throw Exception('요청 오류');
      }
  }

/*
  Future<Map<String, dynamic>> getData() async {
    var memberDetails = Provider.of<MemberProvider>(context, listen: false);
    status = await applicantStatus();
    if(status['status'] == 'MATCHED'){
      applicant = await applicantInfo();
      partners = await applicantPartners();
    }
    return memberDetails.memberInfo();
  }

 */

  static Future<ScreenArguments> getMatchingData() async {

    late ScreenArguments _screenArguments;

    late MemberDetails _memberDetails;
    late String _status;
    late Applicant? _applicant;
    late List<Partner>? _partners;

    _status = await APIs.getApplicantStatus();
    _memberDetails = MemberDetails.fromJson(await APIs.getMemberDetails());

    if(_status == 'MATCHED') {
      _applicant = Applicant.fromJson(await APIs.getApplicantInfo());
      _partners = await APIs.getApplicantPartners();
    }
    else{
      _applicant = null;
      _partners = null;
    }

    _screenArguments = new ScreenArguments(_memberDetails, _status, _applicant, _partners);

    return _screenArguments;
  }

}