import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        onPressed: () {},
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('가입하신 이메일과\n이름정보를 입력해주세요.',
              style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.04, fontWeight: FontWeight.bold),),
            Text('비밀번호를 찾기 위해 작성하신 메일로\n임시비밀번호를 발급해드려요.',
              style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.023, color: Color(0xff888888)),),
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
                        hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.032, color: Color(0xffD9D9D9))
                    ),
                  ),
                  TextFormField(
                    validator : (value) => value!.isEmpty? "Please enter some text" : null,
                    controller: _EmailController,
                    decoration: new InputDecoration(
                        hintText: '이메일',
                        hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.032, color: Color(0xffD9D9D9))
                    ),
                  )

                ],
              ),
            ),
            Expanded(child: SizedBox()),
            Button(
                child: Text('임시 비밀번호 발급'),
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    var email = emailController.text;
                    //임시 비밀번호 발급 요청
                    var url = '';
                    //url = 'http://13.125.205.59:8080/api/v1/member/$email/password/temp'; //mocksever
                    print(url);
                    var response = await http.post(Uri.parse(url),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({
                          "name": 'Joy'
                        }));

                    //success
                    if (response.statusCode == 200) {
                      print(json.decode(response.body));
                      Navigator.pushNamed(context,'/login/checkemail');
                      //fail
                    } else {
                      print(response.body);
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
