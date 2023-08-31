
import 'dart:async';

import 'package:aliens/models/message_model.dart';
import 'package:aliens/views/pages/board/article_writing_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/board_model.dart';
import '../pages/board/article_page.dart';
import '../pages/board/info_article_page.dart';
import 'board_dialog_widget.dart';

class NoticeWidget extends StatefulWidget {

  NoticeWidget({super.key, required this.board, required this.nationCode});

  final Board board;
  final String nationCode;
  @override
  State<StatefulWidget> createState() => _NoticeWidgetState();
}
class _NoticeWidgetState extends State<NoticeWidget>{

  String createdAt = '';
  bool isRead = false; //읽으면 true로 변하는 변수

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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 10, right: 15).r,
                child: SvgPicture.asset(
                  'assets/icon/icon_profile.svg',
                  width: 34.r,
                  color: Color(0xff7898ff),
                ),
              ),
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      '${widget.board.member!.name}/${widget.nationCode}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.spMin),
                    ),
                  ),

                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(right: 10),
                      child: Text('[${widget.board.category}]', style: TextStyle(fontSize: 12.spMin, color: Color(0xff888888)),))

                ],
              ),
            ],
          ),
          Flexible(
            child: Text(
              DataUtils.getTime(widget.board.createdAt),
              style: TextStyle(
                  fontSize: 16.spMin, color: Color(0xffc1c1c1)),
            ),
          ),

        ],
      ),

      //내용
      subtitle: Container(
        padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8).h,
              child: Text('${widget.board.content}', style: TextStyle(fontSize: 14.spMin, color: Color(0xff444444), fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
              width: 19.0,
              height: 19.0,
              decoration: isRead ? BoxDecoration() : BoxDecoration(
                color: Color(0xFFFFE68D),
                shape: BoxShape.circle,
              ),
            )
          ],
        ),
      ),

      onTap: () {
        setState(() {
          isRead = true;
        });
        widget.board.category == "정보게시판"?
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InfoArticlePage(board: widget.board)),
        ):Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArticlePage(board: widget.board)),
        );

      },

    );
  }
}