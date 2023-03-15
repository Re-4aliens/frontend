import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingSecurityPage extends StatefulWidget {
  const SettingSecurityPage({super.key});

  @override
  State<SettingSecurityPage> createState() => _SettingSecurityPageState();
}

class _SettingSecurityPageState extends State<SettingSecurityPage> {
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
          '보안관리',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(

        children: [
          SizedBox(height: 20,),
          ListTile(
            onTap: (){
              Navigator.pushNamed(context, '/setting/edit/find');
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('비밀번호 변경'),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Color(0xff4d4d4d),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: (){
              Navigator.pushNamed(context, '/setting/delete/PWcheck');
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('회원탈퇴'),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Color(0xff4d4d4d),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
