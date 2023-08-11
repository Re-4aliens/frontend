import 'dart:async';

import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class MusicBoardPage extends StatefulWidget {
  const MusicBoardPage({super.key});


  @override
  State<StatefulWidget> createState() => _MusicBoardPageState();
}

class _MusicBoardPageState extends State<MusicBoardPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text('음악 게시판'),
      ),
    );
  }


}
