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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icon/icon_back.svg',
              width: 24,
              height: MediaQuery.of(context).size.height * 0.029,

            ),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        ),
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
                right: isSmallScreen ? -300 : -330,
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
              padding: const EdgeInsets.only(left: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('매칭신청을 시작합니다!',
                    style: TextStyle(fontSize: isSmallScreen ? 20 : 25, fontWeight: FontWeight.bold,),),
                  RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text:'\n선호언어', style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 12 : 16, color: Colors.black),),
                            TextSpan(text: '에 따라 매칭이 되며,', style: TextStyle(fontSize: isSmallScreen ? 14 : 16,color: Colors.black, height: 2)),
                                ]
                            ),
                      ),
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text:'랜덤 선호언어 친구(SF)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 12 : 16, color: Colors.black),),
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

