import 'dart:async';

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
                  width: 24,
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isDrawerStart = !isDrawerStart;
                  });
                },
                icon: Icon(Icons.format_list_bulleted_outlined),
                color: Colors.white,
              ),
            ],
          ),
          title: Text('market'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              )
          ),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.search))
          ],


        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 21, right: 21),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.09,
              child: Row(
                children: [
                  Icon(
                    Icons.volume_mute,
                    size: isSmallScreen?26:28,
                    color: Color(0xff7898FF),
                  ),
                  Expanded(
                    child: Text(
                      'market-noti'.tr(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: isSmallScreen?14:16,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  )

                ],
              ),
            ),
            Container(
              height: 1, color: Color(0xffE5EBFF),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06, right: MediaQuery.of(context).size.width * 0.06, top: 20, bottom: 20),
                child: Container(
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('market-noti1'.tr(),
                        style: TextStyle(
                            fontSize: isSmallScreen?12:14),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height *0.04),
                      Text('market-noti2'.tr(),
                        style: TextStyle(
                            fontSize: isSmallScreen?12:14,
                            color: Color(0xffFF506F),
                            fontWeight: FontWeight.bold),
                      ),
                      Text('market-noti3'.tr(),
                        style: TextStyle(
                          fontSize: isSmallScreen?12:14,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height *0.03),
                      Text('market-noti4'.tr(),
                        style: TextStyle(
                            fontSize: isSmallScreen?12:14,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        'market-noti5'.tr(),
                        style: TextStyle(
                            fontSize: isSmallScreen?12:14
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height *0.03),
                      Text('market-noti6'.tr(),
                        style: TextStyle(
                            fontSize: isSmallScreen?12:14,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text('market-noti7'.tr(),
                        style: TextStyle(
                          fontSize: isSmallScreen?12:14
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