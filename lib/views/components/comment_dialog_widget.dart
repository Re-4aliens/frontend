import 'package:aliens/models/member_details_model.dart';
import 'package:aliens/views/components/report_dialog_widget.dart';
import 'package:aliens/views/components/report_ios_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:aliens/services/comment_service.dart';
import '../../models/comment_model.dart';
import 'package:aliens/providers/comment_provider.dart';

import 'dart:convert';
import 'package:aliens/services/api_service.dart';

class CommentDialog extends StatelessWidget {
  final BuildContext context;
  final VoidCallback onpressed;
  final bool isNestedComment;
  final Comment comment;
  final MemberDetails memberDetails;
  final int articleId;

  const CommentDialog({
    Key? key,
    required this.context,
    required this.onpressed,
    required this.isNestedComment,
    required this.comment,
    required this.memberDetails,
    required this.articleId,
  }) : super(key: key);

  Future<String?> getUserEmail() async {
    var userInfo = await APIService.storage.read(key: 'auth');
    if (userInfo != null && userInfo.isNotEmpty) {
      var decodedUserInfo = json.decode(userInfo);
      return decodedUserInfo['email'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return FutureBuilder<String?>(
        future: getUserEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userEmail = snapshot.data;
            return androidDialog(userEmail);
          }
        },
      );
    } else {
      return FutureBuilder<String?>(
        future: getUserEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userEmail = snapshot.data;
            print(userEmail);
            print(userEmail == memberDetails.email);
            return iOSDialog(userEmail);
          }
        },
      );
    }
  }

  Widget androidDialog(String? userEmail) {
    final commentProvider = Provider.of<CommentProvider>(context);
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
            memberDetails.email == userEmail
                ? SizedBox(
                    height: 10.h,
                  )
                : const SizedBox(),
            memberDetails.email == userEmail
                ? InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => FutureBuilder(
                              future: CommentService.deleteComment(comment.id),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData == false) {
                                  //받아오는 동안
                                  return Container(
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/illustration/loading_01.gif")));
                                } else {
                                  //받아온 후
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    commentProvider.getComments(articleId);
                                  });
                                  return Container(
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/illustration/loading_01.gif")));
                                }
                              }));
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
                  )
                : const SizedBox(),
            SizedBox(
              height: 10.h,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (builder) =>
                        ReportDialog(id: comment.id, context: context));
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

  Widget iOSDialog(String? userEmail) {
    final commentProvider = Provider.of<CommentProvider>(context);
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
          memberDetails.email == userEmail
              ? InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => FutureBuilder(
                            future: CommentService.deleteComment(comment.id),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData == false) {
                                //받아오는 동안
                                return Container(
                                    child: const Image(
                                        image: AssetImage(
                                            "assets/illustration/loading_01.gif")));
                              } else {
                                //받아온 후
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  commentProvider.getComments(articleId);
                                });
                                return Container(
                                    child: const Image(
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
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
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
                        memberId: comment.id,
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
