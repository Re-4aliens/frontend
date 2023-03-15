import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './matching/matching_page.dart';
import './setting/setting_page.dart';

import 'package:aliens/providers/member_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List _pageTitle = [
      '홈',
      '',
      '채팅',
      '설정',
    ];


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _pageTitle.elementAt(selectedIndex),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Color(0xFF737373),
        unselectedItemColor: Color(0xFFBDBDBD),
        onTap: (int index){
          setState(() {
            selectedIndex = index;
          });
        },
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

      body: _buildBodyWidget(context),
    );
  }

  Widget _buildBodyWidget(BuildContext context) {
    var memberDetails = Provider.of<MemberProvider>(context, listen: false);

    List _pageWidget = [
      Text(
          '홈'
      ),
      matchingWidget(context, memberDetails),
      Text(
          '채팅'
      ),
      settingWidget(context, memberDetails)
    ];

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
            //오류가 생기면 보여줄 위젯
            //미정
            return Container();
          }
          //데이터를 받아오면 보여줄 위젯
          else {
            return _pageWidget.elementAt(selectedIndex);
          }
        }
    );
  }

}

