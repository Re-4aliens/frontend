import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class EmailService extends APIService {
  /*

  이메일 중복 확인

   */
  static Future<bool> checkExistence(String email) async {
    var url = '$domainUrl/members/exist?email=$email';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));

      if (responseData != null && responseData['result'] != null) {
        var result = responseData['result'];
        if (result.contains("사용 가능한 이메일입니다")) {
          return false; // 사용 가능한 이메일인 경우 false 반환
        } else {
          return true; // 사용 불가능한 이메일인 경우 true 반환
        }
      } else {
        // 응답에 'result' 필드가 없음
        return false;
      }
    } else {
      // 실패
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
      return true;
      //fail
    } else {
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

      var code = responseData['code'];
      var result = responseData['result'];

      if (code == 'E003') {
        return result;
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to get authentication status');
    }
  }
}
