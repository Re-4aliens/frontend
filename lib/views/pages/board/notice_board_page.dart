import 'dart:async';

import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:aliens/views/pages/board/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aliens/apis/apis.dart';
import 'package:aliens/models/noticeArticle.dart';
import '../../../apis/apis.dart';
import '../../../mockdatas/market_comment_mockdata.dart';
import '../../../models/countries.dart';
import '../../components/article_widget.dart';
import '../../components/board_drawer_widget.dart';
import '../../components/info_article_widget.dart';
import '../../components/my_article_widget.dart';
import '../../components/notice_board_widget.dart';
import '../../components/notification_widget.dart';
import 'article_page.dart';
import 'article_writing_page.dart';
import 'notification_page.dart';


class NoticeBoardPage extends StatefulWidget {
  const NoticeBoardPage({super.key, required this.screenArguments});
  final ScreenArguments screenArguments;


  @override
  State<StatefulWidget> createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {
  bool isDrawerStart = false;
  List<NoticeArticle> noticearticles = []; //공지사항 저장

  void initState() {
    super.initState();
    fetchNoticeData();
  }

  Future<void> fetchNoticeData() async {
    try {
      final response = await APIs.BoardNotice();
      final dataList = response as List<dynamic>;

      setState(() {
        // API 데이터를 공지사항 목록으로 변환하여 업데이트
        noticearticles = dataList.map((article) => NoticeArticle.fromJson(article)).toList();
      });
    } catch (error) {
      print('Error fetching notice data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'notice'.tr(),
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
                  Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => NotificationBoardWidget(screenArguments: widget.screenArguments)),
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
            Padding(padding: EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => SearchPage(screenArguments: widget.screenArguments, category: "공지게시판",)),
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
          ]
      ),
      body: isDrawerStart
          ? BoardDrawerWidget(screenArguments: widget.screenArguments, isTotalBoard: false,
        onpressd: (){},
      )
          :

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 21.w, right: 21.w, top: 15.spMin, bottom: 15.spMin), // Adjust padding as needed
            child: Text(
              'notice'.tr(),
              style: TextStyle(
                fontSize: 18.spMin,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: ListView.builder(
                  itemCount:  noticearticles.length,
                  itemBuilder: (context, index) {
                    final noticeArticle = noticearticles[index];
                    return Column(
                      children: [
                        Divider(
                        thickness: 1.h,
                        color: Color(0xffCECECE),
                      ),
                        NoticeWidget(noticeArticle: noticeArticle, screenArguments: widget.screenArguments),

                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
