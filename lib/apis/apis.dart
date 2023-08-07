
import 'package:aliens/mockdatas/mockdata_model.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/signup_model.dart';
import 'package:aliens/views/components/message_bubble_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import '../models/applicant_model.dart';
import '../models/auth_model.dart';
import 'dart:io';


import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import '../models/memberDetails_model.dart';
import '../models/message_model.dart';
import '../models/partner_model.dart';
import '../models/screenArgument.dart';

class APIs {
  static final storage = FlutterSecureStorage();

  /*

  이메일 중복 확인

   */
  static Future<bool> checkExistence(String email) async {
    var _url =
        'http://3.34.2.246:8080/api/v1/member/email/${email}/existence'; //mocksever

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
        'http://3.34.2.246:8080/api/v1/email/${email}/verification'; //mocksever

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
        'http://3.34.2.246:8080/api/v1/email/${email}/authentication-status'; //mocksever

    var response = await http.get(Uri.parse(_url));

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return json.decode(utf8.decode(response.bodyBytes))['data']['status'];
      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return json.decode(utf8.decode(response.bodyBytes))['data']['status'];
    }
  }


  /*

  회원가입

   */
  static Future<bool> signUp(SignUpModel member) async {
    const url = 'http://3.34.2.246:8080/api/v1/member';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // FormData 텍스트 필드 추가
    request.fields['email'] = member.email!;
    request.fields['password'] = member.password!;
    request.fields['mbti'] = member.mbti!;
    request.fields['gender'] = member.gender!;
    request.fields['nationality'] = member.nationality!;
    request.fields['birthday'] = member.birthday!;
    request.fields['name'] = member.name!;

    if (member.selfIntroduction != null && member.selfIntroduction!.isNotEmpty) {
      request.fields['selfIntroduction'] = member.selfIntroduction!;
    }else{
      request.fields['selfIntroduction'] = ' ';
    }
    // FormData 파일 필드 추가
    if (member.profileImage != null && member.profileImage!.isNotEmpty) {
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
      print(await response.stream.bytesToString());
      return false;
    }
  }

  /*

  로그인

   */
  static Future<bool> logIn(Auth auth, String fcmToken) async {
    const url =
        'http://3.34.2.246:8080/api/v1/auth/authentication'; //mocksever

    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "FcmToken": fcmToken
        },
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
        value: jsonEncode(json.decode(utf8.decode(response.bodyBytes))),
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
        'http://3.34.2.246:8080/api/v1/auth/logout'; //mocksever

    //토큰 읽어오기
    var accessToken = await storage.read(key: 'token');
    var refreshToken = await storage.read(key: 'token');

    accessToken = json.decode(accessToken!)['data']['accessToken'];
    refreshToken = json.decode(refreshToken!)['data']['refreshToken'];


    final fcmToken = await FirebaseMessaging.instance.getToken();
    var response = await http.delete(Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'RefreshToken': '$refreshToken',
        "FcmToken": '${fcmToken}'
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
      print(json.decode(utf8.decode(response.bodyBytes)));
    }
  }

  /*

  임시 비밀번호 발급

   */
  static Future<bool> temporaryPassword(email, name) async {
    var _url =
        'http://3.34.2.246:8080/api/v1/member/${email}/password/temp'; //mocksever

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
    var _url = 'http://3.34.2.246:8080/api/v1/member/password'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');
    var userInfo = await storage.read(key: 'auth');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.put(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "currentPassword": json.decode(userInfo!)['password'],
          "newPassword": newPassword,
        })
    );

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002'){
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007'){
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }else{

      }
      return false;
    }
  }


  /*

  탈퇴

   */
  static Future<bool> withdraw(password) async {
    var _url = 'http://3.34.2.246:8080/api/v1/member/withdraw'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');
    //accessToken
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var refreshToken = await storage.read(key: 'token');
    refreshToken = json.decode(refreshToken!)['data']['refreshToken'];


    var response = await http.delete(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
          'RefreshToken': '$refreshToken',
        },
        body: jsonEncode({
          "password": password,
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
    var _url = 'http://3.34.2.246:8080/api/v1/member'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

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
      print(json.decode(utf8.decode(response.bodyBytes)));
      if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002'){
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007'){
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }else{

      }
      throw Exception('요청 오류');
    }
  }

  //매칭 상태 요청
  static Future<String> getApplicantStatus() async {
    var _url = 'http://3.34.2.246:8080/api/v1/applicant/status'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.get(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json'
      },
    );
    //success
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes))['data']['status'];
      print('매칭 상태 요청 ${json.decode(utf8.decode(response.bodyBytes))}');



      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002'){
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007'){
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }else if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'MT-C-005'){
        print('정보 없음');
        return "NOT_APPLIED";
      }else{

      }
      throw Exception('요청 오류');
    }
  }

  //매칭 정보 요청
  static Future<Map<String, dynamic>> getApplicantInfo() async {
    const url =
        'http://3.34.2.246:8080/api/v1/applicant'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

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
      print(json.decode(utf8.decode(response.bodyBytes)));
      return json.decode(utf8.decode(response.bodyBytes))['data'];
      //fail
    } else {
      //오류 생기면 바디 확인
      print(json.decode(utf8.decode(response.bodyBytes)));
      if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002'){
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007'){
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }else{

      }
      throw Exception('요청 오류');
    }
  }

  //상대 정보 요청
  static Future<List<Partner>> getApplicantPartners() async {
    const url = 'http://3.34.2.246:8080/api/v1/applicant/partners';

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

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
      print(json.decode(utf8.decode(response.bodyBytes)));
      List<dynamic> body = json.decode(
          utf8.decode(response.bodyBytes))['data']['partners'];
      return body.map((dynamic item) => Partner.fromJson(item)).toList();

      //fail
    } else {
      //오류 생기면 바디 확인
      print(json.decode(utf8.decode(response.bodyBytes)));
      if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002'){
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007'){
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }else{

      }

      //임의로 넣어두겠습니다
      List<Partner> _partners = [
        Partner(memberId: 0,
          name: "",
          mbti: "",
          gender: "",
          nationality: "",
          profileImage: "",
          selfIntroduction:"",

        ),
        Partner(memberId: 0,
          name: "",
          mbti: "",
          gender: "",
          nationality: "",
          profileImage: "",
          selfIntroduction:"",

        ),
        Partner(memberId: 0,
          name: "",
          mbti: "",
          gender: "",
          nationality: "",
          profileImage: "",
          selfIntroduction:"",

        ),
        Partner(memberId: 0,
          name: "",
          mbti: "",
          gender: "",
          nationality: "",
          profileImage: "",
          selfIntroduction:"",

        )
      ];
      return _partners;
    }
  }

  static Future<bool> getAccessToken() async {
    print('accesstoken 재발급');
    const url =
        'http://3.34.2.246:8080/api/v1/auth/reissue'; //mocksever

    //토큰 읽어오기
    var accessToken = await storage.read(key: 'token');
    var refreshToken = await storage.read(key: 'token');

    accessToken = json.decode(accessToken!)['data']['accessToken'];
    refreshToken = json.decode(refreshToken!)['data']['refreshToken'];


    var response = await http.post(Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'RefreshToken': '$refreshToken',
      },
    );

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      //만료되지 않았다면
      //발급받은 새로운 accesstoken을 저장
      await storage.write(
        key: 'token',
        value: jsonEncode(json.decode(utf8.decode(response.bodyBytes))),
      );
      //Navigator.pushNamedAndRemoveUntil(context, '/loading', (route) => false);
      return true;

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      //refresh token이 만료되었다면 재로그인
      if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-005'){
        //start page로 이동
        throw 'AT-C-005';
      }else if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-006'){
        //start page로 이동
        return false;
      }else {

      }
      print(json.decode(utf8.decode(response.bodyBytes)));
      return false;
    }
  }

  static Future<ScreenArguments> getMatchingData(context) async {
    late ScreenArguments _screenArguments;

    late MemberDetails _memberDetails;
    late String _status;
    late Applicant? _applicant;
    late List<Partner>? _partners;

    try {
      _status = await APIs.getApplicantStatus();
    } catch (e) {
      if(e == "AT-C-002"){
        try{
          await APIs.getAccessToken();
        }catch (e){
          if(e == "AT-C-005") {
            //토큰 및 정보 삭제
            await storage.delete(key: 'auth');
            await storage.delete(key: 'token');
            print('로그아웃, 정보 지움');

            //스택 비우고 화면 이동
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
            );
          }
            else{
            _status = await APIs.getApplicantStatus();
          }
          }
      }
      else if(e == "AT-C-007"){
        //토큰 및 정보 삭제
        await APIs.logOut(context);
      }
    }

    _memberDetails = MemberDetails.fromJson(await APIs.getMemberDetails());

    _applicant = _status != 'NOT_APPLIED'
        ? Applicant.fromJson(await APIs.getApplicantInfo())
        : null;
    _partners = _status == 'MATCHED' ? await APIs.getApplicantPartners() : null;

    _screenArguments =
    new ScreenArguments(_memberDetails, _status, _applicant, _partners);

    //return mockScreenArgument_2;
    return _screenArguments;
  }


  /*

  mbti 수정

   */
  static Future<bool> updateMBTI(String mbti) async {
    var url = 'http://3.34.2.246:8080/api/v1/member';

    // 토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    // 액세스 토큰만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    // 업데이트할 MBTI 정보를 담은 Map 생성
    var requestData = {
      'mbti': mbti,
    };
    var response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestData),
    );
    //성공
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
    }
    //실패
    else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return false;
    }
  }


/*

프로필 수정

 */

  static Future<bool> updateProfile(File profileImageFile) async {
    var url = 'http://3.34.2.246:8080/api/v1/member/profile-image';

    // 토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    // 액세스 토큰만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    // MultipartFile로 변환

    var profileImage = await http.MultipartFile.fromPath(
      'profileImage',
      profileImageFile.path,
    );

    // FormData 생성
    var formData = http.MultipartRequest('PUT', Uri.parse(url));
    formData.headers['Authorization'] = 'Bearer $jwtToken';
    formData.files.add(profileImage);

    // 요청 전송
    var response = await formData.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }

  /*
  자기소개 수정
  */
  static Future<bool> updateSelfIntroduction(String selfIntroduction) async {
    var url = 'http://3.34.2.246:8080/api/v1/member/self-introduction';

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    // 액세스 토큰만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    // 업데이트할 MBTI 정보를 담은 Map 생성
    var requestData = {
      'selfIntroduction': selfIntroduction,
    };

    var response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestData),
    );

    //성공
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
    }
    //실패
    else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return false;
    }
  }

  /*

  선호 언어 수정

   */
  static Future<bool> updatePreferLanguage(String firstPreferLanguage,
      String secondPreferLanguage) async {
    var url = 'http://3.34.2.246:8080/api/v1/applicant/prefer-languages';

    // 토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    // 액세스 토큰만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "firstPreferLanguage": firstPreferLanguage,
        "secondPreferLanguage": secondPreferLanguage,
      }),
    );
    //성공
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
    }
    //실패
    else {
      print('언어 수정 요청 ${json.decode(utf8.decode(response.bodyBytes))}');
      return false;
    }
  }


  /*


  매칭 신청

   */
  static Future<bool> applicantMatching(String firstPreferLanguage,
      String secondPreferLanguage) async {
    var _url =
        'http://3.34.2.246:8080/api/v1/applicant'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'},
        body: jsonEncode({
          "firstPreferLanguage": firstPreferLanguage,
          "secondPreferLanguage": secondPreferLanguage,
        }));

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002'){
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007'){
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }else{

      }
      return false;
    }
  }


  /*

  회원 정보 삭제
  http://13.125.205.5ㅐ9:8080/api/v1/member/906
   */
  static Future<void> deleteInfo(memberId) async {
    var url =
        'http://3.34.2.246:8080/api/v1/member/${memberId}';


    var response = await http.delete(Uri.parse(url),
    );

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));

      //fail
    } else {
      print(response.body);
    }
  }

  /*

  채팅룸 정보 => 변경

   */
  /*
  static Future<List<ChatRoom>> getChatRooms() async {
    var _url = 'http://13.125.205.59:8080/chat/rooms';

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
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes))['response'];
      return body.map((dynamic item) => ChatRoom.fromJson(item)).toList();

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes))['message']);
      throw Exception('요청 오류');
    }
  }

   */

  /*

  메세지 받아오기

   */

  static Future<List<MessageModel>> getMessages(roomId, context) async {
    var _url =
        'http://3.34.2.246:8081/api/v1/chat/${roomId}'; //mocksever


    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];
    print('chat 토큰 읽기');
    String chatToken = '';
    try {
      chatToken = await APIs.getChatToken();
    } catch (e) {
      print(e);
      if(e == "AT-C-002"){
        try{
          await APIs.getAccessToken();
        }catch (e) {
          if (e == "AT-C-005") {
            //토큰 및 정보 삭제
            await storage.delete(key: 'auth');
            await storage.delete(key: 'token');
            print('로그아웃, 정보 지움');

            //스택 비우고 화면 이동
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
            );
          }
        }
        chatToken = await APIs.getChatToken();
      }
    }

    var response = await http.get(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
        'ChattingToken': '$chatToken'
      },
    );

    //success
    if (response.statusCode == 200) {
      print('안읽은 메세지 요청');
      print(json.decode(utf8.decode(response.bodyBytes)));
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => MessageModel.fromJson(item)).toList();
      //return List.from(value.reversed);

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      throw Exception('요청 오류');
    }
  }


  // 채팅 토큰 받아오기
  static Future<String> getChatToken() async {
    var _url = 'http://3.34.2.246:8080/api/v1/chat/token';
    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.get(
      Uri.parse(_url),
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

      print(json.decode(utf8.decode(response.bodyBytes)));
      if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002'){
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007'){
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }else{

      }

      throw Exception('요청 오류');
    }
  }

  // 채팅 정보 받아오기
  static Future<Map<String, dynamic>> getChatSummary(context) async {
    var _url = 'http://3.34.2.246:8081/api/v1/chat/summary';
    print('토큰 읽기');
    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');
    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    print('chat 토큰 읽기');
    String chatToken = '';
    try {
      chatToken = await APIs.getChatToken();
    } catch (e) {
      if(e == "AT-C-002"){
        print(e);
        try{
          await APIs.getAccessToken();
        }catch (e){
          if(e == "AT-C-005"){
            //토큰 및 정보 삭제
            await storage.delete(key: 'auth');
            await storage.delete(key: 'token');
            print('로그아웃, 정보 지움');

            //스택 비우고 화면 이동
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
            );

          }
        }
        chatToken = await APIs.getChatToken();
      }
    }

    var response = await http.get(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
        'ChattingToken': '$chatToken'
      },
    );

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));

      return json.decode(utf8.decode(response.bodyBytes));

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002'){
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007'){
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }else{

      }
      throw Exception('요청 오류');
    }
  }

  /*

  매칭 완료 일시

  */
static Future<String> matchingProfessData() async{
  var _url = Uri.parse('http://3.34.2.246:8080/api/v1/applicant/completion-date');

  //토큰 읽어오기
  var jwtToken = await storage.read(key: 'token');
  //accessToken만 보내기
  jwtToken = json.decode(jwtToken!)['data']['accessToken'];

  var response = await http.get(
    _url,
    headers: {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print(json.decode(utf8.decode(response.bodyBytes)));
    return json.decode(utf8.decode(response.bodyBytes))['data']['matchingCompleteDate'];

  } else {
    print(json.decode(utf8.decode(response.bodyBytes)));
    if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002'){
      print('액세스 토큰 만료');
      throw 'AT-C-002';
    } else if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007'){
      print('로그아웃된 토큰');
      throw 'AT-C-007';
    }else{

    }
    throw Exception('요청 오류');
  }
}

  /*

  채팅 알림 설정 조회

   */
  static Future<void> getChatNotificationStatus() async {
    const url =
        'http://3.34.2.246:8080/api/v1/notification/chat'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');
    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    final fcmToken = await FirebaseMessaging.instance.getToken();

    var response = await http.get(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
          "FcmToken": '$fcmToken'
        });

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002'){
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007'){
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }else{

      }
    }
  }

  /*

  채팅 알림 설정

   */
  static Future<bool> setChatNotification(bool _notification, bool all) async {
    const url =
        'http://3.34.2.246:8080/api/v1/notification/chat'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');
    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];


    //알림값 읽어오기
    var notification = await storage.read(key: 'notification');

    var allNotification = json.decode(notification!)['allNotification'];
    var matchingNotification = json.decode(notification!)['matchingNotification'];
    var chatNotification = json.decode(notification!)['chatNotification'];


    final fcmToken = await FirebaseMessaging.instance.getToken();

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
          "FcmToken": '$fcmToken'
        },
        body: jsonEncode({
          "chatNotification": _notification.toString(),
        }));

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      await getChatNotificationStatus();
      await storage.delete(key: 'notification');
      if(all){
        await storage.write(
          key: 'notification',
          value: jsonEncode({
            'allNotification' : _notification,
            'matchingNotification' : _notification,
            'chatNotification' : _notification,
          }),
        );
      }
      else{
        if(matchingNotification == _notification && _notification == true){
          allNotification = true;
        }else {
          allNotification = false;
        }
        await storage.write(
          key: 'notification',
          value: jsonEncode({
            'allNotification' : allNotification,
            'matchingNotification' : matchingNotification,
            'chatNotification' : _notification,
          }),
        );
      }

      return true;
      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002'){
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007'){
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }else{

      }
      return false;
    }
  }

  /*

  신고하기

   */

  static Future<bool> reportPartner(String reportCategory, String reportContent, int memberId) async {
    var _url =
        'http://3.34.2.246:8080/api/v1/report/${memberId}'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'},
        body: jsonEncode({
          "reportCategory": reportCategory,
          "reportContent": reportContent,
        }));

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002'){
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007'){
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }else{

      }
      return false;
    }
  }

  /*

  신고하기

   */

  static Future<bool> blockPartner(Partner partner) async {
    var _url =
        'http://3.34.2.246:8080/api/v1/block/${partner.memberId}'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'},
        body: jsonEncode({
          "roomId": '${partner.roomId}',
        }));

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002'){
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if(json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007'){
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }else{

      }
      return false;
    }
  }

}