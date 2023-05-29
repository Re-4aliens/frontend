import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../apis.dart';
import '../../../models/members.dart';
import '../../components/button.dart';

import 'package:http/http.dart' as http;

class LoginFindPassword extends StatefulWidget {
  const LoginFindPassword({super.key});

  @override
  State<LoginFindPassword> createState() => _LoginFindPasswordState();
}

class _LoginFindPasswordState extends State<LoginFindPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();

  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth <= 600;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        backgroundColor: Colors.transparent, infookay: false, infocontent: '',
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 24,left: 24,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('가입하신 이메일과\n이름정보를 입력해주세요.',
              style: TextStyle(fontSize: isSmallScreen?22:24, fontWeight: FontWeight.w700),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.0166,),
            Text('비밀번호를 찾기 위해 작성하신 메일로\n임시비밀번호를 발급해드려요.',
              style: TextStyle(fontSize: isSmallScreen?12:14, color: Color(0xff888888)),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator : (value) => value!.isEmpty? "Please enter some text" : null,
                    controller: _NameController,
                    decoration: new InputDecoration(
                        hintText: '이름',
                        hintStyle: TextStyle(fontSize: isSmallScreen?18:20, color: Color(0xffD9D9D9))
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator : (value) => value!.isEmpty? "Please enter some text" : null,
                    controller: _EmailController,
                    decoration: new InputDecoration(
                        hintText: '이메일',
                        hintStyle: TextStyle(fontSize: isSmallScreen?18:20, color: Color(0xffD9D9D9))
                    ),
                  )

                ],
              ),
            ),
            Expanded(child: SizedBox()),
            Button(
                child: Text('확인'),
                onPressed: () async {

                 if(_formKey.currentState!.validate()){
                    var _email = _EmailController.text;
                    var _name = _NameController.text;
                    //임시 비밀번호 발급 요청


                    //success
                    if (await APIs.temporaryPassword(_email, _name)) {
                      Navigator.pushNamed(context,'/login/checkemail');
                      //fail
                    } else {
                      showDialog(context: context, builder: (BuildContext context) => CupertinoAlertDialog(

                        title: Text('이메일과 이름 미일치',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text('이메일 및 이름을 다시 확인해주세요.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('확인',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      ));
                    }
                  }
                })
          ],
        ),
      ),
    );
  }
}
