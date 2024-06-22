import 'dart:convert';
import 'package:aliens/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'package:aliens/models/partner_model.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/models/member_details_model.dart';
import 'package:aliens/models/applicant_model.dart';
import 'package:aliens/services/user_service.dart';
import 'package:flutter/material.dart';

class MatchingService extends APIService {
  /*
  
    매칭 정보 요청 > 매칭 신청 내역 조회

  */
  //매칭 정보 요청
  static Future<Map<String, dynamic>> getApplicantInfo() async {
    const url = 'http://3.34.2.246:8080/api/v1/applicant'; //mocksever

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
      print(json.decode(utf8.decode(response.bodyBytes)));
      return json.decode(utf8.decode(response.bodyBytes))['data'];
      //fail
    } else {
      //오류 생기면 바디 확인
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
  
    상대 정보 요청 > 나의 매칭 파트너 조회

  */
  static Future<List<Partner>> getApplicantPartners() async {
    const url = 'http://3.34.2.246:8080/api/v1/applicant/partners';

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

    // success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      List<dynamic> body =
          json.decode(utf8.decode(response.bodyBytes))['data']['partners'];
      return body.map((dynamic item) => Partner.fromJson(item)).toList();
    } else {
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        // 엑세스 토큰 만료
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        // 로그아웃된 토큰
        throw 'AT-C-007';
      } else {
        // 예외
      }

      //임의로 넣어두겠습니다
      List<Partner> partners = [
        Partner(
          memberId: 0,
          name: "",
          mbti: "",
          gender: "",
          nationality: "",
          profileImage: "",
          selfIntroduction: "",
        ),
        Partner(
          memberId: 0,
          name: "",
          mbti: "",
          gender: "",
          nationality: "",
          profileImage: "",
          selfIntroduction: "",
        ),
        Partner(
          memberId: 0,
          name: "",
          mbti: "",
          gender: "",
          nationality: "",
          profileImage: "",
          selfIntroduction: "",
        ),
        Partner(
          memberId: 0,
          name: "",
          mbti: "",
          gender: "",
          nationality: "",
          profileImage: "",
          selfIntroduction: "",
        )
      ];
      return partners;
    }
  }

  /*
    
    getMatchingData(매칭 데이터)

  */
  static Future<ScreenArguments> getMatchingData(context) async {
    late ScreenArguments screenArguments;

    late MemberDetails memberDetails;
    late String status;
    late Applicant? applicant;
    late List<Partner>? partners;

    try {
      status = await UserService.getApplicantStatus();
    } catch (e) {
      if (e == "AT-C-002") {
        try {
          await AuthService.getAccessToken();
        } catch (e) {
          if (e == "AT-C-005") {
            //토큰 및 정보 삭제
            await APIService.storage.delete(key: 'auth');
            await APIService.storage.delete(key: 'token');
            print('로그아웃, 정보 지움');

            //스택 비우고 화면 이동
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          } else {
            status = await UserService.getApplicantStatus();
          }
        }
      } else if (e == "AT-C-007") {
        //토큰 및 정보 삭제
        await AuthService.logOut(context);
      }
    }

    memberDetails =
        MemberDetails.fromJson(await UserService.getMemberDetails());

    applicant =
        status == 'AppliedAndNotMatched' || status == 'AppliedAndMatched'
            ? Applicant.fromJson(await getApplicantInfo())
            : null;
    partners = status == 'NotAppliedAndMatched' || status == 'AppliedAndMatched'
        ? await getApplicantPartners()
        : null;

    screenArguments =
        ScreenArguments(memberDetails, status, applicant, partners);

    //return mockScreenArgument_2;
    return screenArguments;
  }

  /* 

    매칭 취소 (신설) => 버튼을 어디에 어떻게 만들어야할지 몰라서 현재 ui구현안됨
  
  */
  static Future<bool> cancelMatchingApplication() async {
    var url = '$domainUrl/matchings/applications';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (responseBody['code'] == 'MA003') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /*


  매칭 신청

   */
  static Future<bool> applicantMatching(
      String firstPreferLanguage, String secondPreferLanguage) async {
    var url = 'http://3.34.2.246:8080/api/v1/applicant'; //mocksever

    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'
        },
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
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {}
      return false;
    }
  }

  /*

  회원 정보 삭제
  http://13.125.205.5ㅐ9:8080/api/v1/member/906
  
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

  선호 언어 수정 > 매칭 신청 정보 수정

   */
  static Future<bool> updatePreferLanguage(
      String firstPreferLanguage, String secondPreferLanguage) async {
    var url = '$domainUrl/matchings/applications';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

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
      return true;
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (responseBody['code'] == 'AT-C-002') {
        // 액세스 토큰 만료
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        // 로그아웃된 토큰
        throw 'AT-C-007';
      } else if (responseBody['code'] == 'MT-C-005') {
        // 정보 없음
        return false;
      } else {
        throw Exception('요청 오류');
      }
    }
  }

  /*

  매칭 완료 일시

  */
  static Future<String> matchingProfessData() async {
    var url =
        Uri.parse('http://3.34.2.246:8080/api/v1/applicant/completion-date');

    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');
    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return json.decode(utf8.decode(response.bodyBytes))['data']
          ['matchingCompleteDate'];
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
}
