import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/button.dart';
import 'package:aliens/providers/auth_provider.dart';

class SettingEditPWDonePage extends StatefulWidget {
  const SettingEditPWDonePage({super.key});

  @override
  State<SettingEditPWDonePage> createState() => _SettingEditPWDonePageState();
}

class _SettingEditPWDonePageState extends State<SettingEditPWDonePage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    final AuthProvider authProvider = new AuthProvider();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          backgroundColor: Colors.transparent,
          appBar: AppBar(), title: '',infookay: false, infocontent: '',
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20, bottom: 50, top:120),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    //decoration: BoxDecoration(color: Colors.green),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '비밀번호가 변경되었습니다!\n다시 로그인 해주세요.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: isSmallScreen?22:24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 50,
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
                          Navigator.pushNamed(context,'/');
                          //로그아웃시키고
                          authProvider.logout(context);
                        }),
                  )),

          ],
          ),
        ));
  }
}
