import 'dart:convert';
import 'package:aliens/views/components/appbar.dart';
import 'package:aliens/views/pages/signup/signup_password.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../apis/apis.dart';
import '../../../models/members.dart';
import '../../components/button.dart';

import 'package:http/http.dart' as http;

class SignUpEmail extends StatefulWidget {
  const SignUpEmail({super.key});

  @override
  State<SignUpEmail> createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _EmailController = TextEditingController();
  FocusNode _emailFocus = new FocusNode();

  //var existence = true;
  bool _isVerified = false;
  bool _isButtonEnabled = false;

  Widget build(BuildContext context) {
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    final double fontSize = isSmallScreen ? 14.0 : 16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        backgroundColor: Colors.white,
        infookay: false,
        infocontent: '',
      ),
      body: Padding(
        padding: EdgeInsets.only(
            right: 20,
            left: 20,
            top: MediaQuery.of(context).size.height * 0.06,
            bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'signup-email1'.tr()}\n${'signup-email2'.tr()}',
              style: TextStyle(
                  fontSize: isSmallScreen ? 22 : 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.013),
            Text(
              '${'signup-email3'.tr()}\n${'signup-email4'.tr()}',
              style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14, color: Color(0xff888888)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.022),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocus,
                        onChanged: (value) {
                          _CheckValidate(value);
                        },
                        controller: _EmailController,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: '${'signup-email5'.tr()}',
                          hintStyle: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Color(0xffD9D9D9),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: _isButtonEnabled
                                ? Color(0xff5F5F5F)
                                : Color(0xffEBEBEB),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40))),
                        child: Text(
                          '${'signup-email6'.tr()}',
                          style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: _isButtonEnabled
                                  ? Color(0xffC4C4C4)
                                  : Color(0xffC4C4C4)),
                        ),
                        onPressed: () async {
                          if (_isButtonEnabled) {
                            //await APIs.checkEmail(_EmailController.text)
                            if (await APIs.checkExistence(
                                _EmailController.text)) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        '${'signup-email14'.tr()}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: isSmallScreen ? 14 : 16),
                                      ),
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${'signup-email15'.tr()}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize:
                                                      isSmallScreen ? 12 : 14),
                                            ),
                                          ]),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: Text(
                                            '${'confirm'.tr()}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    isSmallScreen ? 12 : 14),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        '${'signup-email14'.tr()}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: isSmallScreen ? 14 : 16),
                                      ),
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(
                                                '${'signup-email16'.tr()}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: isSmallScreen
                                                        ? 12
                                                        : 14),
                                              ),
                                            ),
                                          ]),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: Text(
                                            '${'cancel'.tr()}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    isSmallScreen ? 12 : 14),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CupertinoDialogAction(
                                            child: Text(
                                              '${'next'.tr()}',
                                              style: TextStyle(
                                                  fontSize:
                                                      isSmallScreen ? 12 : 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isVerified = true;
                                              });
                                              Navigator.pop(context);
                                              FocusScope.of(context).unfocus();
                                            })
                                      ],
                                    );
                                  });
                            }
                          }
                        }),
                  )
                ],
              ),
            ),
            Divider(
              height: 0,
              thickness: 1,
            ),
            SizedBox(
              height: 7,
            ),
            _isButtonEnabled
                ? Text('${'signup-email11'.tr()}')
                : SizedBox(
                    height: 0,
                  ),
            Expanded(child: SizedBox()),
            Container(
                width: double.maxFinite,
                height: isSmallScreen ? 44 : 48,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: fontSize,
                            color: _isVerified
                                ? Color(0xffFFFFFF)
                                : Color(0xff888888)),
                        backgroundColor: _isVerified
                            ? Color(0xff7898FF)
                            : Color(0xffEBEBEB), // 여기 색 넣으면됩니다
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    child: Text('${'signup-email7'.tr()}'),
                    onPressed: _isVerified
                        ? () async {
                            member.email = _EmailController!.text;
                            print(member.toJson());

                            showDialog(
                                context: context,
                                builder: (_) => FutureBuilder(
                                    future: APIs.verifyEmail(member.email),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData == false) {
                                        //받아오는 동안
                                        return Container(
                                            child: Image(
                                                image: AssetImage(
                                                    "assets/illustration/loading_01.gif")));
                                      } else{
                                        //받아온 후
                                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                                          Navigator.popAndPushNamed(context, '/verify', arguments: member);
                                        });
                                        print(member.toJson());
                                        return Container(
                                            child: Image(
                                                image: AssetImage(
                                                    "assets/illustration/loading_01.gif")));
                                      }

                                    }));

                          }
                        : null))
          ],
        ),
      ),
    );
  }

  void _CheckValidate(String value) {
    if (value.isEmpty) {
      print('이메일 주소를 입력해주세요');
    } else {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        print('잘못된 이메일 형식입니다');
        setState(() {
          _isButtonEnabled = false;
        });
      } else {
        setState(() {
          _isButtonEnabled = true;
        });
      }
    }
  }
}
