import 'dart:async';

import 'package:aliens/models/message_model.dart';
import 'package:aliens/models/notice_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:aliens/services/board_service.dart';
import '../../models/screen_argument.dart';
import '../pages/board/notice_detail_page.dart';

class NoticeWidget extends StatefulWidget {
  const NoticeWidget(
      {super.key, required this.noticeArticle, required this.screenArguments});
  final ScreenArguments screenArguments;
  final NoticeArticle noticeArticle;

  @override
  State<StatefulWidget> createState() => _NoticeWidgetState();
}

class _NoticeWidgetState extends State<NoticeWidget> {
  String createdAt = '';
  List<NoticeArticle> noticearticles = [];

  @override
  void initState() {
    super.initState();
    fetchNoticeData();
  }

  Future<void> fetchNoticeData() async {
    try {
      final response = await BoardService.boardNotice();
      final dataList = response; // 변환된 리스트 데이터

      setState(() {
        print('1');
        noticearticles =
            dataList.map((article) => NoticeArticle.fromJson(article)).toList();
        print('2');
      });
    } catch (error) {
      print('Error fetching article data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoticeDetailPage(
                    noticeArticle: widget.noticeArticle,
                    screenArguments: widget.screenArguments)),
          );
        },
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(),
                child: Text(
                  '${widget.noticeArticle.title}',
                  style: TextStyle(
                    fontSize: 18.spMin,
                    color: Colors.black,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  DataUtils.getTime(widget.noticeArticle.createdAt),
                  style: TextStyle(
                    fontSize: 14.spMin,
                    color: const Color(0xff888888),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
