import 'dart:convert';

import 'package:aliens/models/screenArgument.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../components/button.dart';

import 'package:flutter/animation.dart';

import 'package:blobs/blobs.dart';


class MatchingStatePage extends StatefulWidget {
  const MatchingStatePage({super.key});

  @override
  State<MatchingStatePage> createState() => _MatchingStatePageState();
}

class _MatchingStatePageState extends State<MatchingStatePage> {

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/icon/icon_back.svg',
              height: 20,
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [

            Column(
              children: [
                Expanded(flex: 2, child: SizedBox()),
                Text(
                  '매칭 대기중...',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 22 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LinearPercentIndicator(
                    alignment: MainAxisAlignment.center,
                    animation: true,
                    restartAnimation: true,
                    lineHeight: 8,
                    percent: 1,
                    animationDuration: 8000,
                    width: 200,
                    progressColor: Color(0xff7898FF),
                    barRadius: const Radius.circular(16),
                    backgroundColor: Color(0xffDAE3FF),
                  ),
                ),
                SizedBox(
                  height: isSmallScreen ? 40 : 70,
                ),
                Stack(
                  children: [
                    Blob.animatedRandom(
                      size: isSmallScreen ? 170 : 200,
                      edgesCount:6,
                      //minGrowth:4,
                      duration:  Duration(milliseconds: 1000),
                      loop: true,
                      styles:  BlobStyles(
                          color:  Color(0xffFFB5B5)
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Blob.animatedRandom(
                        size: isSmallScreen ? 70 : 80,
                        edgesCount:6,
                        //minGrowth:4,
                        duration:  Duration(milliseconds: 1000),
                        loop: true,
                        styles:  BlobStyles(
                            color:  Color(0xffD8E1FF)
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: isSmallScreen ? 40 : 70,
                ),
                Text(
                  '조금만 기다려주세요.\n내 성향과 스타일에 꼭 맞는\n친구를 찾고 있어요!',
                  style: TextStyle(
                    color: Color(0xff616161),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(flex: 3, child: SizedBox()),
              ],
            ),
            Column(
              children: [
                Expanded(flex: isSmallScreen ? 8 : 7, child: Container()),
                Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 25, left: 25),
                        child: Positioned(
                          child: Button(
                            child: Text('나의 신청 확인하기'),
                            onPressed: () {
                              Navigator.pushNamed(context, '/info/my', arguments: args);
                            },
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ));
  }
}
