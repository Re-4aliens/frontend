import 'dart:async';

import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/countries.dart';
import '../../components/article_widget.dart';
import '../../components/board_drawer_widget.dart';
import 'article_page.dart';

class FashionBoardPage extends StatefulWidget {
  const FashionBoardPage({super.key, required this.screenArguments});

  final ScreenArguments screenArguments;

  @override
  State<StatefulWidget> createState() => _FashionBoardPageState();
}

class _FashionBoardPageState extends State<FashionBoardPage> {
  bool isDrawerStart = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '패션 게시판',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          toolbarHeight: 56,
          elevation: 0,
          shadowColor: Colors.black26,
          backgroundColor: Color(0xff7898ff),
          leadingWidth: 100,
          leading: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset(
                      'assets/icon/icon_back.svg',
                      color: Colors.white,
                      width: 24,
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isDrawerStart = !isDrawerStart;
                      });
                    },
                    icon: Icon(Icons.format_list_bulleted_outlined),
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          ],
        ),
        body: isDrawerStart
            ? BoardDrawerWidget(
                screenArguments: widget.screenArguments,
                isTotalBoard: false,
              )
            : Container(
                decoration: BoxDecoration(color: Colors.white),
                child: ListView.builder(
                    itemCount: fashionBoardList.length,
                    itemBuilder: (context, index) {

                      var nationCode = '';
                      for (Map<String, String> country in countries) {
                        if (country['name'] == fashionBoardList[index].member!.nationality.toString()) {
                          nationCode = country['code']!;
                          break;
                        }
                      }
                      return Column(
                        children: [
                          ArticleWidget(board: fashionBoardList[index], nationCode: nationCode),
                          Divider(
                            thickness: 2,
                            color: Color(0xffE5EBFF),
                          )
                        ],
                      );
                    }),
              ));
  }
}
