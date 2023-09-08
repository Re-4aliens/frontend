import 'dart:async';

import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/memberDetails_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/providers/comment_provider.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../apis/apis.dart';
import '../../../mockdatas/comment_mockdata.dart';
import '../../../models/comment_model.dart';
import '../../../models/board_model.dart';
import '../../../models/countries.dart';
import 'package:flutter/services.dart';

import '../../../models/message_model.dart';
import '../../../repository/board_provider.dart';
import '../../components/board_dialog_widget.dart';
import '../../components/comment_dialog_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage(
      {super.key, required this.screenArguments, required this.category});

  final ScreenArguments screenArguments;
  final String category;

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  var _keyword = '';
  String boardCategory = '';


  void updateUi() async {
    setState(() {
      //텍스트폼 비우기
      _controller.clear();
      _keyword = '';
    });
    FocusScope.of(context).unfocus();
  }


  @override
  void initState() {
    switch (widget.category){
      case '자유게시판':
        boardCategory = 'free-posting'.tr();
        break;
      case '음식게시판':
        boardCategory = 'food'.tr();
        break;
      case '음악게시판':
        boardCategory = 'music'.tr();
        break;
      case '패션게시판':
        boardCategory = 'fashion'.tr();
        break;
      case '게임게시판':
        boardCategory = 'game'.tr();
        break;
      default:
    }

  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<CommentProvider>(context);
    final boardProvider = Provider.of<BoardProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(boardCategory, style: TextStyle(fontSize: 18.spMin),),
          backgroundColor: Color(0xff7898ff),
          elevation: 0,
        ),
        body: Column(
            children: [

        ]),
      );
  }
}
