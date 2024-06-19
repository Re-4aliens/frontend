import 'package:aliens/models/member_details_model.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/views/components/report_dialog_widget.dart';
import 'package:aliens/views/components/report_ios_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io' show Platform;
import 'package:aliens/models/market_articles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:aliens/services/board_service.dart';
import '../pages/board/market_board_page.dart';
import '../pages/board/market_posting_board_page.dart';

class MarketBoardDialog extends StatelessWidget {
  final BuildContext context;
  final MarketBoard marketBoard;
  final MemberDetails memberDetails;
  final ScreenArguments screenArguments;

  const MarketBoardDialog(
      {Key? key,
      required this.context,
      required this.marketBoard,
      required this.memberDetails,
      required this.screenArguments})
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
              height: 25.h,
            ),
            //report
            InkWell(
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (builder) => ReportDialog(
                        memberId: marketBoard.member!.memberId!,
                        context: context));
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
            ),
            SizedBox(
              height: 25.h,
            ),
            memberDetails.email == marketBoard.member!.email
                ? Column(
                    children: [
                      //delete
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => FutureBuilder(
                                  future: BoardService.deleteArticle(
                                      marketBoard.articleId ?? 0),
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
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MarketBoardPage(
                                            screenArguments: screenArguments,
                                            memberDetails: memberDetails,
                                            marketBoard: marketBoard,
                                          ),
                                        ));
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
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      //modify
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MarketBoardPostPage(
                                  screenArguments: screenArguments,
                                  marketBoard: marketBoard, // 수정 모드에서 데이터 전달
                                ),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(13).r,
                          decoration: BoxDecoration(
                              color: const Color(0xff7898FF),
                              borderRadius: BorderRadius.circular(5).r),
                          alignment: Alignment.center,
                          child: Text(
                            'modity'.tr(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget iOSDialog() {
    return Dialog(
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0).r,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ).r,
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (builder) => iOSReportDialog(
                          memberId: marketBoard.member!.memberId!,
                        ));
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
            memberDetails.email == marketBoard.member!.email
                ? const Divider(
                    thickness: 1,
                  )
                : const SizedBox(),
            memberDetails.email == marketBoard.member!.email
                ? InkWell(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ).r,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => FutureBuilder(
                              future: BoardService.deleteArticle(
                                  marketBoard.articleId ?? 0),
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
                                  });
                                  return Container(
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/illustration/loading_01.gif")));
                                }
                              }));
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
                  )
                : const SizedBox(),
          ],
        ));
  }
}
