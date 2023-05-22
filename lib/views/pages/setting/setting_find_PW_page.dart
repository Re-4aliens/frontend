import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../components/appbar.dart';
import '../../components/button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingFindPWPage extends StatefulWidget {
  const SettingFindPWPage({super.key});

  @override
  State<SettingFindPWPage> createState() => _SettingFindPWPageState();
}

class _SettingFindPWPageState extends State<SettingFindPWPage> {
  static final storage = FlutterSecureStorage();


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    var memberDetails = ModalRoute.of(context)!.settings.arguments;
    final TextEditingController _passwordController = TextEditingController();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(appBar: AppBar(), title: '',backgroundColor: Colors.transparent, infookay: false, infocontent: '',),

        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Text('비밀번호를 변경하기 위해\n기존 비밀번호를 입력해주세요.',
                style: TextStyle(
                    fontSize: isSmallScreen?22:24,
                    fontWeight: FontWeight.bold
                ),),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: '비밀번호 입력',
                  hintStyle: TextStyle(
                    fontSize: isSmallScreen?18:20,
                    color: Color(0xffD9D9D9),
                  ),

                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('영문, 특수기호, 숫자를 포함 10자 이상',
                    style: TextStyle(
                      fontSize: isSmallScreen?12:14,
                      color: Color(0xffb8b8b8),
                    ),)),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 50),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Button(
                        child: Text('인증완료'),
                        onPressed: ()async {
                          Navigator.pushNamed(context, '/setting/edit/PW',
                              arguments: _passwordController.text);
                        /*  //if 지금 비밀번호랑 입력한 거랑 같으면
                          var userInfo = await storage.read(key: 'auth');
                          if (_passwordController.text ==
                              json.decode(userInfo!)['password'])
                            Navigator.pushNamed(context, '/setting/edit/PW',
                                arguments: _passwordController.text);
                          else
                            showDialog(context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(

                                      title: Text('비밀번호 미일치',
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
                                    ));*/
                        }
                        ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
