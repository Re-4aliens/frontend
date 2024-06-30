import 'package:aliens/views/components/report_dialog_widget.dart';
import 'package:aliens/views/components/report_ios_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/comment_model.dart';
import 'package:aliens/providers/market_comment_provider.dart';

class MarketCommentDialog extends StatelessWidget {
  final BuildContext context;
  final VoidCallback onpressed;
  final bool isNestedComment;
  final Comment marketcomment;

  const MarketCommentDialog(
      {Key? key,
      required this.context,
      required this.onpressed,
      required this.isNestedComment,
      required this.marketcomment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return androidDialog();
    } else {
      return iOSDialog();
    }
  }

  Widget androidDialog() {
    final marketcommentProvider = Provider.of<MarketCommentProvider>(context);
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0).r,
      ),
      child: Container(
        padding: const EdgeInsets.all(30).r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'chatting-dialog1'.tr(),
              style: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.h,
            ),
            isNestedComment
                ? const SizedBox()
                : InkWell(
                    onTap: onpressed,
                    child: Container(
                      padding: const EdgeInsets.all(13).r,
                      decoration: BoxDecoration(
                          color: const Color(0xff7898FF),
                          borderRadius: BorderRadius.circular(5).r),
                      alignment: Alignment.center,
                      child: Text(
                        'comment3'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
            SizedBox(
              height: 10.h,
            ),
            InkWell(
              onTap: () {
                //TODO 로딩 만들기
                marketcommentProvider
                    .deleteMarketComment(marketcomment.articleCommentId!);
              },
              child: Container(
                padding: const EdgeInsets.all(13).r,
                decoration: BoxDecoration(
                    color: const Color(0xff7898FF),
                    borderRadius: BorderRadius.circular(5).r),
                alignment: Alignment.center,
                child: Text(
                  'delete'.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (builder) => ReportDialog(
                        id: marketcomment.member!.memberId!, context: context));
              },
              child: Container(
                padding: const EdgeInsets.all(13).r,
                decoration: BoxDecoration(
                    color: const Color(0xff7898FF),
                    borderRadius: BorderRadius.circular(5).r),
                alignment: Alignment.center,
                child: Text(
                  'chatting-report1'.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iOSDialog() {
    final marketcommentProvider = Provider.of<MarketCommentProvider>(context);
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isNestedComment
              ? const SizedBox()
              : InkWell(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  onTap: onpressed,
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      "comment3".tr(),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          InkWell(
            onTap: () {
              //TODO 로딩 만들기
              marketcommentProvider
                  .deleteMarketComment(marketcomment.articleCommentId!);
            },
            child: Container(
              height: 80,
              alignment: Alignment.center,
              child: Text(
                "delete".tr(),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (builder) => iOSReportDialog(
                        memberId: marketcomment.member!.memberId!,
                      ));
            },
            child: Container(
              height: 80,
              alignment: Alignment.center,
              child: Text(
                "chatting-report1".tr(),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
