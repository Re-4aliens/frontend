import 'dart:async';
import 'dart:convert';

import 'package:aliens/models/memberDetails_model.dart';
import 'package:aliens/models/message_model.dart';
import 'package:aliens/models/notification_article_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/views/pages/board/article_writing_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../apis/apis.dart';
import '../../models/board_model.dart';
import '../../models/market_articles.dart';
import '../../providers/noti_board_provider.dart';
import '../pages/board/article_page.dart';
import '../pages/board/info_article_page.dart';
import '../pages/board/market_detail_page.dart';
import 'board_dialog_widget.dart';

class NotificationWidget extends StatefulWidget {
  NotificationWidget(
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
  static final storage = FlutterSecureStorage();

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
              Padding(
                padding: const EdgeInsets.only(
                        top: 15.0, bottom: 15, left: 10, right: 15)
                    .r,
                child: SvgPicture.asset(
                  'assets/icon/icon_profile.svg',
                  width: 34.r,
                  color: Color(0xff7898ff),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      '${widget.screenArguments.memberDetails!.name}/${widget.nationCode}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.spMin),
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        '[${widget.article.articleCategory}]',
                        style: TextStyle(
                            fontSize: 12.spMin, color: Color(0xff888888)),
                      ))
                ],
              ),
            ],
          ),
          Flexible(
            child: Text(
              DataUtils.getTime(widget.article.createdAt),
              style: TextStyle(fontSize: 16.spMin, color: Color(0xffc1c1c1)),
            ),
          ),
        ],
      ),

      //내용
      subtitle: Container(
        padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
                child: Padding(
              padding: EdgeInsets.only(top: 0.h),
              child: Text(
                widget.article.noticeType == "ARTICLE_LIKE"
                    ? '${widget.article.name}님이 좋아요를 눌렀습니다. '
                    : '${widget.article.comment}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16.spMin, color: Colors.black),
              ),
            )),
            Container(
              padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
              width: 19.0,
              height: 19.0,
              decoration: boardProvider.isReadList[widget.index] == 'true'
                  ? BoxDecoration()
                  : BoxDecoration(
                      color: Color(0xFFFFE68D),
                      shape: BoxShape.circle,
                    ),
            )
          ],
        ),
      ),

      onTap: () {
        //상세 페이지로 연결
          showDialog(
              context: context,
              builder: (_) => FutureBuilder(
                  future: getPageDetails(widget.article.articleUrl, widget.article.articleCategory),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      //받아오는 동안
                      return Container(
                          child: Image(
                              image: AssetImage(
                                  "assets/illustration/loading_01.gif")));
                    }
                    //받아오지 못할 때(오류)
                    else if(snapshot.data == false){
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        Navigator.pop(context);
                      });
                      return Container(
                          child: Image(
                              image: AssetImage(
                                  "assets/illustration/loading_01.gif")));
                    }
                    //받아온 후
                    else {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        Navigator.pop(context);
                        //장터게시판 연결
                        if(widget.article.articleCategory == "장터게시판") {
                          MarketBoard data = snapshot.data;
                          //읽음 처리 요청
                          boardProvider.putReadValue(widget.index, widget.article.personalNoticeId!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MarketDetailPage(
                                  screenArguments: widget.screenArguments,
                                  marketBoard: data,
                                  productStatus: '',
                                  StatusText: '',
                                  index: widget.index, //수정 필요
                                )),
                          );
                        }
                        //정보 게시판 연결
                        else if(widget.article.articleCategory == "정보게시판") {
                          Board data = snapshot.data;
                          //읽음 처리 요청
                          boardProvider.putReadValue(widget.index, widget.article.personalNoticeId!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InfoArticlePage(
                                  board: data,
                                )),
                          );
                        }
                        else {
                          Board data = snapshot.data;
                          //읽음 처리 요청
                          boardProvider.putReadValue(widget.index, widget.article.personalNoticeId!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ArticlePage(
                                  memberDetails: widget.screenArguments!.memberDetails!,
                                  board: data,
                                  index: -1,
                                )),
                          );
                        }
                      });

                      return Container(
                          child: Image(
                              image: AssetImage(
                                  "assets/illustration/loading_01.gif")));
                    }
                  }));

      },
    );
  }


  dynamic getPageDetails (url, boardCategory) async {

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      dynamic body = json.decode(
          utf8.decode(response.bodyBytes))['data'];
      if(boardCategory == "장터게시판"){
        return MarketBoard.fromJson(body);
      }else{
        return Board.fromJson(body);
      }
      //fail
    } else {
      return false;
    }
  }
}
