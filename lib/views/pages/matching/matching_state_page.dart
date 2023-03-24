import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MatchingStatePage extends StatefulWidget {
  const MatchingStatePage({super.key});

  @override
  State<MatchingStatePage> createState() => _MatchingStatePageState();
}

class _MatchingStatePageState extends State<MatchingStatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF4F4F4),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFF4F4F4),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              //아이콘 수정 필요
              icon: Icon(CupertinoIcons.question_circle),
              color: Colors.black,
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(flex: 1,child: Container()),
            Column(
              children: [
                Text(
                  '매칭 대기중...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 8,
                  width: 200,
                  decoration: BoxDecoration(color: Colors.white),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(90),
                  ),
                  width: 180,
                  height: 180,
                ),
                SizedBox(
                  height: 70,
                ),
                Text(
                  '조금만 기다려주세요.\n내 성향과 스타일에 꼭 맞는\n친구를 찾고 있어요!',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 70,
                ),
                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/info/my');
                  },
                  child: Container(
                    child: Text('버튼'),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text('위 버튼을 누르면 나의 접수 정보를 확인하고\n언어를 수정할 수 있어요.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB1B1B1),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Expanded(flex: 3,child: Container()),
          ],
        ));
  }
}
