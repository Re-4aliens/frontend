import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../components/appbar.dart';
import '../../components/button.dart';
import 'package:http/http.dart' as http;

class SettingEditPWPage extends StatefulWidget {
  const SettingEditPWPage({super.key});

  @override
  State<SettingEditPWPage> createState() => _SettingEditPWPageState();
}

class _SettingEditPWPageState extends State<SettingEditPWPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordControllerSecond = TextEditingController();
  static final storage = FlutterSecureStorage();


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: CustomAppBar(appBar: AppBar(), title: '', backgroundColor: Colors.transparent, infookay: false, infocontent: '',),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                '새로운 비밀번호를 입력하시면\n비밀번호 변경이 완료됩니다.',
                style: TextStyle(fontSize: isSmallScreen?22:24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: '새 비밀번호 입력',
                  hintStyle: TextStyle(
                    fontSize: isSmallScreen?18:20,
                    color: Color(0xffb8b8b8),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '영문, 특수기호, 숫자를 포함 10자 이상',
                    style: TextStyle(
                      fontSize: isSmallScreen?12:14,
                      color: Color(0xffB8B8B8),
                    ),
                  )),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                key: _formKey,
                controller: _passwordControllerSecond,
                decoration: InputDecoration(
                  hintText: '새 비밀번호 재입력',
                  hintStyle: TextStyle(
                    fontSize: isSmallScreen?18:20,
                    color: Color(0xffb8b8b8),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '영문, 특수기호, 숫자를 포함 10자 이상',
                    style: TextStyle(
                      fontSize: isSmallScreen?12:14,
                      color: Color(0xffb8b8b8),
                    ),
                  )),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 50),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Button(
                        child: Text('비밀번호 변경하기'),
                        onPressed: () async {

                          var userInfo = await storage.read(key: 'auth');

                            //입력한 두 패스워드가 같으면
                            if (_passwordController.text == _passwordControllerSecond.text) {
                              Navigator.pushNamed(context,'/setting/edit/PW/done');
                              print('바꾸기');
                              //비밀번호 수정 요청
                              var url =
                                 'http://13.125.205.59:8080/api/v1/member/password'; //mocksever
                            //토큰 읽어오기
                              var jwtToken = await storage.read(key: 'token');

                              //accessToken만 보내기
                              jwtToken = json.decode(jwtToken!)['accessToken'];


                              var response = await http.put(Uri.parse(url),
                                  headers: {
                                    'Authorization': 'Bearer $jwtToken',
                                    'Content-Type': 'application/json'},
                                  body: jsonEncode({
                                    "currentPassword":json.decode(userInfo!)['password'],
                                    "newPassword" : _passwordControllerSecond.text,
                                  }));

                              //success
                              if (response.statusCode == 200) {
                                print(json.decode(response.body));
                                Navigator.pushNamed(context,'/setting/edit/PW/done');
                                //fail
                              } else {
                                print(response.statusCode);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CupertinoAlertDialog(
                                          title: Text(
                                            '변경 불가',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: const Text(
                                              '변경불가 이유'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('확인',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  )),
                                            ),
                                          ],
                                        ));
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CupertinoAlertDialog(
                                        title: Text(
                                          '새 비밀번호 미일치',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: const Text('비밀번호를 확인해주세요.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('확인',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ));
                            }})
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
