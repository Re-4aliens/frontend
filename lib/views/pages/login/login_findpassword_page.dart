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

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        onPressed: () {},
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '비밀번호를 찾기 위해\n가입하신 이메일을 입력해주세요.',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('작성하신 메일로 임시비밀번호를 발급해드려요.'),
            SizedBox(height: 40),
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) =>
                    value!.isEmpty ? "Please enter some text" : null,
                controller: emailController,
                decoration: new InputDecoration(hintText: '이메일'),
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
