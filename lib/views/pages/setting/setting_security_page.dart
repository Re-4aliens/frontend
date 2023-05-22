import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/appbar.dart';

class SettingSecurityPage extends StatefulWidget {
  const SettingSecurityPage({super.key});

  @override
  State<SettingSecurityPage> createState() => _SettingSecurityPageState();
}

class _SettingSecurityPageState extends State<SettingSecurityPage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    var memberDetails = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(appBar: AppBar(), backgroundColor: Colors.transparent, infookay: false, infocontent: '',title: '보안관리',),
        body: Container(
          padding: EdgeInsets.only(right: 24, left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
            Text('보안',
              style: TextStyle(
              fontSize: isSmallScreen?14:16,
              color: Color(0xffC1C1C1)
            ),),
            ListTile(
              onTap: (){
                Navigator.pushNamed(context, '/setting/edit/find', arguments: memberDetails);
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('비밀번호 변경', style: TextStyle(fontSize: isSmallScreen?14:16, fontWeight: FontWeight.bold),),
                  SvgPicture.asset(
                    'assets/icon/icon_next.svg',
                      width: MediaQuery.of(context).size.width * 0.022,
                    color: Color(0xffC1C1C1),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Color(0xffEFEFEF),
            ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
              Text('탈퇴',
                style: TextStyle(
                    fontSize: isSmallScreen?14:16,
                    color: Color(0xffC1C1C1)
                ),),
            ListTile(
              onTap: (){
                Navigator.pushNamed(context, '/setting/delete/what', arguments: memberDetails);
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('회원탈퇴', style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallScreen?14:16),),
                  SvgPicture.asset(
                    'assets/icon/icon_next.svg',
                    width: MediaQuery.of(context).size.width * 0.022,
                    color: Color(0xffC1C1C1),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Color(0xffEFEFEF),
            ),
          ],
      ),
        )
    );
  }
}
