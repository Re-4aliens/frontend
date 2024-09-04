import 'dart:convert';

import 'package:aliens/models/message_model.dart';
import 'package:aliens/models/notification_article_model.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/board_model.dart';
import '../../models/market_board_model.dart';
import 'package:aliens/providers/noti_board_provider.dart';
import '../pages/board/article_page.dart';
import '../pages/board/info_article_page.dart';
import '../pages/board/market_detail_page.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget(
      {super.key,
      required this.article,
      required this.nationCode,
      required this.screenArguments,
      required this.index});

  final NotificationArticle article;
  final String nationCode;
  final ScreenArguments screenArguments;
  final int index;

  @override
  State<StatefulWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  String createdAt = '';
  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<NotiBoardProvider>(context);
    return ListTile(
      //제목
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        '[${getCategoryValue(widget.article.category ?? 'Unknown')}]',
                        style: TextStyle(
                            fontSize: 14.spMin, color: const Color(0xff888888)),
                      ))
                ],
              ),
            ],
          ),
          Flexible(
            child: Text(
              DataUtils.getTime(widget.article.createdAt),
              style:
                  TextStyle(fontSize: 14.spMin, color: const Color(0xffc1c1c1)),
            ),
          ),
        ],
      ),

      //내용
      subtitle: Column(
        children: [
          SizedBox(
            height: 10.r,
          ),
          Container(
            padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: Padding(
                  padding: EdgeInsets.only(top: 0.h),
                  child: Text(
                    widget.article.content ?? 'Unknown',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16.spMin, color: Colors.black),
                  ),
                )),
                Container(
                  padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
                  width: 19.0,
                  height: 19.0,
                  decoration: boardProvider.isReadList[widget.index] == true
                      ? const BoxDecoration()
                      : const BoxDecoration(
                          color: Color(0xFFFFE68D),
                          shape: BoxShape.circle,
                        ),
                )
              ],
            ),
          ),
        ],
      ),

      onTap: () {
        //상세 페이지로 연결
        showDialog(
            context: context,
            builder: (_) => FutureBuilder(
                future:
                    getPageDetails(widget.article.id, widget.article.category),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    //받아오는 동안
                    return Container(
                        child: const Image(
                            image: AssetImage(
                                "assets/illustration/loading_01.gif")));
                  }
                  //받아오지 못할 때(오류)
                  else if (snapshot.data == false) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pop(context);
                    });
                    return Container(
                        child: const Image(
                            image: AssetImage(
                                "assets/illustration/loading_01.gif")));
                  }
                  //받아온 후
                  else {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pop(context);
                      //장터게시판 연결
                      if (widget.article.category == "MARKET") {
                        MarketBoard data = snapshot.data;
                        //읽음 처리 요청
                        boardProvider.putReadValue(
                            widget.index, widget.article.id!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MarketDetailPage(
                                    screenArguments: widget.screenArguments,
                                    marketBoard: data,
                                    index: -1,
                                    backPage: '',
                                  )),
                        );
                      }
                      //정보 게시판 연결
                      else if (widget.article.category == "INFO") {
                        Board data = snapshot.data;
                        //읽음 처리 요청
                        boardProvider.putReadValue(
                            widget.index, widget.article.id!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoArticlePage(
                                    board: data,
                                  )),
                        );
                      } else {
                        Board data = snapshot.data;
                        //읽음 처리 요청
                        boardProvider.putReadValue(
                            widget.index, widget.article.id!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArticlePage(
                                    memberDetails:
                                        widget.screenArguments.memberDetails,
                                    board: data,
                                    index: -1,
                                  )),
                        );
                      }
                    });

                    return Container(
                        child: const Image(
                            image: AssetImage(
                                "assets/illustration/loading_01.gif")));
                  }
                }));
      },
    );
  }

  dynamic getPageDetails(url, boardCategory) async {
    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token') ?? '';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      dynamic body = json.decode(utf8.decode(response.bodyBytes))['data'];
      if (boardCategory == "MARKET") {
        return MarketBoard.fromJson(body);
      } else {
        return Board.fromJson(body);
      }
      //fail
    } else {
      return false;
    }
  }

  String getCategoryValue(String category) {
    switch (category) {
      case "FREE":
        return 'free-posting'.tr();
      case "GAME":
        return 'game'.tr();
      case "FASHION":
        return 'fashion'.tr();
      case "FOOD":
        return 'food'.tr();
      case "MUSIC":
        return 'music'.tr();
      case "INFO":
        return 'info'.tr();
    }
    return '';
  }
}
