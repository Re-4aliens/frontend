
import 'dart:async';
import 'package:aliens/apis/apis.dart';
import 'package:aliens/apis/apis.dart';
import 'package:aliens/models/market_articles.dart';
import 'package:aliens/models/memberDetails_model.dart';
import 'package:aliens/models/message_model.dart';
import 'package:aliens/models/screenArgument.dart';
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
import '../../providers/bookmarks_provider.dart';
import '../../repository/board_provider.dart';
import '../pages/board/article_page.dart';
import '../pages/board/market_board_page.dart';
import '../pages/board/market_detail_page.dart';
import 'board_dialog_widget.dart';

class TotalArticleWidget extends StatefulWidget {


  TotalArticleWidget({super.key, required this.board, required this.nationCode, required this.screenArguments, required this.index, this.marketBoard});

  final Board board;
  final String nationCode;
  final ScreenArguments screenArguments;
  final MarketBoard? marketBoard;
  final int index;
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
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    final bookmarkProvider = Provider.of<BookmarksProvider>(context, listen: false);

    boardProvider.getLikeCounts();
    bookmarkProvider.getbookmarksCounts(0);

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
      case '장터게시판':
        boardCategory = 'market'.tr();
        break;
      default:
    }

  }


  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    final bookmarkProvider = Provider.of<BookmarksProvider>(context);
    return Padding(
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
                            context: context, board: widget.board, memberDetails: widget.screenArguments.memberDetails!,boardCategory: "전체게시판",
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
              widget.board.imageUrls!.isEmpty
                  ? SizedBox()
                  : Container(
                height: 90.h,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.board.imageUrls!.length,
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
                                BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(widget.board.imageUrls![index]!),
                                fit: BoxFit.cover,
                              )
                            ),
                            padding: const EdgeInsets.all(25.0).r,
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
                  InkWell(
                    onTap: () async {
                      if(widget.board.category != "장터게시판"){
                        boardProvider.addLike(widget.board.articleId!, widget.index);
                      }else{
                        boardProvider.likeCounts[widget.index] = await APIs.marketbookmark(widget.board.articleId!, widget.index);
                      }
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0).r,
                      child: SvgPicture.asset(
                        'assets/icon/ICON_good.svg',
                        width: 30.r,
                        height: 30.r,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4, right: 15).w,
                    child:
                      boardProvider.likeCounts![widget.index] == 0 || boardProvider.likeCounts == null? Text('') : Text('${boardProvider.likeCounts![widget.index]}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0).r,
                    child: SvgPicture.asset(
                      'assets/icon/icon_comment.svg',
                      width: 30.r,
                      height: 30.r,
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
          if (widget.board.category == "정보게시판") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      InfoArticlePage(board: widget.board)),
            );
          } else if(widget.board.category == "장터게시판"){
            showDialog(
                context: context,
                builder: (_) => FutureBuilder(
                    future: APIs.getMarketArticle(widget.board.articleId!),
                    builder: (BuildContext context,
                        AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        //받아오는 동안
                        return Container(
                            child: Image(
                                image: AssetImage(
                                    "assets/illustration/loading_01.gif")));
                      } else{
                        MarketBoard data = snapshot.data;
                        //받아온 후
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          Navigator.pop(context);
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MarketDetailPage(screenArguments: widget.screenArguments, marketBoard: data,
                            productStatus: getProductStatusText(data.productStatus),
                            StatusText: getStatusText(data.marketArticleStatus),

                            index: -1, backPage: '',)),
                        ).then((value) =>
                              boardProvider.getAllArticles());
                        });
                        return Container(
                            child: Image(
                                image: AssetImage(
                                    "assets/illustration/loading_01.gif")));
                      }

                    }));
          }else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticlePage(board: widget.board, memberDetails: widget.screenArguments.memberDetails!, index: widget.index,)),
            );
          }
        },
      ),
    );
  }
  String getProductStatusText(String? productStatus) {
    List<String> whatStatus = [
      'Brand_New'.tr(),
      'Almost_New'.tr(),
      'Slight_Defect'.tr(),
      'Used'.tr(),
    ];

    switch (productStatus) {
      case '새 것':
        return whatStatus[0];
      case '거의 새 것':
        return whatStatus[1];
      case '약간의 하자':
        return whatStatus[2];
      case '사용감 있음':
        return whatStatus[3];
      default:
        return '';
    }
  }

  String getStatusText(String? marketArticleStatus){
    List<String> Status = [
      'sale'.tr(),
      'sold-out'.tr(),
    ];

    switch (marketArticleStatus) {
      case '판매 중':
        return Status[0];
      case '판매 완료':
        return Status[1];
      default:
        return '';
    }
  }

}
