import 'dart:async';

import 'package:aliens/models/screen_argument.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aliens/services/apis.dart';
import 'package:aliens/models/notice_article.dart';
import '../../components/board_drawer_widget.dart';
import '../../components/notice_board_widget.dart';
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

  @override
  void initState() {
    super.initState();
    fetchNoticeData();
  }

  Future<void> fetchNoticeData() async {
    try {
      final response = await APIs.BoardNotice();
      final dataList = response;

      setState(() {
        // API 데이터를 공지사항 목록으로 변환하여 업데이트
        noticearticles =
            dataList.map((article) => NoticeArticle.fromJson(article)).toList();
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
          ]),
      body: isDrawerStart
          ? BoardDrawerWidget(
              screenArguments: widget.screenArguments,
              isTotalBoard: false,
              onpressd: () {},
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 21.w,
                      right: 21.w,
                      top: 15.spMin,
                      bottom: 15.spMin), // Adjust padding as needed
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
                    decoration: const BoxDecoration(color: Colors.white),
                    child: ListView.builder(
                        itemCount: noticearticles.length,
                        itemBuilder: (context, index) {
                          final noticeArticle = noticearticles[index];
                          return Column(
                            children: [
                              Divider(
                                thickness: 1.h,
                                color: const Color(0xffCECECE),
                              ),
                              NoticeWidget(
                                  noticeArticle: noticeArticle,
                                  screenArguments: widget.screenArguments),
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
