import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MatchingChoosePage extends StatefulWidget {
  const MatchingChoosePage({super.key});

  @override
  State<MatchingChoosePage> createState() => _MatchingChoosePageState();
}

class _MatchingChoosePageState extends State<MatchingChoosePage> {
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
                  '매칭 선호 언어 선택',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '상대방과 원하는 언어로 대화할 수 있어요.\n선호도에 따라 두가지 언어로 선택 가능합니다.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        languageButton(),
                        SizedBox(
                          width: 20,
                        ),
                        languageButton(),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        languageButton(),
                        SizedBox(
                          width: 20,
                        ),
                        languageButton(),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/apply/done');
                  },
                  child: Container(
                    child: Text('버튼'),
                  ),
                )
              ],
            ),
            Expanded(flex: 2,child: Container()),
          ],
        ));
  }

  Widget languageButton() {
    return MaterialButton(
        height: 117,
        minWidth: 165,
        elevation: 3.0,
        highlightElevation: 1.0,
        onPressed: () {
          changeWidget();
          },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: Colors.white,
        textColor: Colors.black,
        child: Row(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 30,
                  width: 45,
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                  ),
                ),
                Text(
                  '한국어',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 45,
            ),
            Column(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
              ],
            ),
          ],
        ));
  }
  void changeWidget(){
    setState(() {

    });
  }
}
