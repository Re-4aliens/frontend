import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';


import '../../components/button.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _pwFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthProvider authProvider = new AuthProvider();
  static final storage = FlutterSecureStorage();


  //storage에 작성할 모델
  final Auth auth = new Auth();

  Widget build(BuildContext context) {
    //Members members = new Members('','','','','','','','');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        onPressed: () {},
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                  Text(
                    'FRIEND SHIP',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '프렌즈쉽에 오신것을 환영합니다.',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: Column(
                  children: [
                    Form(
                      key: _emailFormKey,
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3.0,
                        child: TextFormField(
                          validator : (value) => value!.isEmpty? "Please enter some text" : null,
                          controller: _emailController,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.all(25),
                              hintText: '이메일주소',
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25)
                              )
                          ),
                        ),
                      ) ,

                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _pwFormKey,
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3.0,
                        child: TextFormField(
                          validator : (value) => value!.isEmpty? "Please enter some text" : null,
                          controller: _passwordController,
                          decoration: new InputDecoration(
                              contentPadding: EdgeInsets.all(25),
                              hintText: '비밀번호',
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25)
                              )
                          ),
                        ),
                      ) ,

                    ),
                  ],
                ),
            ),
            Button(
                child: Text('로그인'),
                onPressed: () async {

                  if (_emailFormKey.currentState!.validate() && _pwFormKey.currentState!.validate()) {
                    auth.email = _emailController.text;
                    auth.password = _passwordController.text;

                    //로그인 정보 저장
                    await storage.write(
                      key: 'auth',
                      value: jsonEncode(auth),
                    );

                    //http 요청
                    authProvider.login(auth, context);
                  }


                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('비밀번호를 잊으셨나요?'),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login/findpassword');
                    },
                    child: Text(
                      '비밀번호 찾기',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
