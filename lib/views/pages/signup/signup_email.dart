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

  var existence = true;

  Widget build(BuildContext context) {
    dynamic member = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
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
              '본인 인증을 위해\n이메일을 입력해주세요',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('작성하신 메일로 보내드린 코드를 통해 인증이 진행됩니다.'),
            SizedBox(height: 40),
            Form(
                key: _formKey,
                child: Row(
                  children: [
                    Flexible(
                        child: TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "유효한 이메일 주소가 아닙니다" : null,
                      controller: _EmailController,
                      decoration: new InputDecoration(
                          border: InputBorder.none, hintText: '이메일 주소를 입력해주세요'),
                    )),
                    Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // 여기 색 넣으면됩니다
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40))),
                        child: Text('중복확인'),
                        onPressed: () async {


                          //true면 존재, 다시 시도

                          //false면 존재하지 않음.

                          //중복 확인 api
                          const url = 'http://13.125.205.59:8080/api/v1/member/email/';
                          var response =
                              await http.get(Uri.parse(url + _EmailController.text +'/existence'),
                          );

                          if (response.statusCode == 200) {
                            print(response.body);
                            //true면 중복, 사용불가
                            if(json.decode(response.body)['response']['existence'] == true)
                              existence = true;
                            else
                              existence = false;

                          } else {
                            //오류 생기면 바디 확인
                            print(response.body);
                          }


                          if(existence == true)
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
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
                                    actionsAlignment: MainAxisAlignment.center,
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
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    title: Text(
                                      '이메일 중복확인',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    content: Text(
                                      '사용 가능한 이메일입니다.\n계속해서 회원가입 진행을 완료해주세요:)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      SimpleDialogOption(
                                        child: Text('취소'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),

                                      SimpleDialogOption(
                                          child: Text(
                                            '계속하기',
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
                        },
                      ),
                    )
                  ],
                )),
            Divider(
              height: 0,
              thickness: 1,
            ),
            Expanded(child: SizedBox()),
            Button(
                child: Text('본인 인증하기'),
                onPressed: () async {
                  if (_formKey.currentState!.validate() && existence == false) {
                    member.email = _EmailController!.text;
                    print(member.toJson());
                    // 이메일 인증 코드 보내기
                    const url = 'http://13.125.205.59:8080/api/v1/email/';
                    var response =
                        await http.post(Uri.parse(url + _EmailController.text +'/verification'),
                    );

                    if (response.statusCode == 200) {
                      print(response.body);

                    } else {
                      //오류 생기면 바디 확인
                      print(response.body);
                    }

                    Navigator.pushNamed(context, '/verify', arguments: member);
                  }
                })
          ],
        ),
      ),
    );
  }
}
