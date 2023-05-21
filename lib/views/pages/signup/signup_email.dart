import 'dart:convert';
import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../models/members.dart';
import '../../components/button.dart';

import 'package:http/http.dart'as http;

class SignUpEmail extends StatefulWidget {
  const SignUpEmail({super.key});

  @override
  State<SignUpEmail> createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _EmailController = TextEditingController();
  FocusNode _emailFocus = new FocusNode();

  var existence = true;
  bool _isContinueButtonPressed = false;
  bool _isVerified = false;


  Widget build(BuildContext context) {
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    final double fontSize = isSmallScreen ? 14.0 : 16.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(appBar: AppBar(), title: '',  backgroundColor: Colors.white, infookay: false, infocontent: '',),
      body: Padding(
        padding: EdgeInsets.only(right: 20, left: 20, top: MediaQuery
            .of(context).size.height * 0.06,
            bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('본인 인증을 위해\n이메일을 입력해주세요',
              style: TextStyle(fontSize: isSmallScreen?22:24, fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.013),
            Text('작성하신 메일로 보내드린 코드를 통해 인증이 진행됩니다.',
              style: TextStyle(fontSize: isSmallScreen?12:14, color: Color(0xff888888)),),
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height * 0.022),
            Form(
                key: _formKey,
                child: Row(
                  children: [
                    Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _emailFocus,
                          onChanged: (value){
                            _CheckValidate(value);
                          },
                          /*validator: (value) =>
                              CheckValidate()(
                                  _emailFocus, value!),*/
                          controller: _EmailController,
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              hintText: '이메일 주소를 입력해주세요',
                              hintStyle: TextStyle(fontSize: isSmallScreen?14:16, color: Color(0xffD9D9D9))
                          ),)
                    ),
                    Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: _isButtonEnabled
                                ? Color(0xff5F5F5F)
                                : Color(0xffEBEBEB),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)
                            )
                        ),

                        child: Text('중복확인', style: TextStyle(
                            fontSize: MediaQuery
                                .of(context).size.height * 0.023,
                            color: _isButtonEnabled? Color(0xffC4C4C4) : Color(0xffC4C4C4)),),
                        onPressed:()
                            {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        '이메일 중복확인', textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: isSmallScreen?14:16),),
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '사용 가능한 이메일입니다.\n계속해서 회원가입 진행을 완료해주세요:)',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: isSmallScreen?12:14),),
                                          ]
                                      ),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: Text('취소',
                                            style: TextStyle(
                                                color: Colors.black, fontSize: isSmallScreen?12:14),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CupertinoDialogAction(
                                            child: Text('계속하기',
                                              style: TextStyle(fontSize: isSmallScreen?12:14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),),
                                            onPressed: () {
                                              setState(() {
                                                _isContinueButtonPressed = true;
                                                _isVerified = true;
                                              });
                                              Navigator.pop(context);}
                                        )
                                      ],
                                    );
                                  }
                              );
                            }
                            //아래 주석 전부다 api 연결시 활성화
                        /*_isButtonEnabled ? () async {
                          //true면 존재, 다시 시도

                          //false면 존재하지 않음.

                          //중복 확인 api
                          const url = 'http://13.125.205.59:8080/api/v1/member/email/';
                          var response =
                          await http.get(Uri.parse(
                              url + _EmailController.text + '/existence'),
                          );

                          if (response.statusCode == 200) {
                            print(response.body);
                            //true면 중복, 사용불가
                            if (json.decode(
                                response.body)['response']['existence'] == true)
                              existence = true;
                            else
                              existence = false;
                          } else {
                            //오류 생기면 바디 확인
                            print(response.body);
                          }


                          if (existence == false)
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    */
                        /*shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),*/
                        /*
                                    title: Text(
                                      '이메일 중복확인',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    content: Text(
                                      '이미 존재하는 이메일입니다!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    actions: [
                                      SimpleDialogOption(
                                          child: Text(
                                            '확인',
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          })
                                    ],
                                  );
                                });
                          else
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: Text(
                                      '이메일 중복확인', textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: isSmallScreen?14:16),),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '사용 가능한 이메일입니다.\n계속해서 회원가입 진행을 완료해주세요:)',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: isSmallScreen?12:14),),
                                        ]
                                  ),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: Text('취소',
                                          style: TextStyle(
                                              color: Colors.black, fontSize: isSmallScreen?12:14),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          },
                                      ),
                                      CupertinoDialogAction(
                                          child: Text('계속하기',
                                            style: TextStyle(fontSize: isSmallScreen?12:14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),),
                                          onPressed: () {
                                            setState(() {
                                              _isContinueButtonPressed = true;
                                              _isVerified = true;
                                            });
                                            Navigator.pop(context);}
                                            )
                                    ],
                                    );
                                }
                                );
                        } : null,*/
                      ),
                    )
                  ],
                )),
            Divider(
              height: 0,
              thickness: 1,
            ),
            Expanded(child: SizedBox()),
          Container(
              width : double.maxFinite,
              height: isSmallScreen?44:48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: fontSize,
                  color: _isVerified?Color(0xffFFFFFF) : Color(0xff888888)),
                  backgroundColor: _isVerified?Color(0xff7898FF): Color(0xffEBEBEB),// 여기 색 넣으면됩니다
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)
                  )
              ),
              child: Text('인증번호 요청'),
              onPressed:_isVerified?
                  () async {
                 /* if (_formKey.currentState!.validate() && existence == false) {
                    member.email = _EmailController!.text;
                    print(member.toJson()); // 이메일 인증 코드 보내기

                    const url = 'http://13.125.205.59:8080/api/v1/email/';
                    var response = await http.post(Uri.parse(url + _EmailController.text + '/verification'),);

                    if (response.statusCode == 200) {
                      print(response.body);
                    } else {
    //오류 생기면 바디 확인
                      print(response.body);
                    }*/
                    Navigator.pushNamed(context, '/verify', arguments: member);}
              :null
              )
          )
          ],
        ),
      ),
    );
  }

  bool _isButtonEnabled = false;

  void _CheckValidate(String value) {
    if (value.isEmpty) {
      print('이메일 주소를 입력해주세요');
    } else {
      String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        print('잘못된 이메일 형식입니다');
      } else {
        setState(() {
          _isButtonEnabled = true;
        });
      }
    }
  }
}