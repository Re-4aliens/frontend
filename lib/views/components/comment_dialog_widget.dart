import 'package:aliens/models/memberDetails_model.dart';
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

import '../../apis/apis.dart';
import '../../models/comment_model.dart';
import '../../providers/comment_provider.dart';


class CommentDialog extends StatelessWidget{
  final BuildContext context;
  final VoidCallback onpressed;
  final bool isNestedComment;
  final Comment comment;
  final MemberDetails memberDetials;
  final int articleId;

  const CommentDialog({
    Key? key,
    required this.context,
    required this.onpressed,
    required this.isNestedComment,
    required this.comment,
    required this.memberDetials,
    required this.articleId,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid)
      return androidDialog();
    else
      return iOSDialog();
  }

  Widget androidDialog(){
    final commentProvider = Provider.of<CommentProvider>(context);
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

            memberDetials.email == comment.member!.email ?
            SizedBox(
              height: 10.h,
            ):SizedBox(),
            memberDetials.email == comment.member!.email ?
            InkWell(
              onTap: (){
                showDialog(
                    context: context,
                    builder: (_) => FutureBuilder(
                        future: APIs.deleteComment(comment.articleCommentId!),
                        builder: (BuildContext context,
                            AsyncSnapshot snapshot) {
                          if (snapshot.hasData == false) {
                            //받아오는 동안
                            return Container(
                                child: Image(
                                    image: AssetImage(
                                        "assets/illustration/loading_01.gif")));
                          } else{
                            //받아온 후
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              commentProvider.getComments(articleId);
                            });
                            return Container(
                                child: Image(
                                    image: AssetImage(
                                        "assets/illustration/loading_01.gif")));
                          }
                        }));
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
            ):SizedBox(),
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
    final commentProvider = Provider.of<CommentProvider>(context);
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
          memberDetials.email == comment.member!.email ?
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => FutureBuilder(
                      future: APIs.deleteComment(comment.articleCommentId!),
                      builder: (BuildContext context,
                          AsyncSnapshot snapshot) {
                        if (snapshot.hasData == false) {
                          //받아오는 동안
                          return Container(
                              child: Image(
                                  image: AssetImage(
                                      "assets/illustration/loading_01.gif")));
                        } else{
                          //받아온 후
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            commentProvider.getComments(articleId);
                          });
                          return Container(
                              child: Image(
                                  image: AssetImage(
                                      "assets/illustration/loading_01.gif")));
                        }
                      }));
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
          ):SizedBox(),
          InkWell(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (builder) => iOSReportDialog());
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

