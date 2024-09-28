import 'package:aliens/services/market_service.dart';
import 'package:aliens/models/message_model.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/views/pages/board/info_article_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/board_model.dart';
import '../../models/market_board_model.dart';
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

  String getCategoryValue(category) {
    switch (widget.board.category) {
      case 'FREE':
        return 'free-posting'.tr();
      case 'FOOD':
        return 'food'.tr();
      case 'MUSIC':
        return 'music'.tr();
      case 'FASHION':
        return 'fashion'.tr();
      case 'GAME':
        return 'game'.tr();
      case 'INFO':
        return 'info'.tr();
      case 'MARKET':
        return 'market'.tr();
      default:
        return category;
    }
  }

  @override
  void initState() {
    super.initState();

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
      padding: EdgeInsets.only(top: 5.h, left: 20.w, right: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15).r,
                    child: widget.board.memberProfileDto == null
                        ? SvgPicture.asset(
                            'assets/icon/icon_profile.svg',
                            width: 30.r,
                            color: const Color(0xff7898ff),
                          )
                        : Container(
                            height: 30.r,
                            width: 30.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(widget
                                    .board.memberProfileDto!.profileImageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
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
                            widget.nationCode,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.spMin),
                          )
                        ],
                      ),
                      Text(
                        '[${getCategoryValue(widget.board.category)}]',
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
                                  widget.screenArguments.memberDetails,
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

          // 내용 영역
          Padding(
            padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
            child: Column(
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
          GestureDetector(
            onTap: () {
              if (widget.board.category == "INFO") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          InfoArticlePage(board: widget.board)),
                );
              } else if (widget.board.category == "MARKET") {
                showDialog(
                    context: context,
                    builder: (_) => FutureBuilder(
                        future:
                            MarketService.getMarketArticle(widget.board.id!),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            MarketBoard data = snapshot.data;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MarketDetailPage(
                                          screenArguments:
                                              widget.screenArguments,
                                          marketBoard: data,
                                          index: -1,
                                          backPage: '',
                                        )),
                              );
                            });
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ArticlePage(
                            board: widget.board,
                            memberDetails: widget.screenArguments.memberDetails,
                            index: widget.index,
                          )),
                );
              }
            },
            child: Container(), // 탭이 가능한 영역 설정
          ),
        ],
      ),
    );
  }
}
