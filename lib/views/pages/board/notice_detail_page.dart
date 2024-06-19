import 'package:aliens/models/notice_article.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/message_model.dart';
import '../../components/board_drawer_widget.dart';
import 'notification_page.dart';

class NoticeDetailPage extends StatefulWidget {
  const NoticeDetailPage(
      {Key? key, required this.screenArguments, required this.noticeArticle})
      : super(key: key);
  final ScreenArguments screenArguments;
  final NoticeArticle noticeArticle;

  @override
  State<StatefulWidget> createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  bool isDrawerStart = false;

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(),
                        child: Text(
                          '${widget.noticeArticle.title}',
                          style: TextStyle(
                            fontSize: 18.spMin,
                            fontWeight: FontWeight.bold,
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
                ),
                Divider(
                  thickness: 1.h,
                  color: const Color(0xffCECECE),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 21.w, vertical: 10.spMin),
                  child: Text(
                    '${widget.noticeArticle.content}', // 'content' from the Board object
                    style: TextStyle(
                      fontSize: 18.spMin,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
