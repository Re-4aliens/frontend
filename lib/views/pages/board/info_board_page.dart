import 'package:aliens/models/screen_argument.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aliens/views/pages/board/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../models/countries.dart';
import 'package:aliens/providers/board_provider.dart';
import '../../components/article_widget.dart';
import '../../components/board_drawer_widget.dart';
import 'article_writing_page.dart';
import 'notification_page.dart';

class InfoBoardPage extends StatefulWidget {
  const InfoBoardPage({super.key, required this.screenArguments});
  final ScreenArguments screenArguments;

  @override
  State<StatefulWidget> createState() => _InfoBoardPageState();
}

class _InfoBoardPageState extends State<InfoBoardPage> {
  bool isDrawerStart = false;
  final ScrollController _scrollController = ScrollController();
  int page = 0;

  @override
  void initState() {
    super.initState();
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    boardProvider.getArticles('info');

    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        page++;
        boardProvider.getMoreArticles('info', page);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  String getNationCode(String nationality) {
    var nationCode = '';
    for (Map<String, String> country in countries) {
      if (country['name']! == nationality) {
        nationCode = country['code']!;
        break;
      }
    }
    return nationCode;
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'info'.tr(),
          style: TextStyle(
            fontSize: 18.spMin,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 56,
        elevation: 0,
        shadowColor: Colors.black26,
        backgroundColor: const Color(0xff7898ff),
        leadingWidth: 100,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                    height: 17.r,
                    width: 17.r,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isDrawerStart = !isDrawerStart;
                    });
                  },
                  icon: SvgPicture.asset(
                    'assets/icon/ICON_list.svg',
                    color: Colors.white,
                    height: 20.r,
                    width: 20.r,
                  ),
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
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPage(
                            screenArguments: widget.screenArguments,
                            category: "info",
                          )),
                );
              },
              child: SvgPicture.asset(
                'assets/icon/icon_search.svg',
                width: 25.r,
                height: 25.r,
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
          : Column(
              children: [
                SizedBox(height: 10.h), // ListView.builder 위에 공간 추가
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: boardProvider.articleList.length,
                    itemBuilder: (context, index) {
                      var nationCode = getNationCode(boardProvider
                          .articleList[index].memberProfileDto!.nationality);

                      return Column(
                        children: [
                          ArticleWidget(
                              board: boardProvider.articleList[index],
                              nationCode: nationCode,
                              memberDetails:
                                  widget.screenArguments.memberDetails,
                              index: index),
                          const Divider(
                            thickness: 2,
                            color: Color(0xffE5EBFF),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: isDrawerStart
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ArticleWritingPage(
                            screenArguments: widget.screenArguments,
                            category: "INFO",
                          )),
                ).then((value) {
                  setState(() {});
                });
              },
              backgroundColor: const Color(0xff7898ff),
              child: const Icon(Icons.edit),
            ),
    );
  }
}
