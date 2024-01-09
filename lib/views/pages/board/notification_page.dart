import 'dart:async';
import 'dart:convert';

import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/providers/noti_board_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../models/board_model.dart';
import '../../../models/countries.dart';
import '../../../models/market_articles.dart';
import '../../components/article_widget.dart';
import '../../components/board_drawer_widget.dart';
import '../../components/info_article_widget.dart';
import '../../components/my_article_widget.dart';
import '../../components/notification_widget.dart';
import 'article_page.dart';
import 'article_writing_page.dart';


class NotificationBoardWidget extends StatefulWidget {
  const NotificationBoardWidget({super.key, required this.screenArguments});
  final ScreenArguments screenArguments;


  @override
  State<StatefulWidget> createState() => _NotificationBoardWidgetState();
}

class _NotificationBoardWidgetState extends State<NotificationBoardWidget> {
  int page = 0;

  @override
  void initState() {
    super.initState();
    final boardProvider = Provider.of<NotiBoardProvider>(context, listen: false);
    boardProvider.getNotiArticles();
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<NotiBoardProvider>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'notification'.tr(),
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
                ],
              )
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: boardProvider.loading || boardProvider.notiArticleList == null? Container(
              alignment: Alignment.center,
              child: Image(
                  image: AssetImage(
                      "assets/illustration/loading_01.gif"))):ListView.builder(
              itemCount: boardProvider.notiArticleList!.length,
              itemBuilder: (context, index) {
                var nationCode = '';
                for (Map<String, String> country in countries) {
                  if (country['name'] == boardProvider.notiArticleList![index].nationality.toString()) {
                    nationCode = country['code']!;
                    break;
                  }
                }
                return Column(
                  children: [
                    NotificationWidget(article: boardProvider.notiArticleList![index], nationCode: nationCode, screenArguments: widget.screenArguments, index: index),
                    Divider(
                      thickness: 1.h,
                      color: Color(0xffCECECE),
                    )
                  ],
                );
              }),
        ),
    );
  }

}
