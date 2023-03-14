import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:aliens/providers/member_provider.dart';
import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/member_model.dart';

import 'package:provider/provider.dart';


Widget settingWidget(BuildContext context) {
  var memberDetails = Provider.of<MemberProvider>(context, listen: false);

  return FutureBuilder(
      future: memberDetails.memberInfo(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //데이터를 받아오기 전 보여줄 위젯
        if (snapshot.hasData == false) {
          //로딩 화면으로 수정
          return Text('불러오는 중');
        }
        //오류가 생기면 보여줄 위젯
        else if (snapshot.hasError) {
          //오류가 생기면 보여줄 위젯 미정
          return Container();
        }
        //데이터를 받아오면 보여줄 위젯
        else {
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
                                onPressed: () {},
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
                      for (int i = 0; i < 3; i++) buildSettingList(i, memberDetails),
                      Divider(),
                      for (int i = 3; i < 6; i++) buildSettingList(i, memberDetails),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1.0, color: Color(0xFF454545))),
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
      });
}

Widget buildSettingList(index, memberDetails) {
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

  return ListTile(
    minVerticalPadding: 23,
    onTap: () {},
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
            color: Colors.black,
          ),
      ],
    ),
  );
}
