import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingDeletePage extends StatefulWidget {
  const SettingDeletePage({super.key});

  @override
  State<SettingDeletePage> createState() => _SettingDeletePageState();
}

class _SettingDeletePageState extends State<SettingDeletePage> {
  @override
  Widget build(BuildContext context) {

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
          title: Text(
            '회원탈퇴',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              Text('탈퇴하기',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('영문, 특수기호, 숫자를 포함 10자 이상',
                    style: TextStyle(
                      color: Color(0xffb8b8b8),
                    ),)),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 250,
                child: TextFormField(
                  decoration: InputDecoration(

                  ),
                  //입력 값이 비밀번호와 다르면

                  //입력 값이 비밀번호와 같으면

                ),
              ),
            ],
          ),
        )
    );
  }
}
