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


class MarketBoardPage extends StatefulWidget {
  const MarketBoardPage({super.key});


  @override
  State<StatefulWidget> createState() => _MarketBoardPageState();
}

class _MarketBoardPageState extends State<MarketBoardPage> {

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
      body:Column(
        children: [
          InkWell(
            onTap: (){
            },
            child: Container(
              margin: EdgeInsets.only(right: 10,left: 10, top: 10, bottom: 10),
              padding: EdgeInsets.only(right: 10,left: 10),
              width: double.infinity,
              height: 42,
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
                        width: isSmallScreen?16:18,
                        height: isSmallScreen?16:18,
                      ),
                      Text(
                        '  ${'market-noti'.tr()}',
                        style: TextStyle(
                            fontSize: isSmallScreen?12:14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff616161)
                        ),
                      )
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: isSmallScreen?16:18,
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
          return Container(
            padding: EdgeInsets.only(right: 20,left: 20,top:12,bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    //여기 사진 넣기
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      color: Color(0xffF8F8F8),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: ClipRRect(
                            //사진이 있으면 없어질 것들
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Icon(Icons.add_photo_alternate,
                              color: Colors.grey,
                              size: 44,
                            ),
                          ),
                        ),
                        Positioned(
                          left:25,
                          right:25,
                          bottom: 10, // 아래로 0만큼 위치
                          child: Container(
                            height: 20,
                            child: Text(
                              '거의 새 것', //상태에 따라 글자 바뀌게
                              style: TextStyle(fontSize: 10, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              color: Color(0xff7898FF)
                            ),
                          ),
                        )

                      ],
                    ),
                  ), //물건 사진
                  SizedBox(width: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width -170 ,
                    height: 120, //높이를 물건사진의 높이와 같게
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '[판매중]',
                              style: TextStyle(
                                color: Color(0xff616161),
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            //Expanded(child: SizedBox()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('23.08.06',
                                  style: TextStyle(
                                    color: Color(0xffC1C1C1),
                                    fontSize: 12,
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
                                  child: Icon(
                                    Icons.more_vert,
                                    size: 16,
                                    color: Color(0xffC1C1C1),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Text('가죽쪼리 250 팔아요',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5,),//제목
                        Text('25,000원',
                          style: TextStyle(fontSize: 16,
                          fontWeight: FontWeight.w700),
                        ), //가격
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.thumb_up, color: Color(0xffC1C1C1),size: 16,),
                            Text(' 10  ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xffc1c1c1)
                              ),
                            ),
                            Icon(Icons.sms, color: Color(0xffC1C1C1),size: 16,),
                            Text(' 10',
                              style: TextStyle(
                                  fontSize: 14,
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
          );
        },
        separatorBuilder: (BuildContext context, int index){
          return Container(
            height: 1, color: Color(0xffE5EBFF),
          );
        },
        itemCount:10
    );
  }
}
