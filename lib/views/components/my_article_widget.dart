
import 'dart:async';

import 'package:aliens/models/memberDetails_model.dart';
import 'package:aliens/models/message_model.dart';
import 'package:aliens/views/pages/board/article_writing_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/board_model.dart';
import '../pages/board/article_page.dart';
import 'board_dialog_widget.dart';

class MyArticleWidget extends StatefulWidget {

  MyArticleWidget({super.key, required this.board, required this.nationCode, required this.memberDetails});

  final Board board;
  final String nationCode;
  final MemberDetails memberDetails;
  @override
  State<StatefulWidget> createState() => _MyArticleWidgetState();
}
class _MyArticleWidgetState extends State<MyArticleWidget>{

  String createdAt = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return ListTile(
      //제목
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 10, right: 15).r,
            child: SvgPicture.asset(
              'assets/icon/icon_profile.svg',
              width: 34.r,
              color: Color(0xff7898ff),
            ),
          ),
          Flexible(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.board.member!.name}/${widget.nationCode}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.spMin),
                  ),
                  Text(
                    '[${widget.board.category}]',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12.spMin,
                      color: Color(0xff888888)
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            DataUtils.getTime(widget.board.createdAt),
            style: TextStyle(
                fontSize: 16.spMin, color: Color(0xffc1c1c1)),
          ),
          InkWell(
            onTap: (){
              showDialog(context: context, builder: (builder){
                return BoardDialog(context: context, board: widget.board, memberDetails: widget.memberDetails,);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0).w,
              child:
              Icon(Icons.more_vert, color: Color(0xffc1c1c1)),
            ),
          )
        ],
      ),

      //내용
      subtitle: Container(
        padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8).h,
              child: Text('${widget.board.title}', style: TextStyle(fontSize: 14.spMin, color: Color(0xff444444), fontWeight: FontWeight.bold)),
            ),
            widget.board.imageUrls!.isEmpty ?
            SizedBox():
            Container(
              height: 90.h,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.board.imageUrls!.length,
                  itemBuilder: (context, index){
                    return Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10).w,
                          height: 80.h,
                          width: 80.h,
                          decoration: BoxDecoration(
                              color: Color(0xfff8f8f8),
                              borderRadius: BorderRadius.circular(10).r
                          ),
                          child: Icon(Icons.add_photo_alternate_outlined),
                        ),
                      ],
                    );
                  }),
            ),

          ],
        ),
      ),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArticlePage(board: widget.board, memberDetails: widget.memberDetails, index: 0 )), //수정필요
        );
      },
    );
  }
}