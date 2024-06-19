import 'package:aliens/models/market_articles.dart';
import 'package:aliens/models/signup_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/applicant_model.dart';
import '../models/auth_model.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import '../models/board_model.dart';
import '../models/comment_model.dart';
import '../models/market_comment.dart';
import '../models/member_details_model.dart';
import '../models/message_model.dart';
import '../models/notification_article_model.dart';
import '../models/partner_model.dart';
import '../models/screen_argument.dart';
import '../util/image_util.dart';

// API 호출과 관련된 로직을 포함한 서비스 클래스 파일

const String domainUrl = 'https://friendship-aliens.com';

class APIs {
  static String? token; // 엑세스 토큰을 저장할 정적 변수
  static String? refreshToken; // 리프레시 토큰을 저장할 정적 변수

  static const storage =
      FlutterSecureStorage(); // flutter_secure_storage 인스턴스 생성

  /*

  이메일 중복 확인

   */
  static Future<bool> checkExistence(String email) async {
    var url = '$domainUrl/members/exist?email=$email';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      print("응답: $responseData");

      if (responseData != null && responseData['result'] != null) {
        var result = responseData['result'];
        if (result.contains("사용 가능한 이메일입니다")) {
          return false; // 사용 가능한 이메일인 경우 false 반환
        } else {
          return true; // 사용 불가능한 이메일인 경우 true 반환
        }
      } else {
        print("응답에 'result' 필드가 없음");
        return false;
      }
    } else {
      print("실패: ${response.body}");
      return false;
    }
  }

  /*

  이메일 인증 요청

   */
  static Future<bool> verifyEmail(String email) async {
    var url = '$domainUrl/emails/verification/send';

    var response = await http.post(Uri.parse('$url?email=$email'));
    //success
    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      print("응답: $responseData");
      return true;
      //fail
    } else {
      print("실패: ${response.body}");
      return false;
    }
  }

  /*

  이메일 인증 상태 요청

   */
  static Future<String> getAuthenticationStatus(String email) async {
    var url = '$domainUrl/emails?email=$email';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      print("응답: $responseData");

      var code = responseData['code'];
      var result = responseData['result'];

      if (code == 'E003') {
        return result;
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      print("실패: ${response.body}");
      throw Exception('Failed to get authentication status');
    }
  }

  /*

  회원가입

   */
  static Future<bool> signUp(SignUpModel member) async {
    const url = '$domainUrl/members';

    Map<String, dynamic> data = {
      'email': member.email,
      'password': member.password,
      'name': member.name,
      'mbti': member.mbti,
      'gender': member.gender,
      'nationality': member.nationality,
      'birthday': member.birthday,
      'aboutMe': member.aboutMe ?? '',
    };

    String jsonBody = jsonEncode(data);

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    var responseBody = utf8.decode(response.bodyBytes);
    print("Request Body: $jsonBody");
    print("응답 본문: $responseBody");

    var jsonResponse = json.decode(responseBody);
    var code = jsonResponse['code'];

    print('Code: $code');

    if (response.statusCode == 200) {
      print('성공응답이 도착했습니다.');
      return true;
    } else {
      print('실패 응답이 도착했습니다.');
      return false;
    }
  }

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

      print('요청이 전송되었습니다.');

      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        token = responseBody['result']['accessToken'];
        refreshToken = responseBody['result']['refreshToken'];

        // 로그인 성공 시 토큰 저장
        await storage.write(key: 'token', value: token!);
        await storage.write(key: 'refreshToken', value: refreshToken!);

        return true;
      } else {
        print('로그인 실패: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('오류 발생: $e');
      return false;
    }
  }

  /*

  로그아웃

   */

  static Future<void> logOut(BuildContext context) async {
    const url = '$domainUrl/authentication/logout';

    // 토큰 읽어오기
    var jwtToken = await storage.read(key: 'token') ?? ''; //엑세스토큰은 정적변수 사용안함
    refreshToken = await storage.read(key: 'refreshToken') ?? '';

    // Firebase Cloud Messaging 토큰 읽어오기
    final fcmToken =
        await FirebaseMessaging.instance.getToken(); //api에는 없으나 기존 코드라 일단 둠

    var body = jsonEncode({
      'accessToken': jwtToken,
      'refreshToken': refreshToken,
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
      print(json.decode(utf8.decode(response.bodyBytes)));

      // 토큰 및 정보 삭제
      await storage.delete(key: 'auth');
      await storage.delete(key: 'jwtToken');
      await storage.delete(key: 'refreshToken');
      await storage.delete(key: 'notifications');
      print('로그아웃, 정보 지움');

      // 스택 비우고 화면 이동
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } else {
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        await getAccessToken();
        await logOut(context);
      }
      print(json.decode(utf8.decode(response.bodyBytes)));
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
      print(json.decode(utf8.decode(response.bodyBytes)));
      return "M003"; // 성공 코드
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return "Error: ${response.statusCode}";
    }
  }

  /*

  비밀번호 변경

   */
  static Future<bool> changePassword(String newPassword) async {
    var url = '$domainUrl/members/password';

    var jwtToken = await storage.read(key: 'token') ?? '';

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
      print('비밀번호 변경 성공: ${responseBody['code']}');
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (responseBody['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {
        print('예외');
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
    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
      },
    );

    // 성공
    if (response.statusCode == 200) {
      print('탈퇴 성공');
      return true;
    }
    // 실패
    else {
      print('탈퇴 실패');
      return false;
    }
  }

  //개인 정보 조회
  static Future<Map<String, dynamic>> getMemberDetails() async {
    var url = '$domainUrl/members';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': jwtToken, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('정보조회 성공: ${responseBody['code']}');
      return responseBody['result'];
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {
        print('예외');
      }
      throw Exception('요청 오류');
    }
  }

  //회원 매칭상태 조회
  static Future<String> getApplicantStatus() async {
    var url = '$domainUrl/members/status';

    var jwtToken = await storage.read(key: 'token');

    if (jwtToken != null) {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': jwtToken,
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        var matchingStatus = responseBody['result'];

        return matchingStatus; // 매칭상태 반환
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
          print('정보 없음');
          return "NotAppliedAndNotMatched";
        }
        throw Exception('요청 오류');
      }
    } else {
      // jwtToken이 null인 경우
      print('토큰이 없습니다.');
      throw 'TokenNotFound';
    }
  }

  //매칭 정보 요청 > 매칭 신청 내역 조회
  static Future<Map<String, dynamic>> getApplicantInfo() async {
    try {
      const url = '$domainUrl/matchings/applications';

      var jwtToken = await storage.read(key: 'token') ?? '';

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': jwtToken,
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(utf8.decode(response.bodyBytes));
        print('매칭 신청 내역 조회 성공: ${responseData['code']}');
        var result = responseData['result'];

        // 필드별 출력
        print('매칭 회차: ${result['matchingRound']}');
        print('회원 ID: ${result['memberId']}');
        print('첫 번째 선호 언어: ${result['firstPreferLanguage']}');
        print('두 번째 선호 언어: ${result['secondPreferLanguage']}');

        return result;
      } else {
        // 실패 시 오류 처리
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
      print('Error fetching applicant info: $error');
      rethrow;
    }
  }

  // 상대 정보 요청 > 나의 매칭 파트너 조회
  static Future<List<Partner>> getApplicantPartners() async {
    const url = '$domainUrl/matchings/partners';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': jwtToken, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> matchingPartner = responseBody['result'];
      return matchingPartner
          .map((dynamic item) => Partner.fromJson(item))
          .toList();
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {
        print('예외');
      }
      return [];
    }
  }

//토큰 재발급
  static Future<bool> getAccessToken() async {
    print("Access 토큰 재발급 요청");
    const url = '$domainUrl/authentication/reissue';

    // 토큰 읽어오기
    var accessToken = await storage.read(key: 'token');
    var refreshToken = await storage.read(key: 'refreshToken');

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
      print('토큰 재발급 성공');
      // 발급받은 새로운 access token 저장
      var responseData = json.decode(utf8.decode(response.bodyBytes));

      String newAccessToken = responseData["result"]["accessToken"];
      String newRefreshToken = responseData["result"]["refreshToken"];
      String code = responseData['code'];

      await storage.write(key: 'token', value: newAccessToken);
      await storage.write(key: 'refreshToken', value: newRefreshToken);

      print('새로운 Access Token: $newAccessToken');
      print('새로운 Refresh Token: $newRefreshToken');
      print('Response Code: $code');

      return true;
    } else {
      print('토큰 재발급 실패');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return false;
    }
  }

//getMatchingData

  static Future<ScreenArguments> getMatchingData(context) async {
    late ScreenArguments screenArguments;

    late MemberDetails memberDetails;
    late String status;
    late Applicant? applicant;
    late List<Partner>? partners;

    try {
      status = await APIs.getApplicantStatus();
      print('신청자 상태: $status');

      memberDetails = MemberDetails.fromJson(await APIs.getMemberDetails());
      print('회원 정보: $memberDetails');

      if (status == 'AppliedAndNotMatched' || status == 'AppliedAndMatched') {
        applicant = Applicant.fromJson(await APIs.getApplicantInfo());
      } else {
        applicant = null;
      }

      if (status == 'NotAppliedAndMatched' || status == 'AppliedAndMatched') {
        partners = await APIs.getApplicantPartners();
      } else {
        partners = null;
      }

      screenArguments =
          ScreenArguments(memberDetails, status, applicant, partners);
      print('ScreenArguments: $screenArguments');
    } catch (e) {
      print('데이터를 가져오는 중 오류: $e');
    }

    return screenArguments;
  }

//매칭 취소 (신설) => 버튼을 어디에 어떻게 만들어야할지 몰라서 현재 ui구현안됨
  static Future<bool> cancelMatchingApplication() async {
    var url = '$domainUrl/matchings/applications';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print(responseBody);
      if (responseBody['code'] == 'MA003') {
        print('매칭 신청 취소 성공');
        return true;
      } else {
        return false;
      }
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print(responseBody);
      return false;
    }
  }

  /*

  mbti 변경

   */
  static Future<bool> updateMBTI(String newMBTI) async {
    var url = '$domainUrl/members/mbti';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var requestBody = jsonEncode({
      'newMBTI': newMBTI,
    });

    var response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return false;
    }
  }

/*

프로필 수정 //테스트 실패

 */

  static Future<bool> updateProfile(File profileImageFile) async {
    var url = '$domainUrl/member/profile-image';

    var jwtToken = await storage.read(key: 'token') ?? '';

    // MultipartFile로 변환
    var profileImage = await ImageUtil.compressImageToMultipartFile(
      'profileImage',
      profileImageFile.path,
    );

    // FormData 생성
    var formData = http.MultipartRequest('PUT', Uri.parse(url));
    formData.headers['Authorization'] = 'Bearer $jwtToken';
    formData.files.add(profileImage);

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
  자기소개 변경
  */
  static Future<bool> updateSelfIntroduction(String newAboutMe) async {
    var url = '$domainUrl/members/about-me';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var requestBody = jsonEncode({
      'newAboutMe': newAboutMe,
    });

    var response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: requestBody,
    );

    var responseBody = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      print('자기소개 변경 성공: ${responseBody['code']}');
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return false;
    }
  }

  /*

  선호 언어 수정 > 매칭 신청 정보 수정

   */
  static Future<bool> updatePreferLanguage(
      String firstPreferLanguage, String secondPreferLanguage) async {
    var url = '$domainUrl/matchings/applications';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode({
        "firstPreferLanguage": firstPreferLanguage,
        "secondPreferLanguage": secondPreferLanguage,
      }),
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('정보 수정 성공: ${responseBody['code']}');
      return true;
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (responseBody['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else if (responseBody['code'] == 'MT-C-005') {
        print('정보 없음');
        return false;
      } else {
        throw Exception('요청 오류');
      }
    }
  }

  /*


  매칭 신청

   */
  static Future<bool> applicantMatching(
      String firstPreferLanguage, String secondPreferLanguage) async {
    var url = '$domainUrl/matchings/applications';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': jwtToken,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "firstPreferLanguage": firstPreferLanguage,
          "secondPreferLanguage": secondPreferLanguage,
        }));

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      var matchingResult = responseBody['result'];
      print('매칭 신청 결과: $matchingResult');
      return true;
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

  회원 정보 삭제 => 회원탈퇴랑 같은거 같으나 기존 코드라 둠

   */
  static Future<void> deleteInfo(memberId) async {
    var url = 'http://3.34.2.246:8080/api/v1/member/$memberId';

    var response = await http.delete(
      Uri.parse(url),
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
    var url = 'http://3.34.2.246:8081/api/v1/chat/$roomId'; //mocksever

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
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          }
        }
        chatToken = await APIs.getChatToken();
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
    var url = 'http://3.34.2.246:8080/api/v1/chat/token';
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
      return json.decode(utf8.decode(response.bodyBytes))['data'];

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

      throw Exception('요청 오류');
    }
  }

  // 채팅 정보 받아오기
  static Future<Map<String, dynamic>> getChatSummary(context) async {
    var url = 'http://3.34.2.246:8081/api/v1/chat/summary';
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
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          }
        }
        chatToken = await APIs.getChatToken();
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
      print(json.decode(utf8.decode(response.bodyBytes)));

      return json.decode(utf8.decode(response.bodyBytes));

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
      throw Exception('요청 오류');
    }
  }

  /*

  매칭 완료 일시 > 매칭 시작 시간 조회

  */
  static Future<String> matchingProfessData() async {
    var url = Uri.parse('$domainUrl/matchings/applications/begin-time');

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.get(
      url,
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('Code: ${responseBody['code']}');
      print('Result: ${responseBody['result']}');
      return responseBody['result']['matchingBeginTime'];
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print(responseBody);
      if (responseBody['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {
        throw Exception('요청 오류');
      }
    }
  }

  /*

  채팅 알림 설정 조회

   */
  static Future<void> getChatNotificationStatus() async {
    const url = 'http://3.34.2.246:8080/api/v1/notification/chat'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');
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
      print(json.decode(utf8.decode(response.bodyBytes)));

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
    }
  }

  /*

  채팅 알림 설정

   */
  static Future<bool> setChatNotification(bool notification, bool all) async {
    const url = 'http://3.34.2.246:8080/api/v1/notification/chat'; //mocksever

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
          "chatNotification": notification.toString(),
        }));

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      //알림값 읽어오기
      var notification = await storage.read(key: 'notifications');

      var allNotification = json.decode(notification!)['allNotification'];
      var matchingNotification =
          json.decode(notification)['matchingNotification'];
      var chatNotification = json.decode(notification)['chatNotification'];

      await getChatNotificationStatus();
      await storage.delete(key: 'notifications');
      if (all) {
      } else {}

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

  채팅 상대 신고 //테스트 실패

   */

  static Future<bool> reportPartner(
      String reportCategory, String reportContent, int memberId) async {
    var url = 'http://3.34.2.246:8080/api/v1/report/$memberId'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'
        },
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
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {}
      return false;
    }
  }
  /*

  채팅 상대 차단

   */

  static Future<bool> blockPartner(Partner partner) async {
    const url = '$domainUrl/chat/block';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode({
        "partnerId": partner.memberId,
        "chatRoomId": partner.roomId,
      }),
    );

    var responseBody = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('채팅 상대 차단 성공: ${responseBody['code']}');
      return true;
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print(responseBody);

      if (responseBody['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }
      return false;
    }
  }

  /*

  매칭 신청 // 매칭 신청 api작성했으나 기존 코드라서 둠

   */
  static Future<bool> inquiry(String question) async {
    var url = 'http://3.34.2.246:8080/api/v1/member/question'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'
        },
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
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {}
      return false;
    }
  }

  /*
  전체게시판 글 전부 조회
  */
  static Future<List<Board>> TotalArticles(int page) async {
    final url = '$domainUrl/boards?page=$page&size=10';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final code = responseBody['code'];
      final result = responseBody['result'];

      print('Code: $code');
      print('Result: $result');

      List<dynamic> body = result;
      List<Board> boards =
          body.map((dynamic item) => Board.fromJson(item)).toList();

      return boards;
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('요청 오류');
    }
  }

/*전체 게시판 검색*/
  static Future<List<Board>> TotalSearch(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$domainUrl/boards/search?search-keyword=$keyword&page=0&size=10'),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> articlesData = responseBody['result'];
        // 데이터를 List<Board> 객체로 반환
        List<Board> articles = articlesData.map((articleData) {
          return Board.fromJson(articleData);
        }).toList();

        return articles;
      } else {
        print('API request failed: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error fetching search results: $error');
      return [];
    }
  }

/*상품판매글 모두 조회 > 장터 게시판 조회*/
  static Future<List<MarketBoard>> getMarketArticles(int page) async {
    final url = '$domainUrl/boards/market?page=$page&size=10';

    var jwtToken = await storage.read(key: 'token') ?? '';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('Code: ${responseBody['code']}');
      List<dynamic> result = responseBody['result'];
      return result.map((dynamic item) => MarketBoard.fromJson(item)).toList();
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('Error: $responseBody');
      if (responseBody['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {
        throw Exception('요청 오류');
      }
    }
  }

  /*장터 게시글 상세 조회*/
  static Future<MarketBoard> getMarketArticle(int articleId) async {
    final url = '$domainUrl/boards/market/details?id=$articleId';

    var jwtToken = await storage.read(key: 'token') ?? '';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('Code: ${responseBody['code']}');
      dynamic result = responseBody['result'];
      return MarketBoard.fromJson(result);
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('Error: $responseBody');
      if (responseBody['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {
        throw Exception('요청 오류');
      }
    }
  }

  /*상품 판매글 검색 > 장터게시글 검색*/
  static Future<List<MarketBoard>> marketSearch(String keyword) async {
    try {
      var jwtToken = await storage.read(key: 'token') ?? '';

      final response = await http.get(
        Uri.parse(
            '$domainUrl/boards/market/search?search-keyword=$keyword&page=0&size=10'),
        headers: {
          'Authorization': jwtToken,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> articlesData = data['result'];

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
      return [];
    }
  }

  /*상품 판매글 생성*/ //테스트 실패
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
      request.fields['marketArticleStatus'] =
          marketArticle.marketArticleStatus!;

      // 이미지 파일 필드 추가
      if (marketArticle.imageUrls != null &&
          marketArticle.imageUrls!.isNotEmpty) {
        for (String imagePath in marketArticle.imageUrls!) {
          if (imagePath.isNotEmpty) {
            var file = await ImageUtil.compressImageToMultipartFile(
              'imageUrls',
              imagePath,
            );
            request.files.add(file);
          }
        }
      }

      // Authorization 헤더 설정
      request.headers['Authorization'] = 'Bearer $accessToken';

      // request 전송
      var response = await request.send();

      // 성공
      if (response.statusCode == 200) {
        print('상품 판매글 생성');
        print(await response.stream.bytesToString());
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        print(await response.stream.bytesToString());

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

  /*특정 판매글 수정*/ //테스트 실패

  static Future<bool> updateMarketArticle(
      int articleId, MarketBoard marketArticle) async {
    try {
      print('Starting updateMarketArticle with articleId: $articleId');

      var jwtToken = await storage.read(key: 'token');
      final accessToken = json.decode(jwtToken!)['data']['accessToken'];

      final url =
          Uri.parse('http://3.34.2.246:8080/api/v2/market-articles/$articleId');
      print('Update Data: $marketArticle');

      final request = http.MultipartRequest('PATCH', url);
      print("wj");

      // Set headers
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Add text fields
      request.fields['title'] = marketArticle.title!;
      request.fields['content'] = marketArticle.content!;
      request.fields['price'] = marketArticle.price.toString();
      request.fields['productStatus'] = marketArticle.productStatus!;
      request.fields['marketArticleStatus'] =
          marketArticle.marketArticleStatus!;
      print(12);

      // Add image files
      if (marketArticle.imageUrls != null &&
          marketArticle.imageUrls!.isNotEmpty) {
        for (String imageUrl in marketArticle.imageUrls!) {
          if (imageUrl.isNotEmpty) {
            // 이미지 URL을 다운로드하여 로컬에 저장
            final response = await http.get(Uri.parse(imageUrl));
            final bytes = response.bodyBytes;
            const fileName = 'image.jpg'; // 저장할 파일 이름, 원하는 이름으로 설정

            final Directory tempDir = Directory.systemTemp; // 임시 디렉토리 사용
            final File imageFile = File('${tempDir.path}/$fileName');
            await imageFile.writeAsBytes(bytes);

            // 이미지 파일을 로컬 파일로 저장한 후 해당 파일 경로를 사용
            var file =
                await http.MultipartFile.fromPath('imageUrls', imageFile.path);
            request.files.add(file);
          }
        }
      }
      print(50);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Successful Response Body: $responseBody');
        return true;
      } else if (response.statusCode == 500) {
        final responseBody = await response.stream.bytesToString();
        print('500 Error Response Body: $responseBody');
        return false;
      } else {
        final responseBody = await response.stream.bytesToString();
        final errorCode = json.decode(responseBody)['code'];

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

  /* 특정 판매글 삭제*/ //게시물 삭제로 통합된거 같지만 기존 코드라 둠
  static Future<String> deleteMarketArticle(int articleId) async {
    try {
      var jwtToken = await storage.read(key: 'token');
      final accessToken = json.decode(jwtToken!)['data']['accessToken'];

      final url =
          Uri.parse('http://3.34.2.246:8080/api/v2/market-articles/$articleId');

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

  /* 특정 판매글 찜 등록*/ //api가 없어서 둠
  static Future<int> marketbookmark(int articleId, int index) async {
    var url =
        'http://3.34.2.246:8080/api/v2/market-articles/$articleId/bookmarks?page=$index&size=10&sort=createdAt,desc';

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

  /*상품 판매글 댓글 전체 조회*/ //특정 게시글의 모든 댓글 조회api로 통합된거 같지만 기존 코드라 둠
  static Future<List<MarketComment>> getMarketArticleComments(
      int marketArticleId) async {
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
        List<dynamic> body =
            json.decode(utf8.decode(response.bodyBytes))['data'];
        return body
            .map((dynamic item) => MarketComment.fromJson(item))
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

  /*상품 판매글 부모 댓글 등록*/ //부모 댓글 등록 api로 통합된거 같지만 기존 코드라 둠
  static Future<bool> createMarketArticleComment(
      String content, int articleId) async {
    var url =
        'http://3.34.2.246:8080/api/v2/market-articles/$articleId/market-article-comments';

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'
        },
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
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {}
      return false;
    }
  }

  /*특정 판매글 댓글 삭제*/ //댓글 삭제 api로 통합된거 같지만 기존 코드라 둠
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

  /*특정 상품 판매글 댓글에 대댓글 등록*/ //자식 댓글 등록 api로 통합된거 같지만 기존 코드라 둠(자식댓글 테스트 실패)
  static Future<bool> addMarketArticleCommentReply(
      String content, int commentId, int articleId) async {
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

/*공지사항 전체조회*/ //테스트 실패
  static Future<List<dynamic>> BoardNotice() async {
    const url = 'http://3.34.2.246:8080/api/v2/notices';

    try {
      // 토큰 읽어오기
      var jwtToken = await storage.read(key: 'token');
      jwtToken = json.decode(jwtToken!)['data']['accessToken'];

      final response = await http.get(
        Uri.parse(url),
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

  좋아요 리스트 > 본인이 좋아요한 게시글 조회

  */
  static Future<List<Board>> getLikedPost(int page) async {
    const url = '$domainUrl/great/my-board?page=0&size=10';

    var jwtToken = await storage.read(key: 'token') ?? '';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': jwtToken, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final code = responseBody['code'];
      final result = responseBody['result'];

      print('Code: $code');
      print('Result: $result');

      List<dynamic> body = result;
      List<Board> boards =
          body.map((dynamic item) => Board.fromJson(item)).toList();
      return boards;
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('요청 오류');
    }
  }

  /*

  나의 게시글 조회

   */

  static Future<List<Board>> getMyArticles(int page) async {
    const url = '$domainUrl/boards/writes?page=0&size=10';

    var jwtToken = await storage.read(key: 'token') ?? '';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': jwtToken, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final code = responseBody['code'];
      final result = responseBody['result'];

      print('Code: $code'); //
      print('Result: $result');

      List<dynamic> body = result;
      List<Board> boards =
          body.map((dynamic item) => Board.fromJson(item)).toList();
      return boards;
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('요청 오류');
    }
  }

  /*

  내가 댓글 단 게시글 조회

   */

  static Future<List<Board>> getCommentArticles(int page) async {
    var url = '$domainUrl/my-boards?page=$page&size=10';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('Code: ${responseBody['code']}');
      List<dynamic> result = responseBody['result'];
      return result.map((dynamic item) => Board.fromJson(item)).toList();
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
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
  }

  /*

  특정 게시판 게시물 조회

  */
  static Future<List<Board>> getArticles(String boardCategory, int page) async {
    var url =
        '$domainUrl/boards/category?category=$boardCategory&page=$page&size=10';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final code = responseBody['code'];
        final result = responseBody['result'];

        print('Code: $code');
        print('Result: $result');

        List<dynamic> body = result;
        List<Board> boards =
            body.map((dynamic item) => Board.fromJson(item)).toList();
        return boards;
      } else {
        print('API request failed: ${response.statusCode}');
        print('Response body: ${response.body}');
        return [];
      }
    } catch (error) {
      print('Error fetching articles: $error');
      return [];
    }
  }

  /*

  게시물 등록 //테스트 실패

  */
  static Future<bool> postArticles(Board newBoard) async {
    const url = '$domainUrl/boards/normal';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = jwtToken;

    // 이미지 파일 추가
    if (newBoard.imageUrls != null && newBoard.imageUrls!.isNotEmpty) {
      for (String imagePath in newBoard.imageUrls!) {
        if (imagePath.isNotEmpty) {
          var file = await ImageUtil.compressImageToMultipartFile(
            'boardImages',
            imagePath,
          );
          request.files.add(file);
        }
      }
    }

    // 게시글 정보 추가
    var jsonContent = jsonEncode({
      'title': newBoard.title!,
      'content': newBoard.content!,
      'boardCategory': newBoard.category!,
    });

    request.files.add(http.MultipartFile.fromString(
      'request',
      jsonContent,
      contentType: MediaType('application', 'json'),
    ));

    // 요청 데이터 출력 테스트
    print('Request URL: ${request.url}');
    print('Request Headers: ${request.headers}');
    print('Request Fields: ${request.fields}');
    print('Request Files: ${request.files}');

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /*

  게시물 삭제

   */
  static Future<bool> deleteArticles(int articleId) async {
    var url = '$domainUrl/boards?id=$articleId';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );

    var responseData = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      print('게시글 ID $articleId 삭제 성공: ${responseData['code']}');
      return true;
    } else {
      print('게시글 ID $articleId 삭제 실패');
      print(json.decode(utf8.decode(response.bodyBytes)));
      return false;
    }
  }

  /*

  특정 게시물 댓글 조회

  */
  static Future<List<Comment>> getCommentsList(int articleId) async {
    var url = '$domainUrl/comments/boards?id=$articleId';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('성공 code: ${responseBody['code']}');
      List<dynamic> body = responseBody['result'];
      return body.map((dynamic item) => Comment.fromJson(item)).toList();
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('Error: $responseBody');
      if (responseBody['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {
        throw Exception('요청 오류');
      }
    }
  }

  /*

  부모 댓글 등록

  */

  static Future<bool> postComment(String content, int articleId) async {
    var url = '$domainUrl/comments/parent';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8'
      },
      body: jsonEncode({
        "boardId": articleId,
        "content": content,
      }),
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('Code: ${responseBody['code']}');
      return true;
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('Error: $responseBody');
      if (responseBody['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {
        return false;
      }
    }
  }

  /*

  자식 댓글 생성 //테스트 실패

  */
  static Future<bool> postNestedComment(String content, int commentId) async {
    var url =
        'http://3.34.2.246:8080/api/v2/community-article-comments/$commentId/comments';

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'
        },
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
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {}
      return false;
    }
  }

  /*

  댓글 삭제

   */
  static Future<bool> deleteComment(int commentId) async {
    var url = '$domainUrl/comments?id=$commentId';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      print('댓글 ID $commentId 삭제 성공: ${responseData['code']}');
      return true;
    } else {
      print('댓글 ID $commentId 삭제 실패');
      print(json.decode(utf8.decode(response.bodyBytes)));
      return false;
    }
  }

/*

  좋아요 등록

  */
  static Future<int> addLike(int articleId) async {
    var url = '$domainUrl/great?board-id=$articleId';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      print('좋아요 등록 성공: ${responseData['code']}');
      print(responseData);
      return responseData['data']['likeCount'];
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print(responseBody);
      if (responseBody['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }
      return -1;
    }
  }

/*

  알림 리스트 > 알림 조회

  */
  static Future<List<NotificationArticle>> getNotiList() async {
    var url = '$domainUrl/notifications';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8'
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('Code: ${responseBody['code']}');
      List<dynamic> body = responseBody['result'];
      List<NotificationArticle> notifications = body
          .map((dynamic item) => NotificationArticle.fromJson(item))
          .toList();
      return notifications;
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print(responseBody);
      if (responseBody['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
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

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print('Code: ${responseBody['code']}');
      return true;
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print(responseBody);
      return false;
    }
  }

  //게시글 신고
  static Future<bool> reportBoard(int boardId, String reason) async {
    const url = '$domainUrl/boards/report';

    var jwtToken = await storage.read(key: 'token') ?? '';

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode({
        "boardId": boardId,
        "reason": reason,
      }),
    );

    var responseBody = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      print('게시글 신고 성공: ${responseBody['code']}');
      return true;
    } else {
      print(responseBody);

      if (responseBody['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      }
      return false;
    }
  }
}
