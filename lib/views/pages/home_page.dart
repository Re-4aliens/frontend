import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './matching/matching_page.dart';
import './setting/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List _pageWidget = [
      Text(
          '홈'
      ),
      matchingWidget(context),
      Text(
          '채팅'
      ),
      settingWidget(context)
    ];


    List _pageTitle = [
      Text('홈',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),),
      Text(''),
      Text('채팅',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),),
      Text('설정',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),),
    ];

    Widget _titleSetting(int index){

      return _pageTitle.elementAt(index);
    }


    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: _pageTitle.elementAt(selectedIndex),
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
      body: _pageWidget.elementAt(selectedIndex),
    );
  }

}

