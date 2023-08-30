
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

class ArticleWidget extends StatefulWidget {

  ArticleWidget({super.key, required this.board, required this.nationCode});

  final Board board;
  final String nationCode;
  @override
  State<StatefulWidget> createState() => _ArticleWidgetState();
}
class _ArticleWidgetState extends State<ArticleWidget>{

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
              child: Text(
                '${widget.board.member!.name}/${widget.nationCode}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.spMin),
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
                return BoardDialog(context: context,);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0).w,
              child:
              SvgPicture.asset(
                'assets/icon/ICON_more.svg',
                width: 25.r,
                height: 25.r,
                color: Color(0xffc1c1c1),
              ),
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
            if (widget.board.images!.isEmpty) SizedBox() else Container(
              height: 90.h,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.board.images!.length,
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
                          child:
                          Padding(
                            padding: const EdgeInsets.all(25.0).r,
                            child: Image.asset('assets/icon/ICON_photo_1.png'),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 15.0.h),
              child: Text('${widget.board.content}', style: TextStyle(fontSize: 14.spMin, color: Color(0xff616161)),),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0).r,
                  child: SvgPicture.asset(
                    'assets/icon/ICON_good.svg',
                    width: 25.r,
                    height: 25.r,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4, right: 15).w,
                  child: widget.board.likeCount == 0
                      ? Text('')
                      : Text(
                      '${widget.board.likeCount}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0).r,
                  child: SvgPicture.asset(
                    'assets/icon/icon_comment.svg',
                    width: 25.r,
                    height: 25.r,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0).r,
                  child: widget.board.commentsCount == 0
                      ? Text('')
                      : Text(
                      '${widget.board.commentsCount}'),
                ),
              ],
            )
          ],
        ),
      ),

      onTap: () {
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