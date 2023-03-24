import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MatchingPage extends StatefulWidget {
  const MatchingPage({super.key});

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
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
      body: Stack(
        children: [
          //배경 디자인
          /*
          Expanded(child: Container(
            decoration: BoxDecoration(color: Colors.white),
          ),),
           */

          //버튼
          Center(

            child: Container(
              //alignment: Alignment.center,
              height: 245,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/apply');
                    },
                    child: Container(
                      margin:
                          EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow:[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), //color of shadow
                            spreadRadius: 0, //spread radius
                            blurRadius: 10, // blur radius
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      width: 165,
                      height: 245,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(54),
                            ),
                            width: 108,
                            height: 108,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text('매칭 신청',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),),
                        ],
                      ),
                    ),
                  ),

                   */
                  buildButton('매칭 신청', '/apply'),
                  SizedBox(
                    width: 20,
                  ),

                  buildButton('현재 진행 상황', '/done'),
                ],
              ),
            ),
          ),
          //글
          Container(
            padding: EdgeInsets.all(25),
            //decoration: BoxDecoration(color: Colors.green.shade500),
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('매칭하기',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 10,),

                Text('내 성향과 스타일을 분석해',
                  style: TextStyle(
                  fontSize: 16,
                ),),
                SizedBox(height: 5,),
                Text('나와 잘 맞는 친구를 소개해드려요',
                  style: TextStyle(
                    fontSize: 16,
                  ),),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Color(0xFF737373),
        unselectedItemColor: Color(0xFFBDBDBD),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '매칭',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          )
        ],
      ),
    );
  }
  Widget buildButton(String _title, String _path){
    return MaterialButton(
        minWidth: 165,
        height: 245,

        elevation: 3.0,
        highlightElevation: 1.0,
        onPressed: () {
          Navigator.pushNamed(context, _path);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: Colors.white,
        textColor: Colors.black,
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(54),
            ),
            width: 108,
            height: 108,
          ),
          SizedBox(
            height: 40,
          ),
          Text(_title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),),
        ],
      ),
    );
  }
}

