import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:aliens/models/auth_model.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  static final storage = FlutterSecureStorage();

  Future<void> login(Auth auth, BuildContext context) async {
    const url =
        'https://410affb5-4f61-41b1-8858-a1870887f995.mock.pstmn.io/member/authentication'; //mocksever

    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "email" : auth.email,
          "password" : auth.password,
        }));

    //success
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      //토큰 저장
      await storage.write(
        key: 'token',
        value: response.body,
      );
      print('로그인 성공');

      //스택 비우고 화면 이동
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false
      );

      //fail
    } else {
      print(response.body);
    }
  }

  Future<void> logout(BuildContext context) async {
    print('로그아웃 시도');
    const url =
        'https://410affb5-4f61-41b1-8858-a1870887f995.mock.pstmn.io/member/authentication'; //mocksever

    //헤더 실어서 리퀘스트 만들어서 요청
    var response = await http.delete(Uri.parse(url),
    headers: <String, String>{
      "Authorization": "",
      "RefreshToken" : "",
    });

    //success
    if (response.statusCode == 200) {

      //토큰 및 정보 삭제
      await storage.delete(key: 'auth');
      await storage.delete(key: 'token');
      print('로그아웃, 정보 지움');

      //스택 비우고 화면 이동
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
      );

      //fail
    } else {

    }
  }
}
