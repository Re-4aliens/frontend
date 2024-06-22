import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'package:aliens/models/partner_model.dart';

class BlockService extends APIService {
/*

  채팅 상대 차단

   */
  static Future<bool> blockPartner(Partner partner) async {
    var url =
        'http://3.34.2.246:8080/api/v1/block/${partner.memberId}'; //mocksever

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
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {}
      return false;
    }
  }
}
