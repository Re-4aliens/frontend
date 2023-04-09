import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../components/appbar.dart';
import '../../components/button.dart';

class SettingFindPWPage extends StatefulWidget {
  const SettingFindPWPage({super.key});

  @override
  State<SettingFindPWPage> createState() => _SettingFindPWPageState();
}

class _SettingFindPWPageState extends State<SettingFindPWPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),

        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Text('비밀번호를 변경하기 위해\n기존 비밀번호를 입력해주세요.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '비밀번호 입력',
                  hintStyle: TextStyle(
                    color: Color(0xffb8b8b8),
                  ),

                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('영문, 특수기호, 숫자를 포함 10자 이상',
                    style: TextStyle(
                      color: Color(0xffb8b8b8),
                    ),)),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 50),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Button(
                        child: Text('인증완료'),
                        onPressed: (){
                          Navigator.pushNamed(context,'/setting/edit/PW');
                        }),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
