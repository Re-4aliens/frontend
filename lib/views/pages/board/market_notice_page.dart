import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:aliens/views/pages/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class MarketNoticePage extends StatefulWidget {
  const MarketNoticePage({super.key});


  @override
  State<StatefulWidget> createState() => _MarketNoticePageState();
}

class _MarketNoticePageState extends State<MarketNoticePage> {

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
        appBar: AppBar(
          backgroundColor:Color(0xff7898ff),
          toolbarHeight:56,
          leadingWidth: 100,
          leading: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
                icon: SvgPicture.asset(
                  'assets/icon/icon_back.svg',
                  color: Colors.white,
                  width: 24.w,
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isDrawerStart = !isDrawerStart;
                  });
                },
                icon: SvgPicture.asset(
                  'assets/icon/ICON_list.svg',
                  width: 20.r,
                  height: 20.r,
                  color: Colors.white,
                ),
                color: Colors.white,
              ),
            ],
          ),
          title: Text('market'.tr(),
              style: TextStyle(
                color: Colors.white,

                fontSize: 20.spMin,
              )
          ),
          centerTitle: true,
          actions: [
            Padding(padding: EdgeInsets.all(8), child: SvgPicture.asset(
              'assets/icon/icon_search.svg',
              width: 25.r,
              height: 25.r,
              color: Colors.white,
            ),),
          ],


        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 21.w, right: 21.w),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.09,
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icon/ICON_notice.svg',
                    width: 20.r,
                    height: 20.r,
                    color: Color(0xff7898ff)
                  ),
                  Expanded(
                    child: Text(
                      'market-noti'.tr(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.spMin,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  )

                ],
              ),
            ),
            Container(
              height: 1.h, color: Color(0xffE5EBFF),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06, right: MediaQuery.of(context).size.width * 0.06, top: 20, bottom: 20),
                child: Container(
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('23.08.06',
                            style: TextStyle(
                              fontSize: 14.h,
                              color: Color(0xff888888)
                            ),
                          )
                        ],
                      ),
                      Text('market-noti1'.tr(),
                        style: TextStyle(
                            fontSize: 14.h),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height *0.04),
                      Text('market-noti2'.tr(),
                        style: TextStyle(
                            fontSize: 14.h,
                            color: Color(0xffFF506F),
                            fontWeight: FontWeight.bold),
                      ),
                      Text('market-noti3'.tr(),
                        style: TextStyle(
                          fontSize: 14.h,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height *0.03),
                      Text('market-noti4'.tr(),
                        style: TextStyle(
                            fontSize: 14.h,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        'market-noti5'.tr(),
                        style: TextStyle(
                            fontSize: 14.h,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height *0.03),
                      Text('market-noti6'.tr(),
                        style: TextStyle(
                            fontSize:14.h,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text('market-noti7'.tr(),
                        style: TextStyle(
                          fontSize: 14.h
                        ),
                      )
                    ],
                  )

                ),
              ),
            )
          ],
        )
    );
  }

}
