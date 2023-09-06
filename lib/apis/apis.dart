
import 'package:aliens/mockdatas/mockdata_model.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/market_articles.dart';
import 'package:aliens/models/signup_model.dart';
import 'package:aliens/views/components/message_bubble_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/applicant_model.dart';
import '../models/auth_model.dart';
import 'dart:io';
import 'package:aliens/lib/views/components/total_article_widget.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import '../models/board_model.dart';
import '../models/comment_model.dart';
import '../models/market_articles.dart';
import '../models/market_comment.dart';
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

    if (member.selfIntroduction != null &&
        member.selfIntroduction!.isNotEmpty) {
      request.fields['selfIntroduction'] = member.selfIntroduction!;
    } else {
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
      await storage.delete(key: 'notification');
      print('로그아웃, 정보 지움');

      //스택 비우고 화면 이동
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
      );

      //fail
    } else {
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        await APIs.getAccessToken();
        await APIs.logOut(context);
      }
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
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

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
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

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
      print('${json.decode(utf8.decode(response.bodyBytes))}');
      return json.decode(utf8.decode(response.bodyBytes))['data']['status'];


      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'MT-C-005') {
        print('정보 없음');
        return "NotAppliedAndNotMatched";
      } else {

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
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

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
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

      }

      //임의로 넣어두겠습니다
      List<Partner> _partners = [
        Partner(memberId: 0,
          name: "",
          mbti: "",
          gender: "",
          nationality: "",
          profileImage: "",
          selfIntroduction: "",

        ),
        Partner(memberId: 0,
          name: "",
          mbti: "",
          gender: "",
          nationality: "",
          profileImage: "",
          selfIntroduction: "",

        ),
        Partner(memberId: 0,
          name: "",
          mbti: "",
          gender: "",
          nationality: "",
          profileImage: "",
          selfIntroduction: "",

        ),
        Partner(memberId: 0,
          name: "",
          mbti: "",
          gender: "",
          nationality: "",
          profileImage: "",
          selfIntroduction: "",

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
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-005') {
        //start page로 이동
        throw 'AT-C-005';
      }else if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-006'){
        //start page로 이동
        return false;
      } else {

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
      if (e == "AT-C-002") {
        try {
          await APIs.getAccessToken();
        } catch (e) {
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
          else {
            _status = await APIs.getApplicantStatus();
          }
        }
      }
      else if (e == "AT-C-007") {
        //토큰 및 정보 삭제
        await APIs.logOut(context);
      }
    }

    _memberDetails = MemberDetails.fromJson(await APIs.getMemberDetails());

    _applicant =
    _status == 'AppliedAndNotMatched' || _status == 'AppliedAndMatched'
        ? Applicant.fromJson(await APIs.getApplicantInfo())
        : null;
    _partners =
    _status == 'AppliedAndNotMatched' || _status == 'AppliedAndMatched'
        ? await APIs.getApplicantPartners()
        : null;

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
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'MT-C-005') {
        print('정보 없음');
        return false;
      } else {

      }
      throw Exception('요청 오류');
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
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

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
      if (e == "AT-C-002") {
        try {
          await APIs.getAccessToken();
        } catch (e) {
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
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

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
      if (e == "AT-C-002") {
        print(e);
        try {
          await APIs.getAccessToken();
        } catch (e) {
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
      print(json.decode(utf8.decode(response.bodyBytes)));

      return json.decode(utf8.decode(response.bodyBytes));

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

      }
      throw Exception('요청 오류');
    }
  }

  /*

  매칭 완료 일시

  */
  static Future<String> matchingProfessData() async {
    var _url = Uri.parse(
        'http://3.34.2.246:8080/api/v1/applicant/completion-date');

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
      return json.decode(
          utf8.decode(response.bodyBytes))['data']['matchingCompleteDate'];
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

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
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

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
      //알림값 읽어오기
      var notification = await storage.read(key: 'notification');

      var allNotification = json.decode(notification!)['allNotification'];
      var matchingNotification = json.decode(
          notification!)['matchingNotification'];
      var chatNotification = json.decode(notification!)['chatNotification'];


      await getChatNotificationStatus();
      await storage.delete(key: 'notification');
      if (all) {

      }
      else {

      }

      return true;
      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

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
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

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
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

      }
      return false;
    }
  }

  /*


  매칭 신청

   */
  static Future<bool> inquiry(String question) async {
    var _url =
        'http://3.34.2.246:8080/api/v1/member/question'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'},
        body: jsonEncode({
          "question": question,
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
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

      }
      return false;
    }
  }



  /*장터*/
/*  static Future<void> postDataWithImages({
    required String title,
    required String status,
    required int price,
    required String productStatus,
    required List<Asset> images,
    required String content,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['title'] = title;
    request.fields['status'] = status;
    request.fields['price'] = price.toString();
    request.fields['productStatus'] = productStatus;
    request.fields['content'] = content;

    List<File> files = await convertAssetsToFiles(images);

    for (var i = 0; i < files.length; i++) {
      var file = files[i];
      var stream = http.ByteStream(Stream.castFrom(file.openRead()));
      var length = await file.length();

      var multipartFile = http.MultipartFile('image$i', stream, length,
          filename: 'image$i.jpg');

      request.files.add(multipartFile);
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      print('API Response: ${await response.stream.bytesToString()}');
    } else {
      print('API Request failed with status ${response.statusCode}');
    }
  }

  static Future<List<File>> convertAssetsToFiles(List<Asset> assets) async {
    List<File> files = [];

    for (var asset in assets) {
      final byteData = await asset.getByteData();
      final buffer = byteData.buffer.asUint8List();
      final tempFile = File('${(await getTemporaryDirectory()).path}/${asset.name}');
      await tempFile.writeAsBytes(buffer);
      files.add(tempFile);
    }

    return files;
  }*/


  /*전체게시판 글 전부 조회*/
  static Future<List<Board>> TotalArticles() async {
    final _url = 'http://3.34.2.246:8080/api/v2/articles';

      //토큰 읽어오기
      var jwtToken = await storage.read(key: 'token');
      jwtToken = json.decode(jwtToken!)['data']['accessToken'];

      final response = await http.get(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print(json.decode(utf8.decode(response.bodyBytes)));
        List<dynamic> body = json.decode(
            utf8.decode(response.bodyBytes))['data'];
        List<dynamic> value = body.map((dynamic item) => Board.fromJson(item)).toList();
        return List.from(value.reversed);


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


/*전체 게시판 검색*/
  static Future<List<Board>> TotalSearch(String keyword) async {
    try {
      var jwtToken = await storage.read(key: 'token');
      jwtToken = json.decode(jwtToken!)['data']['accessToken'];

      final response = await http.get(
        Uri.parse(
            'http://3.34.2.246:8080/api/v2/articles?search-keyword=$keyword'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> articlesData = data['data'];

        //데이터를 list<board>객체로 반환
        List<Board> articles = articlesData.map((articleData) {
          return Board.fromJson(articleData);
        }).toList();

        return articles;
      } else {
        print('API request failed: ${response.statusCode}');
        return []; // Empty list on failure
      }
    } catch (error) {
      print('Error fetching search results: $error');
      return []; // Empty list on error
    }
  }

/*상품판매글 모두 조회*/
  static Future<List<MarketBoard>> getMarketArticles() async {
    var _url = 'http://3.34.2.246:8080/api/v2/market-articles';

    // 토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    // accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.get(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes))['data'];
      return body.map((dynamic item) => MarketBoard.fromJson(item)).toList();
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {
        throw Exception('요청 오류');
      }
    }
  }

  /*장터 게시판 게시글 상세 조회*/
  static Future<MarketBoard> getMarketArticle(int articleId) async {
    final _url = 'http://3.34.2.246:8080/api/v2/market-articles/${articleId}';

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    final response = await http.get(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      dynamic body = json.decode(
          utf8.decode(response.bodyBytes))['data'];
      return MarketBoard.fromJson(body);


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

  /*상품 판매글 검색*/
  static Future<List<MarketBoard>> marketSearch(String keyword) async {
    try {
      var jwtToken = await storage.read(key: 'token');
      jwtToken = json.decode(jwtToken!)['data']['accessToken'];

      final response = await http.get(
        Uri.parse(
            'http://3.34.2.246:8080/api/v2/market-articles?search-keyword=$keyword'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> articlesData = data['data'];

        // 데이터를 List<MarketBoard> 객체로 반환
        List<MarketBoard> articles = articlesData.map((articleData) {
          return MarketBoard.fromJson(articleData);
        }).toList();

        return articles;
      } else {
        print(json.decode(utf8.decode(response.bodyBytes)));
        if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
            'AT-C-002') {
          print('액세스 토큰 만료');
          throw 'AT-C-002';
        } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
            'AT-C-007') {
          print('로그아웃된 토큰');
          throw 'AT-C-007';
        } else {
          throw Exception('요청 오류');
        }
      }
    } catch (error) {
      print('Error fetching market search results: $error');
      return []; // Empty list on error
    }
  }

  /*상품 판매글 생성*/
  static Future<bool> createMarketArticle(MarketBoard marketArticle) async {
    try {
      var jwtToken = await storage.read(key: 'token');
      final accessToken = json.decode(jwtToken!)['data']['accessToken'];

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://3.34.2.246:8080/api/v2/market-articles'),
      );

      // 텍스트 필드 추가
      request.fields['title'] = marketArticle.title!;
      request.fields['content'] = marketArticle.content!;
      request.fields['price'] = marketArticle.price.toString();
      request.fields['productStatus'] = marketArticle.productStatus!;

      // 이미지 파일 필드 추가
      if (marketArticle.imageUrls != null &&
          marketArticle.imageUrls!.isNotEmpty) {
        for (String imagePath in marketArticle.imageUrls!) {
          if (imagePath.isNotEmpty) {
            var file = await http.MultipartFile.fromPath(
                'imageUrls', imagePath);
            request.files.add(file);
          }
        }
      }

      // Authorization 헤더 설정
      request.headers['Authorization'] = 'Bearer $accessToken';

      // request 전송
      var response = await request.send();

      // 성공
      if (response.statusCode == 201) {
        print('상품 판매글 생성');
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        final errorCode = json.decode(responseBody)['code'];

        if (errorCode == 'AT-C-002') {
          print('액세스 토큰 만료');
          throw 'AT-C-002';
        } else if (errorCode == 'AT-C-007') {
          print('로그아웃된 토큰');
          throw 'AT-C-007';
        } else {
          print('API request failed: ${response.statusCode}');
          print('오류 메시지: ${json.decode(responseBody)['message']}');
          throw Exception('상품 판매글 생성 오류');
        }
      }
    } catch (error) {
      print('Error creating market article: $error');
      throw Exception('상품 판매글 생성 오류');
    }
  }

  /*특정 판매글 수정*/
  static Future<String> updateMarketArticle(int articleId,
      Map<String, dynamic> updateData) async {
    try {
      var jwtToken = await storage.read(key: 'token');
      final accessToken = json.decode(jwtToken!)['data']['accessToken'];

      final url = Uri.parse(
          'http://3.34.2.246:8080/api/v2/market-articles/$articleId');

      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final message = responseBody['message'];
        return message;
      } else {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final errorCode = responseBody['code'];

        if (errorCode == 'AT-C-002') {
          throw '액세스 토큰 만료';
        } else if (errorCode == 'AT-C-007') {
          throw '로그아웃된 토큰';
        } else {
          throw Exception('상품 판매글 수정 오류');
        }
      }
    } catch (error) {
      print('Error updating market article: $error');
      throw Exception('상품 판매글 수정 오류');
    }
  }

  /* 특정 판매글 삭제*/
  static Future<String> deleteMarketArticle(int articleId) async {
    try {
      var jwtToken = await storage.read(key: 'token');
      final accessToken = json.decode(jwtToken!)['data']['accessToken'];

      final url = Uri.parse(
          'http://3.34.2.246:8080/api/v2/market-articles/$articleId');

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final message = responseBody['message'];
        return message;
      } else {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final errorCode = responseBody['code'];

        if (errorCode == 'AT-C-002') {
          throw '액세스 토큰 만료';
        } else if (errorCode == 'AT-C-007') {
          throw '로그아웃된 토큰';
        } else {
          throw Exception('상품 판매글 삭제 오류');
        }
      }
    } catch (error) {
      print('Error deleting market article: $error');
      throw Exception('상품 판매글 삭제 오류');
    }
  }


  /* 특정 판매글 찜 등록*/
  static Future<int> marketbookmark(int articleId) async {
    var url = 'http://3.34.2.246:8080/api/v2/market-articles/${articleId}/bookmarks';

    // 토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    // accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    // success
    var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    print(jsonResponse);
    if (response.statusCode == 200) {
      return jsonResponse['data']['marketArticleBookmarkCount'];
    } else {
      var errorCode = jsonResponse['code'];

      if (errorCode == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (errorCode == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {
        print('기타 에러: $errorCode');
        throw '기타 에러: $errorCode'; // 기타 에러 처리
      }
    }
  }



  /*상품 판매글 댓글 전체 조회*/
  static Future<List<MarketComment>> getMarketArticleComments(int marketArticleId) async {
    try {
      var jwtToken = await storage.read(key: 'token');
      final accessToken = json.decode(jwtToken!)['data']['accessToken'];

      final url = Uri.parse(
          'http://3.34.2.246:8080/api/v2/market-articles/$marketArticleId/market-article-comments');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print(json.decode(utf8.decode(response.bodyBytes)));
        List<dynamic> body = json.decode(
            utf8.decode(response.bodyBytes))['data'];
        return body.map((dynamic item) => MarketComment.fromJson(item))
            .toList();
      } else {
        print(json.decode(utf8.decode(response.bodyBytes)));

        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final errorCode = responseBody['code'];

        if (errorCode == 'AT-C-002') {
          throw '액세스 토큰 만료';
        } else if (errorCode == 'AT-C-007') {
          throw '로그아웃된 토큰';
        } else {
          throw Exception('댓글 조회 오류');
        }
      }
    } catch (error) {
      print('Error fetching market article comments: $error');
      throw Exception('댓글 조회 오류');
    }
  }


  /*상품 판매글 부모 댓글 등록*/
  static Future<bool> createMarketArticleComment(String content, int articleId) async {
    var url = 'http://3.34.2.246:8080/api/v2/market-articles/$articleId/market-article-comments';

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'},
        body: jsonEncode({
          "content": content,
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
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

      }
      return false;
    }
  }


  /*특정 판매글 댓글 삭제*/
  static Future<bool> deleteMarketArticleComment(int articleCommentId) async {
    try {
      var jwtToken = await storage.read(key: 'token');
      final accessToken = json.decode(jwtToken!)['data']['accessToken'];

      final url = Uri.parse(
          'http://3.34.2.246:8080/api/v2/market-article-comments/$articleCommentId');

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final message = responseBody['message'];
        return true;
      } else {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final errorCode = responseBody['code'];

        if (errorCode == 'AT-C-002') {
          throw '액세스 토큰 만료';
        } else if (errorCode == 'AT-C-007') {
          throw '로그아웃된 토큰';
        } else {
          throw Exception('댓글 삭제 오류');
        }
      }
    } catch (error) {
      print('Error deleting market article comment: $error');
      throw Exception('댓글 삭제 오류');
    }
  }


  /*특정 상품 판매글 댓글에 대댓글 등록*/
  static Future<bool> addMarketArticleCommentReply(String content, int commentId, int articleId) async {
    try {
      var jwtToken = await storage.read(key: 'token');
      final accessToken = json.decode(jwtToken!)['data']['accessToken'];

      final url = Uri.parse(
          'http://3.34.2.246:8080/api/v2/market-articles/$articleId/market-article-comments/$commentId');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 200) {
        print(json.decode(utf8.decode(response.bodyBytes)));
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final message = responseBody['message'];
        return true;
      } else {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final errorCode = responseBody['code'];

        if (errorCode == 'AT-C-002') {
          throw '액세스 토큰 만료';
        } else if (errorCode == 'AT-C-007') {
          throw '로그아웃된 토큰';
        } else {
          throw Exception('대댓글 생성 오류');
        }
      }
    } catch (error) {
      print('Error adding market article comment reply: $error');
      throw Exception('대댓글 생성 오류');
    }
  }

/*공지사항 전체조회*/
  static Future<List<dynamic>> BoardNotice() async {
    final _url = 'http://3.34.2.246:8080/api/v2/notices';

    try {
      // 토큰 읽어오기
      var jwtToken = await storage.read(key: 'token');
      jwtToken = json.decode(jwtToken!)['data']['accessToken'];

      final response = await http.get(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print(json.decode(utf8.decode(response.bodyBytes)));
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        final data = responseData['data'];
        if (data != null && data is List) {
          return data;
        }
      }

      print('API request failed: ${response.statusCode}');
      return [];
    } catch (error) {
      print('Error fetching notices: $error');
      return [];
    }
  }

  /*

  좋아요 리스트

  */
  static Future<List<Board>> getLikedPost() async {
    var _url = 'https://aaa1f771-6012-440a-9939-4328d9519a52.mock.pstmn.io/api/v2/community-articles/likes'; //mocksever

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
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes))['data'];
      return body.map((dynamic item) => Board.fromJson(item)).toList();

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

      }
      throw Exception('요청 오류');
    }
  }


  /*

  나의 게시글 조회

   */

  static Future<List<Board>> getMyArticles() async {
    var _url = 'http://3.34.2.246:8080/api/v2/articles'; //mocksever

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
      List<dynamic> body = json.decode(
          utf8.decode(response.bodyBytes))['data'];
      List<dynamic> value = body.map((dynamic item) => Board.fromJson(item)).toList();
      return List.from(value.reversed);


      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

      }
      throw Exception('요청 오류');
    }
  }

  /*

  내가 댓글 단 게시글 조회

   */

  static Future<List<Board>> getCommentArticles() async {
    //TODO url 수정
    var _url = 'http://3.34.2.246:8080/api/v2/articles'; //mocksever

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
      List<dynamic> body = json.decode(
          utf8.decode(response.bodyBytes))['data'];
      List<dynamic> value = body.map((dynamic item) => Board.fromJson(item)).toList();
      return List.from(value.reversed);


      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

      }
      throw Exception('요청 오류');
    }
  }

  /*

  특정 게시판 게시물 조회

  */
  static Future<List<Board>> getArticles(String boardCategory) async {
    var _url = 'http://3.34.2.246:8080/api/v2/community-articles?category=${boardCategory}'; //mocksever

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
      List<dynamic> body = json.decode(
          utf8.decode(response.bodyBytes))['data'];
      return body.map((dynamic item) => Board.fromJson(item)).toList();

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

      }
      throw Exception('요청 오류');
    }
  }

  /*

  게시물 생성

  */
  static Future<bool> postArticles(Board board) async {
    const url = 'http://3.34.2.246:8080/api/v2/community-articles';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // FormData 텍스트 필드 추가
    request.fields['title'] = board.title!;
    request.fields['content'] = board.content!;
    request.fields['category'] = board.category!;


    // FormData 파일 필드 추가
    if (board.imageUrls != null && board.imageUrls!.isNotEmpty) {
      for (String imagePath in board.imageUrls!) {
        if (imagePath.isNotEmpty) {
          var file = await http.MultipartFile.fromPath('imageUrls', imagePath);
          request.files.add(file);
        }
      }
    }
    // 토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    // 액세스 토큰만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];
    request.headers['Authorization'] = 'Bearer $jwtToken';

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

  게시물 삭제

   */
  static Future<bool> deleteArticles(int articleId) async {
    var _url = 'https://aaa1f771-6012-440a-9939-4328d9519a52.mock.pstmn.io/api/v2/community-articles/${articleId}'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');
    //accessToken
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];


    var response = await http.delete(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
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

  특정 게시물 댓글 조회

  */
  static Future<List<Comment>> getCommentsList(int articleId) async {
    var _url = 'http://3.34.2.246:8080/api/v2/community-articles/${articleId}/comments'; //mocksever

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
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes))['data'];
      return body.map((dynamic item) => Comment.fromJson(item)).toList();

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

      }
      throw Exception('요청 오류');
    }
  }

  /*

  댓글 생성

  */
  static Future<bool> postComment(String content, int articleId) async {
    var url = 'http://3.34.2.246:8080/api/v2/community-articles/${articleId}/comments';

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'},
        body: jsonEncode({
          "content": content,
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
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

      }
      return false;
    }
  }

  /*

  대댓글 생성

  */
  static Future<bool> postNestedComment(String content, int commentId) async {
    var url = 'http://3.34.2.246:8080/api/v2/community-article-comments/${commentId}/comments';

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'},
        body: jsonEncode({
          "content": content,
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
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

      }
      return false;
    }
  }


  /*

  댓글 삭제

   */
  static Future<bool> deleteComment(int articleId) async {

    var _url = 'http://3.34.2.246:8080/api/v2/community-article-comments/${articleId}'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');
    //accessToken
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];


    var response = await http.delete(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
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

  좋아요 생성

  */
  static Future<int> addLike(int articleId) async {
    var url = 'http://3.34.2.246:8080/api/v2/community-articles/${articleId}/likes';

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json'},
    );

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return json.decode(utf8.decode(response.bodyBytes))['data']['likeCount'];
      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {

      }
      return -1;
    }
  }


  /*

  좋아요 삭제

   */
  static Future<bool> cancleLike(int articleId) async {
    var _url = 'https://aaa1f771-6012-440a-9939-4328d9519a52.mock.pstmn.io/api/v2/community-articles/${articleId}/likes'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');
    //accessToken
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];


    var response = await http.delete(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
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



}



