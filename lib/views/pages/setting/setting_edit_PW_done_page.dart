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
    final AuthProvider authProvider = new AuthProvider();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          backgroundColor: Colors.transparent,
          appBar: AppBar(), title: '', onPressed: (){},
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
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          child: SvgPicture.asset(
                            'assets/icon/icon_check.svg',
                            color: Color(0xff7898ff),
                          ),
                          height: 100,
                          width: 100,
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
                        child: Text('확인'),
                        onPressed: () {
                          //로그아웃시키고
                          authProvider.logout(context);
                        }),
                  )),

          ],
          ),
        ));
  }
}
