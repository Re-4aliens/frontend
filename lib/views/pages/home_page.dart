import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './matching/matching_page.dart';

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
      Text(
          '설정'
      ),
    ];


    final tapIndex = ModalRoute.of(context)!.settings.arguments;
    if(tapIndex != null) {
      selectedIndex = tapIndex as int;
    }


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
      body: _pageWidget.elementAt(selectedIndex),

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

