import 'dart:async';

import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/comment_repository.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../mockdatas/comment_mockdata.dart';
import '../../../models/comment_model.dart';
import '../../../models/board_model.dart';
import '../../../models/countries.dart';
import 'package:flutter/services.dart';

import '../../../models/message_model.dart';
import '../../components/board_dialog_widget.dart';
import '../../components/comment_dialog_widget.dart';

class InfoArticlePage extends StatefulWidget {
  const InfoArticlePage(
      {super.key, required this.board});

  final Board board;

  @override
  State<StatefulWidget> createState() => _InfoArticlePageState();
}

class _InfoArticlePageState extends State<InfoArticlePage> {


  String getNationCode(_nationality){
    var nationCode = '';
    for (Map<String, String> country in countries) {
      if (country['name'] == _nationality) {
        nationCode = country['code']!;
        break;
      }
    }
    return nationCode;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('info'.tr(), style: TextStyle(fontSize: 16.sp),),
          backgroundColor: Color(0xff7898ff),
          elevation: 0,
        ),
        body:SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0).h,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 15).w,
                          child: Icon(Icons.campaign, color: Color(0xff7898ff),),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text("${widget.board.title}", style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold
                          ),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ]
                    ),
                  ),
                  Divider(color: Color(0xffF5F7FF), thickness: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20.w , top: 25.0.h),
                        child: Text(DataUtils.getTime(widget.board.createdAt), style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xff888888)
                        ),),
                      )
                    ],
                  ),
                  widget.board.imageUrls == null
                      ? SizedBox()
                      : Container(
                    height: 100.h,
                    padding: const EdgeInsets.only(left: 20.0, right: 15).w,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.board.imageUrls!.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10.w),
                                height: 80.h,
                                width: 80.h,
                                decoration: BoxDecoration(
                                    color: Color(0xfff8f8f8),
                                    borderRadius:
                                    BorderRadius.circular(10).r),
                                child: Icon(Icons
                                    .add_photo_alternate_outlined),
                              ),
                            ],
                          );
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("${widget.board.content}", style: TextStyle(
                        fontSize: 16.sp,
                    ),),
                  ),
                ],
              ),
            ),
      );
  }
}
