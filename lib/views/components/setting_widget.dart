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

  return Container(
    color: Color(0xffF5F7FF),
    child: Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.only(right: 20,left: 20, top: 17,bottom: 17),
              decoration: BoxDecoration(
              color: Color(0xff7898FF),
              borderRadius: BorderRadius.circular(20),
            ),

            width: MediaQuery.of(context).size.width * 0.87,
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
                            : SvgPicture.asset('assets/icon/icon_profile.svg', color:Colors.white,),
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
        SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
        Expanded(
          flex: 5,
            child:
            Container(
              width: MediaQuery.of(context).size.width * 0.87,
              padding: EdgeInsets.only(right: 23, left: 23, top: 17, bottom: 17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                      child: Text(
                        '프로필 확인 및 수정',
                        style: TextStyle(
                          color: Color(0xffC1C1C1),
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                        child: buildProfileList(context, index - 1, memberDetails));
                  }
                },
              ),
            )
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
        Expanded(
            flex: 4,
            child: Container(
                width: MediaQuery.of(context).size.width * 0.87,
                //margin: EdgeInsets.only(right: 24, left: 24),
                padding: EdgeInsets.only(right: 20,left: 20, top: 17,bottom: 17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.03,
                    child: Text(
                      '계정관리',
                      style: TextStyle(
                        color: Color(0xffC1C1C1),
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  );
                } else {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: buildSettingList(context, index - 1, memberDetails));
                }
              },
            ),
            )
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
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
                        bottom: BorderSide(width: 1.0, color: Color(0xFF7898FF))),
                  ),
                  child: Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Color(0xFF7898FF),
                      fontSize: isSmallScreen?12:14,
                    ),
                  ),
                ),
              ),
            )),
      ],
    ),
  );
}

Widget buildProfileList(context, index, memberDetails) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final bool isSmallScreen = screenWidth <= 600;
  List settingList = [
    '성별',
    '국적',
    'MBTI',
    '언어 재설정',
  ];

  List settingIcon = [
    null,
    null,
    null,
    null,
  ];

  List memberInfo = [
    memberDetails['gender'].toString(),
    //birthday 값 추후 가공
    memberDetails['nationality'].toString(),
    memberDetails['mbti'].toString(),
  ];


  return ListTile(
    onTap: () {
      if (index > 2)
        Navigator.pushNamed(context, '/edit');
    },
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (index > 3)
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
                fontSize: isSmallScreen?16:18, color: Color(0xff888888)),
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

Widget buildSettingList(context, index, memberDetails) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final bool isSmallScreen = screenWidth <= 600;
  List settingList = [
    '보안관리',
    '알림설정',
    '이용약관',
  ];

  List settingIcon = [
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


  List navigatorList = [
    '/setting/security',
    '/setting/notification',
    '/setting/terms',
  ];

  return ListTile(
    onTap: () {
        Navigator.pushNamed(context, navigatorList.elementAt(index), arguments: memberDetails);
    },
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
          Container(
            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.04),
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
        Icon(
            Icons.arrow_forward_ios,
            size: isSmallScreen?18:20,
            color: Color(0xff4d4d4d),
          ),
      ],
    ),
  );
}