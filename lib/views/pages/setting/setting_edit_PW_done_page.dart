import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
          ),
        ),
        body: Column(
          children: [
            Expanded(
                flex: 4,
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
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xffc6c6c6),
                        ),
                      )
                    ],
                  ),
                )),
            Expanded(
              child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Button(
                        child: Text('확인'),
                        onPressed: () {
                          //로그아웃시키고
                          authProvider.logout(context);
                        }),
                  )),
            )
          ],
        ));
  }
}
