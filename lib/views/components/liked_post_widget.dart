import 'package:aliens/services/market_service.dart';
import 'package:aliens/models/message_model.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/views/pages/board/info_article_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/board_model.dart';
import '../../models/market_articles.dart';
import '../pages/board/article_page.dart';
import '../pages/board/market_detail_page.dart';
import 'board_dialog_widget.dart';
import 'package:aliens/services/user_service.dart';

class LikedArticleWidget extends StatefulWidget {
  const LikedArticleWidget(
      {super.key,
      required this.board,
      required this.nationCode,
      required this.screenArguments,
      required this.index});

  final Board board;
  final String nationCode;
  final ScreenArguments screenArguments;
  final int index;
  @override
  State<StatefulWidget> createState() => _LikedArticleWidgetWidgetState();
}

class _LikedArticleWidgetWidgetState extends State<LikedArticleWidget> {
  String createdAt = '';
  String boardCategory = '';
  List<Board> articles = [];
  String? email;

  @override
  void initState() {
    super.initState();
    switch (widget.board.category) {
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
    initialize();
  }

  void initialize() async {
    final userEmail = await UserService.fetchUserEmail();

    setState(() {
      email = userEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    color: const Color(0xff7898ff),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.board.memberProfileDto?.name ?? '',
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
                          widget.nationCode,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.spMin),
                        )
                      ],
                    ),
                    Text(
                      '[$boardCategory]',
                      style: TextStyle(
                          color: const Color(0xff888888), fontSize: 12.spMin),
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
                      fontSize: 16.spMin, color: const Color(0xffc1c1c1)),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return BoardDialog(
                            board: widget.board,
                            memberDetails:
                                widget.screenArguments.memberDetails!,
                            boardCategory: "좋아하는 게시글",
                          );
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0).w,
                    child: SvgPicture.asset(
                      'assets/icon/ICON_more.svg',
                      width: 25.r,
                      height: 25.r,
                      color: const Color(0xffc1c1c1),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),

        //내용
        subtitle: Container(
          padding: EdgeInsets.only(
            left: 10.w,
            bottom: 10.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 10).h,
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: widget.board.memberProfileDto?.name,
                          style: TextStyle(
                              fontSize: 14.spMin,
                              color: const Color(0xff444444),
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: '님의 게시글에 좋아요를 눌렀습니다.',
                          style: TextStyle(
                              fontSize: 14.spMin,
                              color: const Color(0xff444444))),
                    ]),
                  )),
            ],
          ),
        ),
        onTap: () {
          print(widget.board.category);
          if (widget.board.category == "정보게시판") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InfoArticlePage(board: widget.board)),
            );
          } else if (widget.board.category == "장터게시판") {
            showDialog(
                context: context,
                builder: (_) => FutureBuilder(
                    future: MarketService.getMarketArticle(widget.board.id!),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        //받아오는 동안
                        return Container(
                            child: const Image(
                                image: AssetImage(
                                    "assets/illustration/loading_01.gif")));
                      } else {
                        MarketBoard data = snapshot.data;
                        //받아온 후
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MarketDetailPage(
                                      screenArguments: widget.screenArguments,
                                      marketBoard: data,
                                      productStatus: getProductStatusText(
                                          data.productStatus),
                                      StatusText: getStatusText(
                                          data.marketArticleStatus),
                                      index: -1,
                                      backPage: '',
                                    )),
                          );
                        });
                        return Container(
                            child: const Image(
                                image: AssetImage(
                                    "assets/illustration/loading_01.gif")));
                      }
                    }));
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticlePage(
                        board: widget.board,
                        memberDetails: widget.screenArguments.memberDetails!,
                        index: widget.index,
                      )),
            );
          }
        },
      ),
    );
  }
}
