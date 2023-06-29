import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../../models/screenArgument.dart';
import '../../components/appbar.dart';
import '../../components/button.dart';

class MatchingApplyPage extends StatefulWidget {
  const MatchingApplyPage({super.key});

  @override
  State<MatchingApplyPage> createState() => _MatchingApplyPageState();
}

class _MatchingApplyPageState extends State<MatchingApplyPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    final double fontSize = isSmallScreen ? 16.0 : 20.0;

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: CustomAppBar(appBar: AppBar(),backgroundColor: Colors.transparent, infookay: false, infocontent: '', title: '',),
        extendBodyBehindAppBar: true,
        body: _buildBody(args, isSmallScreen),

    );
  }

  Widget _buildBody(args, isSmallScreen){
    return Stack(
          children: [
            Positioned(
              top: 0,
                bottom: 0,
                right: isSmallScreen ? -330 : -350,
                child: Container(
                    width: isSmallScreen ? 600 : 700,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xffD8E1FF))
                )),
            Positioned(
                bottom: -60,
                left: -80,
                child: Container(
                    width: isSmallScreen ? 350 : 420,
                    height: isSmallScreen ? 350 : 420,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xffF3F6FF))
                )),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, right: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          )
                        ]
                      ),
                      width: 176,
                      height: 37,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Let\'s friendship ! ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff7898FF),
                          ),),
                          Text('\u{1F44B}',
                            style: TextStyle(
                              fontSize: 20,
                            ),),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 130, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          color: Color(0xff7898ff),
                        borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            )
                          ]
                      ),
                      alignment: Alignment.center,
                      width: 120,
                      height: 37,
                      child: Text('\u{1F9E1}\u{1F49B}\u{1F49A}\u{1F499}',
                      style: TextStyle(
                        fontSize: 20,
                      ),),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text('곧 매칭신청이\n시작됩니다!',
                    style: TextStyle(fontSize: isSmallScreen ? 22 : 24, fontWeight: FontWeight.bold,),),
                  RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text:'\n선호언어', style: TextStyle(fontSize: isSmallScreen ? 14 : 16, color: Color(0xff3666FF)),),
                            TextSpan(text: '에 따라 매칭이 되며,', style: TextStyle(fontSize: isSmallScreen ? 14 : 16,color: Colors.black, height: 2)),
                                ]
                            ),
                      ),
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text:'랜덤 선호언어 친구(SF)', style: TextStyle(fontSize: isSmallScreen ? 14 : 16, color: Color(0xff3666FF),),),
                          TextSpan(text: '가 추가됩니다', style: TextStyle(fontSize: isSmallScreen ? 14 : 16, color: Colors.black)),
                        ]
                    ),

                  ),
                ],
              ),
            ),
            Column(
              children: [
                Expanded(flex: 7, child: Container()),
                Expanded(flex: 2, child: Container(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25,left: 25),
                    child: Positioned(
                      child: Button(
                        //수정
                        isEnabled: true,
                        child: Text('매칭 시작하기'),
                        onPressed: (){
                          Navigator.pushNamed(context,'/choose', arguments: args);
                        },
                      ),
                    ),
                  ),
                )),
              ],
            ),

          ],
    );
  }
}

