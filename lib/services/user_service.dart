import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'package:aliens/models/signup_model.dart';
import '../util/image_util.dart';
import 'dart:io';

class UserService extends APIService {
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

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /*

    개인 정보 조회

  */
  static Future<Map<String, dynamic>> getMemberDetails() async {
    var url = '$domainUrl/members';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': jwtToken, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      return responseBody['result'];
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
      throw Exception('요청 오류');
    }
  }

  /*

  mbti 변경

   */
  static Future<bool> updateMBTI(String newMBTI) async {
    var url = '$domainUrl/members/mbti';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

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
      return true;
    } else {
      return false;
    }
  }

  /*

프로필 수정(테스트 실패)

 */

  static Future<bool> updateProfile(File profileImageFile) async {
    var url = '$domainUrl/member/profile-image';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

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
      return true;
    } else {
      return false;
    }
  }

  /*

  자기소개 변경

  */
  static Future<bool> updateSelfIntroduction(String newAboutMe) async {
    var url = '$domainUrl/members/about-me';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

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

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /*
    
    회원 매칭상태 조회

  */
  static Future<String> getApplicantStatus() async {
    var url = '$domainUrl/members/status';

    var jwtToken = await APIService.storage.read(key: 'token');

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
        if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
            'AT-C-002') {
          // 엑세스 토큰 만료
          throw 'AT-C-002';
        } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
            'AT-C-007') {
          // 로그아웃된 토큰
          throw 'AT-C-007';
        } else {
          // 정보 없음
          return "NotAppliedAndNotMatched";
        }
      }
    } else {
      // jwtToken이 null인 경우
      throw 'TokenNotFound';
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
      //fail
    } else {}
  }

  /*

  매칭 신청 // 매칭 신청 api작성했으나 기존 코드라서 둠

   */
  static Future<bool> inquiry(String question) async {
    var url = 'http://3.34.2.246:8080/api/v1/member/question'; //mocksever

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
          "question": question,
        }));

    //success
    if (response.statusCode == 200) {
      return true;
    }
    //fail
    else {
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        // 액세스 토큰 만료
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        // 로그아웃된 토큰
        throw 'AT-C-007';
      } else {}
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
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
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
}
