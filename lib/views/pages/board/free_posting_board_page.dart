import 'dart:async';

import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class FreePostingBoardPage extends StatefulWidget {
  const FreePostingBoardPage({super.key});


  @override
  State<StatefulWidget> createState() => _FreePostingBoardPageState();
}

class _FreePostingBoardPageState extends State<FreePostingBoardPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text('자유 게시판'),
      ),
    );
  }


}
