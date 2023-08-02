import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:aliens/views/components/button_big.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../apis.dart';
import '../../../apis/apis.dart';
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

  //storage에 작성할 모델
  final Auth auth = new Auth();

  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth <= 600;
    final double fontSize = isSmallScreen ? 16.0 : 20.0;
    final double heightSize = isSmallScreen ? 70 : 90;

    String constraintsText = "";

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
                        child: SvgPicture.asset('assets/character/logoimage.svg'),
                      ),
                      SizedBox(height: 15),
                      SvgPicture.asset('assets/character/logotext.svg', color: Colors.black,),
                      SizedBox(height: 5,),
                      Text(
                        'login3'.tr(),
                        style: TextStyle(
                            fontSize: isSmallScreen?14:16, color: Color(0xff616161)),
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
                                blurRadius: 10,
                                //spreadRadius: 0.2,
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
                            EdgeInsets.symmetric(horizontal: 27.21),
                            hintText: 'email'.tr(),
                            hintStyle: TextStyle(
                                fontSize: isSmallScreen?14:16, color: Color(0xffA0A0A0)),
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
                    SizedBox(height: MediaQuery.of(context).size.height*0.035),
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
                                blurRadius: 10,
                                //spreadRadius: 0.2,
                                color: Colors.grey.shade300,
                                offset: const Offset(0, 4),
                              )
                            ]),
                        child: TextFormField(
                          obscureText: true,
                          obscuringCharacter: '*',
                          validator: (value) =>
                          value!.isEmpty ? "Please enter some text" : null,
                          controller: _passwordController,
                          decoration: new InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 27.21),
                              hintText: 'password'.tr(),
                              hintStyle: TextStyle(
                                  fontSize: isSmallScreen?14:16, color: Color(0xffA0A0A0)),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.031),
                    BigButton(
                      child: Text(
                        'login1'.tr(),
                        style: TextStyle(fontSize: fontSize),
                      ),
                      onPressed: () async {
                        if (_emailFormKey.currentState!.validate() &&
                            _pwFormKey.currentState!.validate()) {
                          auth.email = _emailController.text;
                          auth.password = _passwordController.text;

                          var loginSuccess = await APIs.logIn(auth);

                          if (loginSuccess) {
                            //스택 비우고 화면 이동
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/loading', (Route<dynamic> route) => false);

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
                                      content: Text('아이디 및 비밀번호를 확인해주세요!'),
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
                    SizedBox(height: MediaQuery.of(context).size.height *0.035 ,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('findpassword1'.tr(), style: TextStyle(fontSize: isSmallScreen?12:14),),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/login/findpassword');
                            },
                            child: Text(
                              'findpassword2'.tr(),
                              style: TextStyle(
                                  fontSize: isSmallScreen?12:14,
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