import 'package:aliens/models/memberDetails_model.dart';
import 'package:aliens/models/partner_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/board_provider.dart';
import 'package:aliens/views/components/block_dialog_widget.dart';
import 'package:aliens/views/components/report_dialog_widget.dart';
import 'package:aliens/views/components/report_iOS_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/board_model.dart';


class BoardDialog extends StatelessWidget{
  final BuildContext context;
  final Board board;
  final MemberDetails memberDetails;

  const BoardDialog({Key? key, required this.context, required this.board, required this.memberDetails}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid)
      return androidDialog();
    else
      return iOSDialog();
  }

  Widget androidDialog(){
    final boardProvider = Provider.of<BoardProvider>(context);
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
            SizedBox(height: 25.h,),
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
                child: Text(
                  'chatting-report1'.tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                //TODO 로딩 추가
                boardProvider.deletePost(board.articleId!);
                },
              child: Container(
                padding: EdgeInsets.all(13).r,
                decoration: BoxDecoration(
                    color: Color(0xff7898FF),
                    borderRadius: BorderRadius.circular(5).r),
                alignment: Alignment.center,
                child: Text(
                  'delete'.tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget iOSDialog(){

    final boardProvider = Provider.of<BoardProvider>(context);
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0).r,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ).r,
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (builder) => iOSReportDialog());
            },
            child: Container(
              height: 80.h,
              alignment: Alignment.center,
              child: Text(
                'chatting-report1'.tr(),
                style: TextStyle(
                  fontSize: 16.0.spMin,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Divider(thickness: 1,),
          InkWell(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ).r,
            onTap: () {
              //TODO 로딩 추가
              boardProvider.deletePost(board.articleId!);
            },
            child: Container(
              height: 80.h,
              alignment: Alignment.center,
              child: Text(
                'delete'.tr(),
                style: TextStyle(
                  fontSize: 16.0.spMin,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

}

