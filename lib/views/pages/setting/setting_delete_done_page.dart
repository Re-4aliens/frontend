import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../components/button.dart';

class SettingDeleteDonePage extends StatefulWidget {
  const SettingDeleteDonePage({super.key});

  @override
  State<SettingDeleteDonePage> createState() => _SettingDeleteDonePageState();
}

class _SettingDeleteDonePageState extends State<SettingDeleteDonePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

        body: Column(
          children: [
            Expanded(
                flex: 4,
                child: Container(
                  //decoration: BoxDecoration(color: Colors.green),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 156,
                        width: 156,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(78),
                          color: Color(0xffd9d9d9),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        '탈퇴 완료',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '그동안 이용해주셔서 감사합니다.\n회원가입을 통해\n언제든지 다시 시작할 수 있어요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                        height: 1.5),
                      ),
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
                      onPressed: (){
                        //탈퇴시키고


                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
                        );
                      }),
                ),

              ),
            )
          ],
        )
    );
  }
}
