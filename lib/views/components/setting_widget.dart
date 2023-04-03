import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:aliens/providers/member_provider.dart';
import 'package:aliens/providers/auth_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:provider/provider.dart';

Widget settingWidget(BuildContext context, memberDetails) {
  final AuthProvider authProvider = new AuthProvider();
  final storage = FlutterSecureStorage();

  return Column(
    children: [
      Expanded(
        child: Container(
          child: Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Color(0xffA8A8A8),
                      borderRadius: BorderRadius.circular(40)),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 30,
                      width: 30,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, '/setting/edit',
                              arguments: memberDetails);
                        },
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
      Expanded(
        flex: 4,
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
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )),
    ],
  );
}

Widget buildSettingList(context, index, memberDetails) {
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
      size: 20,
      color: Colors.black,
    ),
    Icon(
      Icons.notifications_none,
      size: 20,
      color: Colors.black,
    ),
    Icon(
      Icons.assignment_outlined,
      size: 20,
      color: Colors.black,
    ),
  ];

  List memberInfo = [
    memberDetails.member.name.toString(),
    //birthday 값 추후 가공
    memberDetails.member.birthday.toString(),
    memberDetails.member.email.toString(),
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
            fontSize: 16,
          ),
        ),
        Expanded(child: Container()),
        if (index < 3)
          Text(
            '${memberInfo.elementAt(index)}',
            style: TextStyle(fontSize: 16, color: Color(0xff717171)),
          )
        else
          Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: Color(0xff4d4d4d),
          ),
      ],
    ),
  );
}
