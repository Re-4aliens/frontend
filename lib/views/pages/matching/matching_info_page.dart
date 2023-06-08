import 'dart:convert';
import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/screenArgument.dart';

class MatchingInfoPage extends StatefulWidget {
  const MatchingInfoPage({super.key});

  @override
  State<MatchingInfoPage> createState() => _MatchingInfoPageState();
}

class _MatchingInfoPageState extends State<MatchingInfoPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: CustomAppBar(appBar: AppBar(), backgroundColor: Colors.transparent, infookay: false, infocontent: '', title: '나의 신청 확인',),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      color: Colors.black.withOpacity(0.1)
                    )
                  ]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: Colors.white,
                    width: isSmallScreen ? 310 : 350,
                    child:
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Color(0xff4976FF),),
                              //버튼색
                              BoxShadow(
                                blurRadius: 10,
                                color: Color(0xff7898FF),
                                offset: const Offset(-5, -5),
                              ),
                            ]
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -80,
                                left: -40,
                                child: Container(
                                  width: 180,
                                  height: 180,
                                  margin: EdgeInsetsDirectional.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    color: Color(0xff94ADFF),
                                  ),
                                ),),
                              Positioned(
                                bottom: 100,
                                right: 60,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  margin: EdgeInsetsDirectional.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    color: Color(0xff6D90FF),
                                  ),
                                ),),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(flex: 5, child: Container()),
                                  Container(
                                    margin: EdgeInsetsDirectional.symmetric(vertical: 20),
                                    child: SvgPicture.asset(
                                      'assets/icon/icon_profile.svg',
                                      height: isSmallScreen ? 100 : 120,
                                      color: Color(0xffEBEBEB),
                                    ),
                                  ),
                                  Expanded(flex: 1, child: Container()),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff557EFF),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                                    child: Stack(
                                      children: [
                                        Text(
                                          '${args.applicant?.member?.name}      ',
                                          //'${args.applicant['member']['name']}      '
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 18 : 20, color: Colors.white),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Center(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Icon(Icons.female,
                                                color: Color(0xff7898ff),
                                              size: 20,),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(flex: 2, child: Container()),
                                  Container(
                                    margin: EdgeInsets.only(left: 40, right: 40, top: 25),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '국가',
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 12 : 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              '${args.applicant?.member?.nationality}',
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 18 : 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '만 나이',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: isSmallScreen ? 12 : 14,
                                              ),
                                            ),
                                            Text('${args.applicant?.member?.age}세',
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 18 : 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'MBTI',
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 12 : 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text('${args.applicant?.member?.mbti}',
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 18 : 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(flex: 4, child: Container()),
                                ],
                              ),
                            ],
                          ),
                        ),

                  ),
                ),
              ),
            ),
            Expanded(
              flex: 14,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    //color: Colors.blue.shade300,
                    ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 25),
                      decoration: BoxDecoration(
                          //color: Colors.blue,
                          ),
                      child: Text(
                        '매칭 선호 언어',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 14 : 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 4)),
                              ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              height: 117,
                              width: isSmallScreen ? 150 : 160,
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 25),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color(0xff7898FF).withOpacity(0.3)),
                                    //버튼색
                                    BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.white,
                                      offset: const Offset(-5, -5),
                                    ),
                                  ]),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: SizedBox()),
                                      Text(
                                        '1순위',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 12 : 14,
                                          color: Color(0xff7898ff),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text('${args.applicant?.preferLanguages?.firstPreferLanguage}',
                                        style: TextStyle(
                                          fontSize:isSmallScreen ? 18 : 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff888888),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      height:  isSmallScreen ? 34 : 45,
                                      width:  isSmallScreen ? 34 : 45,
                                      child: SvgPicture.asset('assets/character/yellow_puzzle.svg'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 4)),
                              ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              height: 117,
                              width: isSmallScreen ? 150 : 160,
                              padding: EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 25),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color(0xff7898FF).withOpacity(0.3)),
                                    //버튼색
                                    BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.white,
                                      offset: const Offset(-5, -5),
                                    ),
                                  ]),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: SizedBox()),
                                      Text(
                                        '2순위',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 12 : 14,
                                          color: Color(0xff7898ff),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text('${args.applicant?.preferLanguages?.secondPreferLanguage}',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 18 : 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff888888),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      height: isSmallScreen ? 34 : 45,
                                      width: isSmallScreen ? 34 : 45,
                                      child: SvgPicture.asset('assets/character/blue_puzzle.svg'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          //color: Colors.blue,
                          ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/edit');
                        },
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1.0, color: Color(0xFFC4C4C4))),
                          ),
                          child: Text(
                            '언어 재설정',
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: isSmallScreen ? 10 : 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
