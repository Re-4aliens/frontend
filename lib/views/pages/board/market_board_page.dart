import 'dart:async';

import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/board/market_detail_page.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:aliens/views/pages/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/board_drawer_widget.dart';


class MarketBoardPage extends StatefulWidget {
  const MarketBoardPage({super.key, required this.screenArguments});
  final ScreenArguments screenArguments;



  @override
  State<StatefulWidget> createState() => _MarketBoardPageState();
}

class _MarketBoardPageState extends State<MarketBoardPage> {
  bool isDrawerStart = false;

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
                width: 17.r,
                height: 17.r,
              )
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
              fontSize: 18.spMin,
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
      body:isDrawerStart
          ? BoardDrawerWidget(screenArguments: widget.screenArguments, isTotalBoard: false, onpressd: () {  },
      )
          :Column(
        children: [
          InkWell(
            onTap: (){
              Navigator.pushNamed(context,'/market/notice');
            },
            child: Container(
              margin: EdgeInsets.only(right: 10,left: 10, top: 10, bottom: 10).r,
              padding: EdgeInsets.only(right: 10,left: 10).r,
              width: double.infinity,
              height: 42.spMin,
              decoration: BoxDecoration(
                color: Color(0xffE7E7E7),
                borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 만듦
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(child:Container()),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icon/icon_info.svg',
                        color: Color(0xff616161),
                        width: 18.spMin,
                        height: 18.spMin,
                      ),
                      Text(
                        '  ${'market-noti'.tr()}',
                        style: TextStyle(
                            fontSize: 14.spMin,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff616161)
                        ),
                      )
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18.spMin,
                    color: Color(0xffC1C1C1),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child:_contentWidget(),
          )
        ],
      )


    );
  }


  Widget _contentWidget(){
    return ListView.separated(
        itemBuilder:(BuildContext context, int index){
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MarketDetailPage(screenArguments: widget.screenArguments)),
              );
            },
            child: Container(
              padding: EdgeInsets.only(right: 20.w,left: 20.w,top:12.h,bottom: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      //여기 사진 넣기
                      width: 124.spMin, height: 124.spMin,
                      decoration: BoxDecoration(
                        color: Color(0xffF8F8F8),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: ClipRRect(
                              //사진이 있으면 없어질 것들
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child:
                              Image.asset('assets/icon/ICON_photo_1.png', height: 44.spMin),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left:10.w, right: 10.w, top: 2.h, bottom: 2.h),
                             height: 21.spMin,
                              child: Text(
                                '거의 새 것', //productstatus
                                style: TextStyle(fontSize: 10.spMin, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                color: Color(0xff7898FF)
                              ),
                            ),

                        ],
                      ),
                    ), //물건 사진
                    SizedBox(width: 5.w),
                    Container(
                     width: MediaQuery.of(context).size.width -170.w ,
                      height: 124.spMin, //높이를 물건사진의 높이와 같게
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '[판매중]', //status
                                style: TextStyle(
                                  color: Color(0xff616161),
                                  fontSize: 16.spMin,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                             // Expanded(child: SizedBox()),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('23.08.06',//createdAt
                                    style: TextStyle(
                                      color: Color(0xffC1C1C1),
                                      fontSize: 12.spMin,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SimpleDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20.0),
                                              ),
                                              children: [
                                                SimpleDialogOption(
                                                  child: Text(
                                                    '${'modity'.tr()}',
                                                  ),
                                                  onPressed: () {

                                                    },
                                                ),
                                                SimpleDialogOption(
                                                  child: Text('${'chatting-report1'.tr()}'),
                                                  onPressed: ()  {
                                                  },
                                                ),
                                              ],
                                            );
                                          });

                                    },
                                    child: SvgPicture.asset(
                                      'assets/icon/ICON_more.svg',
                                      width: 16.r,
                                      height: 16.r,
                                    )
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Text('가죽쪼리 250 팔아요', //title
                            style: TextStyle(fontSize: 16.spMin),
                          ),
                          SizedBox(height: 5.h),//제목
                          Text('25,000원', //price
                            style: TextStyle(fontSize: 16.spMin,
                            fontWeight: FontWeight.w700),
                          ), //가격
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                'assets/icon/ICON_good.svg',
                                width: 16.r,
                                height: 16.r,
                                  color: Color(0xffc1c1c1)
                              ),
                              Text(' 10  ',//likeCount
                                style: TextStyle(
                                  fontSize: 14.spMin,
                                  color: Color(0xffc1c1c1)
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/icon/icon_comment.svg',
                                width: 16.r,
                                height: 16.r,
                                  color: Color(0xffc1c1c1)
                              ),
                              Text(' 10',//commentCount
                                style: TextStyle(
                                    fontSize: 14.spMin,
                                    color: Color(0xffc1c1c1)
                                ),
                              ),
                            ],
                          )
                       ],
                      ),
                    ) //물건 설명

                  ],
                )
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index){
          return Container(
            height: 1.h, color: Color(0xffE5EBFF),
          );
        },
        itemCount:10
    );

  }
}
