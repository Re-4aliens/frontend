
import 'dart:async';

import 'package:aliens/models/message_model.dart';
import 'package:aliens/models/noticeArticle.dart';
import 'package:aliens/views/pages/board/article_writing_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/board_model.dart';
import '../../models/screenArgument.dart';
import '../pages/board/article_page.dart';
import '../pages/board/info_article_page.dart';
import '../pages/board/notice_detail_page.dart';
import 'board_dialog_widget.dart';

class NoticeWidget extends StatefulWidget {

  NoticeWidget({super.key, required this.noticeArticle, required this.screenArguments});
  final ScreenArguments screenArguments;
  final NoticeArticle noticeArticle;
  @override
  State<StatefulWidget> createState() => _NoticeWidgetState();
}
class _NoticeWidgetState extends State<NoticeWidget> {
  String createdAt = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoticeDetailPage(noticeArticle: widget.noticeArticle, screenArguments: widget.screenArguments)),
          );
    },
    child: ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding:EdgeInsets.only(),
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
                color: Color(0xff888888),
              ),
            ),
          ),
        ],
      ),
    )
    );
  }
}