import 'dart:async';

import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/board/fashion_board_page.dart';
import 'package:aliens/views/pages/board/food_board_page.dart';
import 'package:aliens/views/pages/board/free_posting_board_page.dart';
import 'package:aliens/views/pages/board/game_board_page.dart';
import 'package:aliens/views/pages/board/market_board_page.dart';
import 'package:aliens/views/pages/board/music_board_page.dart';
import 'package:aliens/views/pages/board/my_article_page.dart';
import 'package:aliens/views/pages/board/notice_board_page.dart';
import 'package:aliens/views/pages/board/notification_page.dart';
import 'package:aliens/views/pages/board/post_board_page.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../apis/apis.dart';
import '../../repository/sql_message_repository.dart';

class BoardDrawerWidget extends StatefulWidget {
  const BoardDrawerWidget({super.key, required this.screenArguments, required this.isTotalBoard});

  final ScreenArguments screenArguments;
  final bool isTotalBoard;

  @override
  State<StatefulWidget> createState() => _BoardDrawerWidgetState();
}

class _BoardDrawerWidgetState extends State<BoardDrawerWidget> {



  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Color(0xffEBEBEB),
      ),
      child: ListView(
        children: [
          InkWell(
            onTap: (){
              if(widget.isTotalBoard){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoticeBoardPage()),
                );
              }
              else{
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoticeBoardPage()),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '공지사항',
                    style: TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 0, thickness: 1,),
          InkWell(
            onTap: (){
              if(widget.isTotalBoard){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PostBoardPage()),
                );
              }
              else{
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PostBoardPage()),
                );
              }
          },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '글쓰기',
                    style: TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.edit,
                    color: Color(0xff888888),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 0, thickness: 1,),
          InkWell(
            onTap: (){
              if(widget.isTotalBoard){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyArticlePage()),
                );
              }
              else{
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyArticlePage()),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '나의 게시글',
                    style: TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.article_outlined,
                    color: Color(0xff888888),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 0, thickness: 1,),
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationBoardWidget()),
              );
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '알림',
                    style: TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.notifications_none,
                    color: Color(0xff888888),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 30, thickness: 0,),

          Container(
            height: 20,
            color: Colors.white,
          ),
          InkWell(

            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '전체 게시판',
                    style: TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 0, thickness: 1,),
          InkWell(
            onTap: (){
              if(widget.isTotalBoard){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FreePostingBoardPage(screenArguments: widget.screenArguments)),
                );
              }
              else{
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FreePostingBoardPage(screenArguments: widget.screenArguments)),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '자유 게시판',
                    style: TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 0, thickness: 1,),
          InkWell(
            onTap: (){
              if(widget.isTotalBoard){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MarketBoardPage()),
                );
              }
              else{
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MarketBoardPage()),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '장터 게시판',
                    style: TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 0, thickness: 1,),
          InkWell(
            onTap: (){
              if(widget.isTotalBoard){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GameBoardPage(screenArguments: widget.screenArguments,)),
                );
              }
              else{
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GameBoardPage(screenArguments: widget.screenArguments,)),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '게임 게시판',
                    style: TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 0, thickness: 1,),
          InkWell(
            onTap: (){
              if(widget.isTotalBoard){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FashionBoardPage(screenArguments: widget.screenArguments,)),
                );
              }
              else{
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FashionBoardPage(screenArguments: widget.screenArguments,)),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '패션 게시판',
                    style: TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 0, thickness: 1,),
          InkWell(
            onTap: (){
              if(widget.isTotalBoard){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FoodBoardPage(screenArguments: widget.screenArguments,)),
                );
              }
              else{
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FoodBoardPage(screenArguments: widget.screenArguments,)),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '음식 게시판',
                    style: TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 0, thickness: 1,),
          InkWell(
            onTap: (){
              if(widget.isTotalBoard){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MusicBoardPage(screenArguments: widget.screenArguments,)),
                );
              }
              else{
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MusicBoardPage(screenArguments: widget.screenArguments,)),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '음악 게시판',
                    style: TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 0, thickness: 1,),
          InkWell(
            onTap: (){
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '정보 게시판',
                    style: TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
