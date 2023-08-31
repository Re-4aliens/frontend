import 'dart:async';

import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/countries.dart';
import '../../components/article_widget.dart';
import '../../components/board_drawer_widget.dart';
import '../../components/info_article_widget.dart';
import '../../components/my_article_widget.dart';
import 'article_page.dart';
import 'article_writing_page.dart';


class NotificationBoardWidget extends StatefulWidget {
  const NotificationBoardWidget({super.key, required this.screenArguments});
  final ScreenArguments screenArguments;


  @override
  State<StatefulWidget> createState() => _NotificationBoardWidgetState();
}

class _NotificationBoardWidgetState extends State<NotificationBoardWidget> {
  bool isDrawerStart = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'notice'.tr(),
            style: TextStyle(
              fontSize: 16.spMin,
              color: Colors.white,
            ),
          ),
          toolbarHeight: 56.spMin,
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
                      height: 18.h,
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
            IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none, size: 30.h,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.search, size: 30.h,)),
          ],
        ),
        body: isDrawerStart ?
        BoardDrawerWidget(screenArguments: widget.screenArguments, isTotalBoard: false,
          onpressd: (){},)
            :Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 21.w, right: 21.w, top: 27.h, bottom: 27.h),
                child: Text('notice'.tr(),
                  style: TextStyle(
                      fontSize: 18.spMin,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Divider(height: 1.h,color: Color(0xffcecece),),

            ],
          ),

        )
    );
  }
}
