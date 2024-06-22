import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class EmailService extends APIService {
  /*

  이메일 중복 확인

   */
  static Future<bool> checkExistence(String email) async {
    var url =
        'http://3.34.2.246:8080/api/v1/member/email/$email/existence'; //mocksever

    var response = await http.get(Uri.parse(url));

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));

      return json.decode(utf8.decode(response.bodyBytes))['data']['existence'];
      //fail
    } else {
      // 응답에 'result' 필드가 없음
      print(response.body);
      return json.decode(utf8.decode(response.bodyBytes))['data']['existence'];
    }
  }

  /*

  이메일 인증 요청

   */
  static Future<bool> verifyEmail(String email) async {
    var url =
        'http://3.34.2.246:8080/api/v1/email/$email/verification'; //mocksever

    var response = await http.post(Uri.parse(url));
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
    var url =
        'http://3.34.2.246:8080/api/v1/email/$email/authentication-status'; //

    var response = await http.get(Uri.parse(url));

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
}
