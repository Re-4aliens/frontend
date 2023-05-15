import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:aliens/views/components/button_big.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../models/screenArgument.dart';
import '../../components/button.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import '../../../mockdatas/mockdata_model.dart';

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth <= 600;
    final double fontSize = isSmallScreen ? 16.0 : 20.0;
    final double heightSize = isSmallScreen ? 70 : 90;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          right: 24,
          left: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 155,
                        height: 100,
                        //decoration: BoxDecoration(color: Colors.grey),
                      ),
                      Text(
                        '프렌즈쉽에 오신것을 환영합니다.',
                        style: TextStyle(
                            fontSize: fontSize, color: Color(0xff616161)),
                      ),
                    ],
                  ),
                )),
            Expanded(flex: 1, child: Container()),
            Expanded(
                flex: 7,
                child: Column(
                  children: [
                    Form(
                      key: _emailFormKey,
                      child: Container(
                        alignment: Alignment.center,
                        height: heightSize,
                        decoration: BoxDecoration(
                            color: Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 0.2,
                                color: Colors.grey.shade300,
                                offset: const Offset(0, 4),
                              )
                            ]),
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? "Please enter some text" : null,
                          controller: _emailController,
                          decoration: new InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 30),
                            hintText: '이메일 주소',
                            hintStyle: TextStyle(
                                fontSize: fontSize, color: Color(0xffA0A0A0)),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            /*
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25))),
                                  */
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: _pwFormKey,
                      child: Container(
                        alignment: Alignment.center,
                        height: heightSize,
                        decoration: BoxDecoration(
                            color: Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 0.2,
                                color: Colors.grey.shade300,
                                offset: const Offset(0, 4),
                              )
                            ]),
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? "Please enter some text" : null,
                          controller: _passwordController,
                          decoration: new InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 30),
                              hintText: '비밀번호',
                              hintStyle: TextStyle(
                                  fontSize: fontSize, color: Color(0xffA0A0A0)),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25))),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    BigButton(
                      child: Text(
                        '로그인',
                        style: TextStyle(fontSize: fontSize),
                      ),
                      onPressed: () async {
                        if (_emailFormKey.currentState!.validate() &&
                            _pwFormKey.currentState!.validate()) {
                          auth.email = _emailController.text;
                          auth.password = _passwordController.text;

                          /* api 추후에 활성화 시킬 부분
                          //await 키워드로 authprovider.login이 완료될 때까지 잠시 대기
                          var loginSuccess =
                          await authProvider.login(auth, context);
                          */

                          var loginSuccess = true; //임의 값. 값을 수정하면서 사용

                          if (loginSuccess) {
                            print('로그인시도');
                            /* 추후에 활성화 시킬 부분
                           //스택 비우고 화면 이동
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/loading', (Route<dynamic> route) => false);
                            */
                            var screenArgument = new ScreenArguments(
                                {
                                  "email": "exaple_user@exaple.com",
                                  "mbti": "ENFJ",
                                  "gender": "MALE",
                                  "nationality": "Korea",
                                  "birthday": "2000-01-01",
                                  "name": "RYAN",
                                  "profileImage": "url",
                                  "age": 26
                                },
                                /*
                                경우에 따라
                                MATCHED, PENDING, NOT_APPLIED 입력
                                 */
                                {
                                  "status": "NOT_APPLIED"
                                },
                                {
                                  "member": {
                                    "name": "Jenny",
                                    "gender": "Female",
                                    "mbti": "INTJ",
                                    "nationality": "Korea",
                                    "age": 26,
                                    "profileImage": "url/example",
                                    "countryImage": "url/example"
                                  },
                                  "preferLanguages": {
                                    "firstPreferLanguage": "string",
                                    "secondPreferLanguage": "string"
                                  }
                                },
                                {
                                  "partners": [
                                    {
                                      "memberId": 1,
                                      "name": "Mila",
                                      "mbti": "ISFP",
                                      "gender": "FEMALE",
                                      "nationality": "Korea",
                                      "profileImage": "url",
                                      "countryImage": "url"
                                    },
                                    {
                                      "memberId": 2,
                                      "name": "Risa",
                                      "mbti": "ISTJ",
                                      "gender": "FEMALE",
                                      "nationality": "Korea",
                                      "profileImage": "url",
                                      "countryImage": "url"
                                    },
                                    {
                                      "memberId": 3,
                                      "name": "Carina",
                                      "mbti": "ENFJ",
                                      "gender": "MALE",
                                      "nationality": "Japan",
                                      "profileImage": "url",
                                      "countryImage": "url"
                                    },
                                    {
                                      "memberId": 4,
                                      "name": "Jade",
                                      "mbti": "ESFP",
                                      "gender": "MALE",
                                      "nationality": "China",
                                      "profileImage": "url",
                                      "countryImage": "url"
                                    },
                                  ]
                                });

                            /*
                            Navigator.popAndPushNamed(context, '/main',
                                arguments: screenArgument);

 */
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false
                            , arguments: screenArgument);

                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                      title: Text(
                                        '로그인 실패',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: const Text('이메일과 비밀번호를 확인해주세요.'),
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
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('비밀번호를 잊으셨나요?'),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/login/findpassword');
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
                ))
          ],
        ),
      ),
    );
  }
}
