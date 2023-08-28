
import 'dart:async';

import 'package:aliens/models/message_model.dart';
import 'package:aliens/views/pages/board/article_writing_page.dart';
import 'package:aliens/views/pages/board/info_article_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/board_model.dart';
import '../pages/board/article_page.dart';
import 'board_dialog_widget.dart';

class TotalArticleWidget extends StatefulWidget {

  TotalArticleWidget({super.key, required this.board, required this.nationCode});

  final Board board;
  final String nationCode;
  @override
  State<StatefulWidget> createState() => _TotalArticleWidgetState();
}
class _TotalArticleWidgetState extends State<TotalArticleWidget>{
  List<Map<String, dynamic>> articles = []; // 전체 게시글 데이터 저장

  String createdAt = '';
  String boardCategory = '';

  @override
  void initState() {
    super.initState();
    APIs.TotalArticles();

  }

  @override
  Widget build(BuildContext context) {

    return ListTile(
      //제목
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 10, right: 15).r,
                child: SvgPicture.asset(
                  'assets/icon/icon_profile.svg',
                  width: 35.r,
                  color: Color(0xff7898ff),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        '${widget.board.member!.name}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.spMin),
                      ),
                      Text(
                        '/',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.spMin),
                      ),
                      Text(
                        '${widget.nationCode}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.spMin),
                      )
                    ],
                  ),
                  Text(
                    '[${boardCategory}]',
                    style: TextStyle(color: Color(0xff888888), fontSize: 12.spMin),
                  )
                ],
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  Icon(Icons.more_vert, color: Color(0xffc1c1c1)),
                ),
              )
            ],
          ),
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
              child: Text('${widget.board.title}', style: TextStyle(fontSize: 14.spMin, color: Color(0xff444444), fontWeight: FontWeight.bold),),
            ),
            widget.board.imageUrls == null ?
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
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Icon(Icons.add_photo_alternate_outlined),
                        ),
                      ],
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15.0).h,
              child: Text('${widget.board.content}', style: TextStyle(fontSize: 14.spMin, color: Color(0xff616161)),),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0).r,
                  child: Icon(
                    Icons.thumb_up_alt_sharp,
                    color: Color(0xffc1c1c1),
                    size: 20.r,
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
                  child: Icon(
                    Icons.chat_bubble,
                    color: Color(0xffc1c1c1),
                    size: 20.r,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0).r,
                  child: Text(
                      '${widget.board.commentCount}'),
                ),
              ],
            )
          ],
        ),
      ),

      onTap: () {

        if(widget.board.category == "정보게시판"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InfoArticlePage(board: widget.board)),
          );
        }
        else{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ArticlePage(board: widget.board)),
          );
        }
      },
    );
  }
}