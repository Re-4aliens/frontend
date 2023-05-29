import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import '../../components/appbar.dart';
import '../../components/button.dart';

class SettingDeleteDonePage extends StatefulWidget {
  const SettingDeleteDonePage({super.key});

  @override
  State<SettingDeleteDonePage> createState() => _SettingDeleteDonePageState();
}

class _SettingDeleteDonePageState extends State<SettingDeleteDonePage> {
  @override
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    //final AuthProvider authProvider = new AuthProvider();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          backgroundColor: Colors.transparent,
          appBar: AppBar(), title: '',infookay: false, infocontent: '',
        ),
        body: Padding(
          padding: EdgeInsets.only(right: 24,left: 24,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.12),
          child: Column(
            children: [
              Expanded(
                  flex: 6,
                  child: Container(
                    //decoration: BoxDecoration(color: Colors.green),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '탈퇴완료',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: isSmallScreen?22:24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Container(
                          child: SvgPicture.asset(
                            'assets/icon/icon_check.svg',
                            color: Color(0xff7898ff),
                          ),
                          height: MediaQuery.of(context).size.height * 0.126,
                          width: MediaQuery.of(context).size.width*0.272,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Text('그동안 이용해주셔서 감사합니다.\n회원가입을 통해\n언제든지 다시 시작할 수 있어요!',
                          style: TextStyle(
                            color: Color(0xff414141),
                            fontSize: isSmallScreen?14:16
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  )),
              Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Button(
                        child: Text('홈으로 돌아가기'),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
                          );
                        }),
                  )),

            ],
          ),
        ));
  }
}
