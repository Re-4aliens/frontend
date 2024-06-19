import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ReportService extends APIService {
/*

  채팅 상대 신고

   */
  static Future<bool> reportPartner(
      String reportCategory, String reportContent, int memberId) async {
    var url = 'http://3.34.2.246:8080/api/v1/report/$memberId'; //mocksever

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
          "reportCategory": reportCategory,
          "reportContent": reportContent,
        }));

    //success
    if (response.statusCode == 200) {
      return true;
      //fail
    } else {
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
  
  게시글 신고

  */
  static Future<bool> reportBoard(int boardId, String reason) async {
    const url = '$domainUrl/boards/report';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

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
      return true;
    } else {
      if (responseBody['code'] == 'AT-C-002') {
        // 액세스 토큰 만료
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        // 로그아웃된 토큰
        throw 'AT-C-007';
      }
      return false;
    }
  }
}
