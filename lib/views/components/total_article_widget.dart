
import 'dart:async';
import 'package:aliens/apis/apis.dart';
import 'package:aliens/apis/apis.dart';
import 'package:aliens/models/message_model.dart';
import 'package:aliens/views/pages/board/article_writing_page.dart';
import 'package:aliens/views/pages/board/info_article_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../models/board_model.dart';
import '../../repository/board_provider.dart';
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

  String createdAt = '';
  String boardCategory = '';
  List<Board> articles = [];

  @override
  void initState() {
    super.initState();
    switch (widget.board.category){
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
      case '정보게시판':
        boardCategory = 'info'.tr();
        break;
      default:
    }

    fetchArticlesData();
  }

  Future<void> fetchArticlesData() async {
    try {
      final response = await APIs.TotalArticles(); // TotalArticles 함수 호출
      final dataList = response as List<dynamic>; // 변환된 리스트 데이터

      setState(() {
        print('1');
        articles = dataList.map((article) =>
            Board.fromJson(article)).toList();
        print('2');
      });
    } catch (error) {
      print('Error fetching article data: $error');
    }
  }


  @override


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: ListTile(
              //제목
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10, left: 10, right: 15)
                            .r,
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.spMin),
                              ),
                              Text(
                                '/',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.spMin),
                              ),
                              Text(
                                '${widget.nationCode}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.spMin),
                              )
                            ],
                          ),
                          Text(
                            '[${boardCategory}]',
                            style: TextStyle(
                                color: Color(0xff888888), fontSize: 12.spMin),
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
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (builder) {
                                return BoardDialog(
                                  context: context, board: widget.board,
                                );
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0).w,
                          child: SvgPicture.asset(
                            'assets/icon/ICON_more.svg',
                            width: 25.r,
                            height: 25.r,
                            color: Color(0xffc1c1c1),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),

              //내용
              subtitle: Container(
                padding: EdgeInsets.only(left: 10.w, bottom: 10.h,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10).h,
                      child: Text(
                        '${widget.board.title}',
                        style: TextStyle(
                            fontSize: 14.spMin,
                            color: Color(0xff444444),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    widget.board.images == null
                        ? SizedBox()
                        : Container(
                      height: 90.h,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.board.images!.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10).w,
                                  height: 80.h,
                                  width: 80.h,
                                  decoration: BoxDecoration(
                                      color: Color(0xfff8f8f8),
                                      borderRadius:
                                      BorderRadius.circular(10)),
                                  padding: const EdgeInsets.all(25.0).r,
                                  child: Image.asset(
                                      'assets/icon/ICON_photo_1.png'),
                                ),
                              ],
                            );
                          }),
                    ),
                    widget.board.category == "정보게시판" ? SizedBox(height: 10.h,):
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 15.0).h,
                      child: Text(
                        '${widget.board.content}',
                        style: TextStyle(
                            fontSize: 14.spMin, color: Color(0xff616161)),
                      ),
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
                              : Text('${widget.board.likeCount}'),
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
                          child: Text('${widget.board.commentsCount}'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              onTap: () {
                if (widget.board.category == "정보게시판") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            InfoArticlePage(board: widget.board)),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ArticlePage(board: widget.board)),
                  );
                }
              },
            ),
          );

        }

    );
  }
}

