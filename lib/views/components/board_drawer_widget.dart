import 'package:aliens/models/member_details_model.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/views/pages/board/article_writing_page.dart';
import 'package:aliens/views/pages/board/fashion_board_page.dart';
import 'package:aliens/views/pages/board/food_board_page.dart';
import 'package:aliens/views/pages/board/free_posting_board_page.dart';
import 'package:aliens/views/pages/board/game_board_page.dart';
import 'package:aliens/views/pages/board/info_board_page.dart';
import 'package:aliens/views/pages/board/market_board_page.dart';
import 'package:aliens/views/pages/board/music_board_page.dart';
import 'package:aliens/views/pages/board/my_article_page.dart';
import 'package:aliens/views/pages/board/notice_board_page.dart';
import 'package:aliens/views/pages/board/notification_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/market_articles.dart';
import '../pages/board/market_posting_board_page.dart';

class BoardDrawerWidget extends StatefulWidget {
  const BoardDrawerWidget(
      {super.key,
      required this.screenArguments,
      required this.isTotalBoard,
      required this.onpressd,
      this.marketBoard,
      this.memberDetails});

  final ScreenArguments screenArguments;
  final MarketBoard? marketBoard;
  final MemberDetails? memberDetails;

  final bool isTotalBoard;
  final VoidCallback onpressd;

  @override
  State<StatefulWidget> createState() => _BoardDrawerWidgetState();
}

class _BoardDrawerWidgetState extends State<BoardDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffEBEBEB),
      ),
      child: ListView(
        children: [
          InkWell(
            onTap: () async {
              if (widget.isTotalBoard) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoticeBoardPage(
                          screenArguments: widget.screenArguments)),
                );
              } else {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoticeBoardPage(
                          screenArguments: widget.screenArguments)),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'notice'.tr(),
                    style:
                        const TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          ExpansionTile(
            backgroundColor: Colors.white,
            tilePadding: const EdgeInsets.only(right: 10, left: 10),
            initiallyExpanded: false,
            collapsedBackgroundColor: Colors.white,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'post1'.tr(),
                  style:
                      const TextStyle(color: Color(0xff888888), fontSize: 16),
                ),
                SvgPicture.asset(
                  'assets/icon/ICON_post.svg',
                  height: 23.spMin,
                  color: const Color(0xff888888),
                )
              ],
            ),
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MarketBoardPostPage(
                            screenArguments: widget.screenArguments,
                            marketBoard: widget.marketBoard)),
                  );
                },
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'market-board-post'.tr(),
                        style: const TextStyle(
                            color: Color(0xff888888), fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (widget.isTotalBoard) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ArticleWritingPage(
                              screenArguments: widget.screenArguments,
                              category: "")),
                    );
                  } else {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ArticleWritingPage(
                              screenArguments: widget.screenArguments,
                              category: "")),
                    );
                  }
                },
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "general-board-post".tr(),
                        style: const TextStyle(
                            color: Color(0xff888888), fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          ExpansionTile(
            backgroundColor: Colors.white,
            tilePadding: const EdgeInsets.only(right: 10, left: 10),
            initiallyExpanded: false,
            collapsedBackgroundColor: Colors.white,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'my_posts'.tr(),
                  style:
                      const TextStyle(color: Color(0xff888888), fontSize: 16),
                ),
                const SizedBox(
                  width: 10,
                ),
                SvgPicture.asset(
                  'assets/icon/ICON_board.svg',
                  height: 16.spMin,
                  color: const Color(0xff888888),
                )
              ],
            ),
            children: [
              //좋아요
              InkWell(
                onTap: () {
                  if (widget.isTotalBoard) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyArticlePage(
                              screenArguments: widget.screenArguments,
                              category: 'liked'.tr())),
                    );
                  } else {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyArticlePage(
                              screenArguments: widget.screenArguments,
                              category: 'liked'.tr())),
                    );
                  }
                },
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'liked'.tr(),
                        style: const TextStyle(
                            color: Color(0xff888888), fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
              //게시글
              InkWell(
                onTap: () {
                  if (widget.isTotalBoard) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyArticlePage(
                              screenArguments: widget.screenArguments,
                              category: 'my_posts-child'.tr())),
                    );
                  } else {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyArticlePage(
                              screenArguments: widget.screenArguments,
                              category: 'my_posts-child'.tr())),
                    );
                  }
                },
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'my_posts-child'.tr(),
                        style: const TextStyle(
                            color: Color(0xff888888), fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
              //댓글
              InkWell(
                onTap: () {
                  if (widget.isTotalBoard) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyArticlePage(
                              screenArguments: widget.screenArguments,
                              category: 'my-comments'.tr())),
                    );
                  } else {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyArticlePage(
                              screenArguments: widget.screenArguments,
                              category: 'my-comments'.tr())),
                    );
                  }
                },
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'my-comments'.tr(),
                        style: const TextStyle(
                            color: Color(0xff888888), fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationBoardWidget(
                        screenArguments: widget.screenArguments)),
              );
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'notification'.tr(),
                    style:
                        const TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  SvgPicture.asset(
                    'assets/icon/ICON_notification.svg',
                    height: 23.spMin,
                    color: const Color(0xff888888),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 30.h,
            color: const Color(0xffebebeb),
          ),
          Container(
            height: 20,
            color: Colors.white,
          ),
          InkWell(
            onTap: widget.isTotalBoard
                ? widget.onpressd
                : () {
                    Navigator.pop(context);
                  },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'total-board'.tr(),
                    style:
                        const TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              if (widget.isTotalBoard) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FreePostingBoardPage(
                          screenArguments: widget.screenArguments)),
                );
              } else {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FreePostingBoardPage(
                          screenArguments: widget.screenArguments)),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'free-posting'.tr(),
                    style:
                        const TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              if (widget.isTotalBoard) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MarketBoardPage(
                          screenArguments: widget.screenArguments,
                          marketBoard: widget.marketBoard,
                          memberDetails:
                              widget.screenArguments.memberDetails!)),
                );
              } else {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MarketBoardPage(
                          screenArguments: widget.screenArguments,
                          marketBoard: widget.marketBoard,
                          memberDetails:
                              widget.screenArguments.memberDetails!)),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'market'.tr(),
                    style:
                        const TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              if (widget.isTotalBoard) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GameBoardPage(
                            screenArguments: widget.screenArguments,
                          )),
                );
              } else {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GameBoardPage(
                            screenArguments: widget.screenArguments,
                          )),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'game'.tr(),
                    style:
                        const TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              if (widget.isTotalBoard) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FashionBoardPage(
                            screenArguments: widget.screenArguments,
                          )),
                );
              } else {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FashionBoardPage(
                            screenArguments: widget.screenArguments,
                          )),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'fashion'.tr(),
                    style:
                        const TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              if (widget.isTotalBoard) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FoodBoardPage(
                            screenArguments: widget.screenArguments,
                          )),
                );
              } else {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FoodBoardPage(
                            screenArguments: widget.screenArguments,
                          )),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'food'.tr(),
                    style:
                        const TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              if (widget.isTotalBoard) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MusicBoardPage(
                            screenArguments: widget.screenArguments,
                          )),
                );
              } else {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MusicBoardPage(
                            screenArguments: widget.screenArguments,
                          )),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'music'.tr(),
                    style:
                        const TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              if (widget.isTotalBoard) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InfoBoardPage(
                          screenArguments: widget.screenArguments)),
                );
              } else {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InfoBoardPage(
                          screenArguments: widget.screenArguments)),
                );
              }
            },
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'info'.tr(),
                    style:
                        const TextStyle(color: Color(0xff888888), fontSize: 16),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
