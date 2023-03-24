import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/matching_widget.dart';
import '../components/setting_widget.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    List<Object?> args = ModalRoute.of(context)?.settings.arguments as List<Object?>;
    //selectedIndex = args[0] as int;

    List _pageTitle = [
      '홈',
      '',
      '채팅',
      '설정',
    ];

    List _pageWidget = [
      Text('홈'),
      matchingWidget(context, args[1]),
      Text(
          '채팅'
      ),
      settingWidget(context, args[1])
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {

            },
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
            if(index == 0)
              Navigator.pop(context);
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

