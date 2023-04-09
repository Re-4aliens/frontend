import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../components/appbar.dart';
import '../../components/button.dart';

class SettingEditPWPage extends StatefulWidget {
  const SettingEditPWPage({super.key});

  @override
  State<SettingEditPWPage> createState() => _SettingEditPWPageState();
}

class _SettingEditPWPageState extends State<SettingEditPWPage> {
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
              Text('새로운 비밀번호를 입력하시면\n비밀번호 변경이 완료됩니다.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '새 비밀번호 입력',
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
              SizedBox(height: 30,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '새 비밀번호 재입력',
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
                        child: Text('비밀번호 변경하기'),
                        onPressed: (){
                          Navigator.pushNamed(context,'/setting/edit/PW/done');
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
