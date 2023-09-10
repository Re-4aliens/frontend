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
import 'package:aliens/models/market_articles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../apis/apis.dart';
import '../../models/board_model.dart';
import '../../models/market_articles.dart';
import '../pages/board/market_board_page.dart';
import '../pages/board/market_posting_board_page.dart';


class MarketBoardDialog extends StatelessWidget{
  final BuildContext context;
  final MarketBoard marketBoard;
  final MemberDetails memberDetails;
  final ScreenArguments screenArguments;




  const MarketBoardDialog({Key? key, required this.context, required this.marketBoard, required this.memberDetails, required this.screenArguments}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid)
      return androidDialog();
    else
      return iOSDialog();
  }

  Widget androidDialog(){
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
            //report
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
            SizedBox(height: 25.h,),
            memberDetails.email == marketBoard.member!.email ?
            Column(
              children: [
                //delete
                InkWell(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (_) => FutureBuilder(
                            future: APIs.deleteMarketArticle(marketBoard.articleId ?? 0),
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
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (BuildContext context) => MarketBoardPage(
                                      screenArguments: screenArguments,
                                      memberDetails:memberDetails,
                                      marketBoard: marketBoard,
                                    ),
                                  ));


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
                    child: Text(
                      'delete'.tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 25.h,),
                //modify
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => MarketBoardPostPage(
                      screenArguments: screenArguments,
                      marketBoard: marketBoard,// 수정 모드에서 데이터 전달
                    ),
                    )
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(13).r,
                    decoration: BoxDecoration(
                        color: Color(0xff7898FF),
                        borderRadius: BorderRadius.circular(5).r),
                    alignment: Alignment.center,
                    child: Text(
                      'modity'.tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ): SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget iOSDialog(){

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
                    builder: (builder) => iOSReportDialog(memberId: marketBoard.member!.memberId!,));
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
            memberDetails.email == marketBoard.member!.email ? Divider(thickness: 1,):SizedBox(),
            memberDetails.email == marketBoard.member!.email ? InkWell(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ).r,
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => FutureBuilder(
                        future: APIs.deleteArticles(marketBoard.articleId ?? 0),
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
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pop(context);
                              Navigator.pop(context);

                            });
                            return Container(
                                child: Image(
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
            ): SizedBox(),
          ],
        )
    );
  }

}

