import 'dart:async';

import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class GameBoardPage extends StatefulWidget {
  const GameBoardPage({super.key});


  @override
  State<StatefulWidget> createState() => _GameBoardPageState();
}

class _GameBoardPageState extends State<GameBoardPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text('게임 게시판'),
      ),
    );
  }


}
