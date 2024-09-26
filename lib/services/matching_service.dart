import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'package:aliens/models/partner_model.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/models/member_details_model.dart';
import 'package:aliens/models/applicant_model.dart';
import 'package:aliens/services/user_service.dart';

class MatchingService extends APIService {
  /*
  
    매칭 정보 요청 > 매칭 신청 내역 조회

  */
  static Future<Map<String, dynamic>> getApplicantInfo() async {
    try {
      const url = '$domainUrl/matchings/applications';

      var jwtToken = await APIService.storage.read(key: 'token') ?? '';

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': jwtToken,
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        print("신청 정보 응답 : ${utf8.decode(response.bodyBytes)}");
        var responseData = json.decode(utf8.decode(response.bodyBytes));
        var result = responseData['result'];
        print("신청정보 $result");

        return result;
      } else {
        var responseData = utf8.decode(response.bodyBytes);
        print("신청 정보 오류 : $responseData");
        throw "신청 정보 오류";
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  /* 
  
    상대 정보 요청 > 나의 매칭 파트너 조회

  */
  static Future<List<Partner>> getApplicantPartners() async {
    const url = '$domainUrl/matchings/partners';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> matchingPartner = responseBody['result'];
      print(responseBody);
      return matchingPartner
          .map((dynamic item) => Partner.fromJson(item))
          .toList();
    } else {
      print("상대방 조회 실패 ");
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
      return [];
    }
  }

  /*
    
    getMatchingData(매칭 데이터)

  */
  static Future<ScreenArguments> getMatchingData(context) async {
    MemberDetails memberDetails;
    String? status;
    Applicant? applicant;
    List<Partner>? partners;

    try {
      status = await UserService.getApplicantStatus();
      print("매칭 데이터 $status");

      memberDetails = await UserService.getMemberDetails();
      print("매칭 데이터 ${memberDetails.name}");

      if (status == 'AppliedAndNotMatched') {
        applicant = Applicant.fromJson(await getApplicantInfo());
      } else {
        applicant = null;
      }

      if (status == 'NotAppliedAndMatched' || status == 'AppliedAndMatched') {
        partners = await getApplicantPartners();
      } else {
        partners = null;
      }
    } catch (e) {
      print('error $e');
      // 필요한 경우, 예외 상황에서 기본값을 설정합니다.
      memberDetails = MemberDetails(
        name: 'name',
        mbti: 'mbti',
        gender: 'gender',
        nationality: 'nationality',
        birthday: 'birthday',
        selfIntroduction: 'selfIntroduction',
        profileImageUrl: 'profileImageUrl',
      );
      status = 'unknown';
      applicant = null;
      partners = [];
    }

    ScreenArguments screenArguments =
        ScreenArguments(memberDetails, status, applicant, partners);

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
    var url = '$domainUrl/matchings/applications';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

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
      print("매칭신청 완료");
      return true;
    } else {
      print("매칭신청 실패 : ${utf8.decode(response.bodyBytes)}");
      return false;
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

  매칭 완료 일시 > 매칭 시작 시간 조회

  */
  static Future<String> matchingProfessData() async {
    var url = Uri.parse('$domainUrl/matchings/applications/begin-time');

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.get(
      url,
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      return responseBody['result']['matchingBeginTime'];
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (responseBody['code'] == 'AT-C-002') {
        // 액세스 토큰 만료
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        // 로그아웃된 토큰
        throw 'AT-C-007';
      } else {
        throw Exception('요청 오류');
      }
    }
  }
}
