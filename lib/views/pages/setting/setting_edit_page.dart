import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:aliens/providers/member_provider.dart';
import 'package:aliens/models/member_model.dart';

import 'package:provider/provider.dart';

/*
  (context)=> ChangeNotifierProvider(create: (context) => MemberProvider(), child: SettingPage()),
*/

class SettingEditPage extends StatefulWidget {
  const SettingEditPage({super.key});

  @override
  State<SettingEditPage> createState() => _SettingEditPageState();
}

class _SettingEditPageState extends State<SettingEditPage> {
  Member member = new Member();

  Widget showMemberInfo() {
    var memberDetails = Provider.of<MemberProvider>(context, listen: false);
    return FutureBuilder(
      future: memberDetails.memberInfo(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //데이터를 받아오기 전 보여줄 위젯
        if (snapshot.hasData == false) {
          return Text('...');
        }
        //오류가 생기면 보여줄 위젯
        else if (snapshot.hasError) {
          //오류가 생기면 보여줄 위젯 미정
          return Container();
        }
        //데이터를 받아오면 보여줄 위젯
        else {
          return Container(
            child: Column(
              children: [
                //Image.network(memberDetails.member.profileImage.toString()),
                Text(memberDetails.member.mbti.toString()),
                Text(memberDetails.member.gender.toString()),
                Text(memberDetails.member.nationality.toString())
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('setting'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 50, right: 50),
              child: showMemberInfo(),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
