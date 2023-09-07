import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/views/components/liked_post_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:aliens/views/components/total_article_widget.dart';

import '../../../models/board_model.dart';
import '../../../models/countries.dart';
import '../../../repository/board_provider.dart';
import '../../components/article_widget.dart';
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

  @override
  void initState() {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    //boardProvider.getArticles('자유게시판');

    if(widget.category == 'liked'.tr()){
      boardProvider.getLikedList();
    }else if(widget.category == 'my_posts-child'.tr()){
      boardProvider.getMyArticles();
    }else if(widget.category == 'my-comments'.tr()){
      boardProvider.getMyCommentArticles();
    }else{
    }

    _scrollController.addListener(() {
      if (_scrollController.offset == _scrollController.position.maxScrollExtent
          && !_scrollController.position.outOfRange) {
        page++;
        if(widget.category == 'liked'.tr()){
          boardProvider.getLikedList();
        }else if(widget.category == 'my_posts-child'.tr()){
          boardProvider.getMyArticles();
        }else if(widget.category == 'my-comments'.tr()){
          boardProvider.getMoreMyCommentArticles(page);
        }else{
        }
      }
    });

  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
          backgroundColor: Color(0xff7898ff),
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
                    icon: Icon(Icons.format_list_bulleted_outlined),
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(8),
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
            Padding(
              padding: EdgeInsets.all(8),
              child: SvgPicture.asset(
                'assets/icon/icon_search.svg',
                width: 25.r,
                height: 25.r,
                color: Colors.white,
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
                decoration: BoxDecoration(color: Colors.white),
                child: boardProvider.loading || boardProvider.articleList == null
                    ? Container(
                        alignment: Alignment.center,
                        child: Image(
                            image: AssetImage(
                                "assets/illustration/loading_01.gif")))
                    :
                      widget.category == 'my_posts-child'.tr() || widget.category ==
                          'my-comments'.tr()?
                        ListView.builder(
                        itemCount: boardProvider.articleList!.length, controller: _scrollController,
                        itemBuilder: (context, index) {
                          var nationCode = '';
                          for (Map<String, String> country in countries) {
                            if (country['name'] ==
                                boardProvider
                                    .articleList![index].member!.nationality
                                    .toString()) {
                              nationCode = country['code']!;
                              break;
                            }
                          }
                          return Column(
                            children: [
                              TotalArticleWidget(
                                  board: boardProvider.articleList![index],
                                  nationCode: nationCode,
                                screenArguments: widget.screenArguments!,
                                index: index,
                              ),
                              Divider(
                                thickness: 2,
                                color: Color(0xffE5EBFF),
                              )
                            ],
                          );
                        })
                      //좋아요 리스트
                          : ListView.builder(
                          itemCount: boardProvider.articleList!.length,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            var nationCode = '';
                            for (Map<String, String> country in countries) {
                              if (country['name'] ==
                                  boardProvider
                                      .articleList![index].member!.nationality
                                      .toString()) {
                                nationCode = country['code']!;
                                break;
                              }
                            }
                            return Column(
                              children: [
                                LikedArticleWidget(
                                    board: boardProvider.articleList![index],
                                    nationCode: nationCode, memberDetails: widget.screenArguments.memberDetails!,
                                  index: index
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Color(0xffE5EBFF),
                                )
                              ],
                            );
                          })
              ));
  }
}
