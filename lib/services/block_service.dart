import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'package:aliens/models/partner_model.dart';

class BlockService extends APIService {
/*

  채팅 상대 차단

   */
  static Future<bool> blockPartner(Partner partner) async {
    const url = '$domainUrl/chat/block';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

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
      }
      return false;
    }
  }
}
