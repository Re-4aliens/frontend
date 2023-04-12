import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingSecurityPage extends StatefulWidget {
  const SettingSecurityPage({super.key});

  @override
  State<SettingSecurityPage> createState() => _SettingSecurityPageState();
}

class _SettingSecurityPageState extends State<SettingSecurityPage> {
  @override
  Widget build(BuildContext context) {
    var memberDetails = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icon/icon_back.svg',
            width: 24,
            height: 24,

          ),
          color: Colors.black,
        ),
        title: Text(
          '보안관리',
          style: TextStyle(
            fontSize: 16,
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
              Navigator.pushNamed(context, '/setting/edit/find', arguments: memberDetails);
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('비밀번호 변경', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                SvgPicture.asset(
                  'assets/icon/icon_next.svg',
                  width: 8.75,
                  height: 16,
                  color: Color(0xffC1C1C1),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: (){
              Navigator.pushNamed(context, '/setting/delete', arguments: memberDetails);
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('회원탈퇴', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                SvgPicture.asset(
                  'assets/icon/icon_next.svg',
                  width: 8.75,
                  height: 16,
                  color: Color(0xffC1C1C1),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
