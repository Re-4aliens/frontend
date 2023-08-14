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

import '../../../models/board_model.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key, required this.board, required this.boardCategory});
  final Board board;
  final String boardCategory;

  @override
  State<StatefulWidget> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.boardCategory}'),
          backgroundColor: Color(0xff7898ff),
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
        ));
  }
}
