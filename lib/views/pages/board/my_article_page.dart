import 'package:aliens/models/screen_argument.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:aliens/views/components/total_article_widget.dart';

import 'package:aliens/providers/board_provider.dart';
import '../../components/board_drawer_widget.dart';
import 'notification_page.dart';

class MyArticlePage extends StatefulWidget {
  const MyArticlePage(
      {super.key, required this.screenArguments, required this.category});

  final ScreenArguments screenArguments;
  final category;

  @override
  State<StatefulWidget> createState() => _MyArticlePageState();
}

class _MyArticlePageState extends State<MyArticlePage> {
  bool isDrawerStart = false;
  final ScrollController _scrollController = ScrollController();
  int page = 0;
  bool isLoadingMore = false; // 중복 요청 방지

  @override
  void initState() {
    super.initState();
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);

    if (widget.category == 'liked'.tr()) {
      boardProvider.getLikedList();
    } else if (widget.category == 'my_posts-child'.tr()) {
      boardProvider.getMyArticles();
    } else if (widget.category == 'my-comments'.tr()) {
      loadMyCommentArticles();
    }

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isLoadingMore) {
        setState(() {
          isLoadingMore = true;
        });
        page++;
        if (widget.category == 'liked'.tr()) {
          await boardProvider.getMoreLikedList(page);
        } else if (widget.category == 'my_posts-child'.tr()) {
          await boardProvider.getMoreMyArticles(page);
        } else if (widget.category == 'my-comments'.tr()) {
          await boardProvider.getMoreMyCommentArticles(page);
        }

        // 데이터 로드 후 isLoadingMore 상태 해제
        setState(() {
          isLoadingMore = false;
        });
      }
    });
  }

  void loadMyCommentArticles() async {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    int tmp = await boardProvider.getMyCommentArticles();

    setState(() {
      page = tmp;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.category,
          style: TextStyle(
            fontSize: 16.spMin,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 56.spMin,
        elevation: 0,
        shadowColor: Colors.black26,
        backgroundColor: const Color(0xff7898ff),
        leadingWidth: 100,
        leading: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(
                    'assets/icon/icon_back.svg',
                    color: Colors.white,
                    height: 18.h,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isDrawerStart = !isDrawerStart;
                    });
                  },
                  icon: const Icon(Icons.format_list_bulleted_outlined),
                  color: Colors.white,
                ),
              ],
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationBoardWidget(
                          screenArguments: widget.screenArguments)),
                );
              },
              child: SvgPicture.asset(
                'assets/icon/ICON_notification.svg',
                width: 28.r,
                height: 28.r,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: isDrawerStart
          ? BoardDrawerWidget(
              screenArguments: widget.screenArguments,
              isTotalBoard: false,
              onpressd: () {},
            )
          : Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: boardProvider.loading && page == 0
                  ? Container(
                      alignment: Alignment.center,
                      child: const Image(
                          image:
                              AssetImage("assets/illustration/loading_01.gif")))
                  : Column(
                      children: [
                        SizedBox(height: 10.h),
                        Expanded(
                            child: ListView.builder(
                          itemCount: boardProvider.articleList.length,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                TotalArticleWidget(
                                  board: boardProvider.articleList[index],
                                  screenArguments: widget.screenArguments,
                                  index: index,
                                ),
                                const Divider(
                                  thickness: 2,
                                  color: Color(0xffE5EBFF),
                                )
                              ],
                            );
                          },
                        )),
                        if (isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
            ),
    );
  }
}
