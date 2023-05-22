import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:aliens/providers/member_provider.dart';
import 'package:aliens/providers/auth_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

Widget settingWidget(BuildContext context, memberDetails) {
  final AuthProvider authProvider = new AuthProvider();
  final storage = FlutterSecureStorage();
  final double screenWidth = MediaQuery.of(context).size.width;
  final bool isSmallScreen = screenWidth <= 600;


  File imageFile = File(memberDetails['profileImage']);

  return Column(
    children: [
      Expanded(
        child: Container(
          padding: EdgeInsets.only(right: 20,left: 20, top: 17,bottom: 17),
            decoration: BoxDecoration(
            color: Color(0xff7898FF),
            borderRadius: BorderRadius.circular(20),
          ),

          width: MediaQuery.of(context).size.width * 0.87,
          height: isSmallScreen? MediaQuery.of(context).size.height * 0.3:MediaQuery.of(context).size.height * 0.15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(memberDetails['name'].toString()+'님'),
                  Text(memberDetails['birthday'].toString(), style: TextStyle(
                    fontSize: isSmallScreen?12:14
                  ),),
                  Text(memberDetails['email'].toString(), style: TextStyle(
                      fontSize: isSmallScreen?12:14)
                  )
                ],
              ),
              Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.09,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40)),
                      child:imageFile.existsSync()
                          ? Image.file(imageFile)
                          : SvgPicture.asset('assets/icon/icon_profile.svg', color: Color(0xffA8A8A8),),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.038,
                          width: 30,
                          child: FloatingActionButton(
                              backgroundColor: Colors.white,
                              onPressed: () {
                                Navigator.pushNamed(context, '/setting/edit',
                                    arguments: memberDetails);
                                },
                              child: SvgPicture.asset('assets/icon/icon_modify.svg',
                                height: MediaQuery.of(context).size.height * 0.019,
                                width: MediaQuery.of(context).size.width * 0.0415,
                                color: Color(0xff7898FF),)
                          ),
                        ))
                  ],
                ),
              )
            ],
          )
        ),
      ),
      Expanded(
        flex: 2,
        child: Container(
          decoration: BoxDecoration(
            //color: Colors.green.shade200
          ),
          child: ListView(
            children: [
              for (int i = 0; i < 3; i++)
                buildSettingList(context, i, memberDetails),
              Divider(),
              for (int i = 3; i < 6; i++)
                buildSettingList(context, i, memberDetails),
            ],
          ),
        ),
      ),
      Expanded(
          child: Container(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () async {
                //http 로그아웃 요청
                authProvider.logout(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1.0, color: Color(0xFF454545))),
                ),
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    color: Color(0xFF454545),
                    fontSize: isSmallScreen?12:14,
                  ),
                ),
              ),
            ),
          )),
    ],
  );
}

Widget buildSettingList(context, index, memberDetails) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final bool isSmallScreen = screenWidth <= 600;
  List settingList = [
    '이름',
    '생년월일',
    '이메일',
    '보안관리',
    '알림설정',
    '이용약관',
  ];

  List settingIcon = [
    null,
    null,
    null,
    Icon(
      Icons.lock_outline,
      size: isSmallScreen?18:20,
      color: Colors.black,
    ),
    Icon(
      Icons.notifications_none,
      size: isSmallScreen?18:20,
      color: Colors.black,
    ),
    Icon(
      Icons.assignment_outlined,
      size: isSmallScreen?18:20,
      color: Colors.black,
    ),
  ];

  List memberInfo = [
    memberDetails['name'].toString(),
    //birthday 값 추후 가공
    memberDetails['birthday'].toString(),
    memberDetails['email'].toString(),
  ];

  List navigatorList = [
    '/setting/security',
    '/setting/notification',
    '/setting/terms',
  ];

  return ListTile(
    minVerticalPadding: 23,
    onTap: () {
      if (index > 2)
        Navigator.pushNamed(context, navigatorList.elementAt(index - 3), arguments: memberDetails);
    },
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (index > 2)
          Container(
            padding: EdgeInsets.only(right: 20),
            child: settingIcon.elementAt(index),
          ),
        Text(
          '${settingList.elementAt(index)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen?14:16,
          ),
        ),
        Expanded(child: Container()),
        if (index < 3)
          Text(
            '${memberInfo.elementAt(index)}',
            style: TextStyle(
                fontSize: isSmallScreen?14:16, color: Color(0xff888888)),
          )
        else
          Icon(
            Icons.arrow_forward_ios,
            size: isSmallScreen?18:20,
            color: Color(0xff4d4d4d),
          ),
      ],
    ),
  );
}
