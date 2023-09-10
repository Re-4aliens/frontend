import 'package:aliens/models/partner_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/views/components/block_dialog_widget.dart';
import 'package:aliens/views/components/report_dialog_widget.dart';
import 'package:aliens/views/components/report_iOS_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/comment_model.dart';
import '../../models/market_comment.dart';
import '../../providers/comment_provider.dart';
import '../../providers/market_comment_provider.dart';


class MarketCommentDialog extends StatelessWidget{
  final BuildContext context;
  final VoidCallback onpressed;
  final bool isNestedComment;
  final MarketComment marketcomment;

  const MarketCommentDialog({
    Key? key,
    required this.context,
    required this.onpressed,
    required this.isNestedComment,
    required this.marketcomment
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid)
      return androidDialog();
    else
      return iOSDialog();
  }

  Widget androidDialog(){
    final marketcommentProvider = Provider.of<MarketCommentProvider>(context);
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0).r,
      ),
      child: Container(
        padding: EdgeInsets.all(30).r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'chatting-dialog1'.tr(),
              style: TextStyle(
                  fontSize: 16.spMin,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.h,
            ),
            isNestedComment ? SizedBox():
            InkWell(
              onTap: onpressed,
              child: Container(
                padding: EdgeInsets.all(13).r,
                decoration: BoxDecoration(
                    color: Color(0xff7898FF),
                    borderRadius: BorderRadius.circular(5).r),
                alignment: Alignment.center,
                child: Text('comment3'.tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            InkWell(
              onTap: (){
                //TODO 로딩 만들기
                marketcommentProvider.deleteMarketComment(marketcomment.articleCommentId!);
              },
              child: Container(
                padding: EdgeInsets.all(13).r,
                decoration: BoxDecoration(
                    color: Color(0xff7898FF),
                    borderRadius: BorderRadius.circular(5).r),
                alignment: Alignment.center,
                child: Text('delete'.tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            InkWell(
              onTap: (){
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (builder) => ReportDialog(partner: Partner(), context: context));

              },
              child: Container(
                padding: EdgeInsets.all(13).r,
                decoration: BoxDecoration(
                    color: Color(0xff7898FF),
                    borderRadius: BorderRadius.circular(5).r),
                alignment: Alignment.center,
                child: Text('chatting-report1'.tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iOSDialog(){
    final marketcommentProvider = Provider.of<MarketCommentProvider>(context);
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isNestedComment ? SizedBox():
          InkWell(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            onTap: onpressed,
            child: Container(
              height: 80,
              alignment: Alignment.center,
              child: Text(
                "comment3".tr(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              //TODO 로딩 만들기
              marketcommentProvider.deleteMarketComment(marketcomment.articleCommentId!);
            },
            child: Container(
              height: 80,
              alignment: Alignment.center,
              child: Text(
                "delete".tr(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (builder) => iOSReportDialog(memberId: marketcomment.member!.memberId!,));
            },
            child: Container(
              height: 80,
              alignment: Alignment.center,
              child: Text(
                "chatting-report1".tr(),
                style: TextStyle(
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

