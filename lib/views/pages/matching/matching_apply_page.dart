import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';

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
              padding: const EdgeInsets.only(left: 24, right: 24).r,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 160.h,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.h, right: 30.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                          borderRadius: BorderRadius.circular(20).r,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          )
                        ]
                      ),
                      width: 176.w,
                      height: 37.h,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Let\'s friendship ! ',
                          style: TextStyle(
                            fontSize: 14.spMin,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff7898FF),
                          ),),
                          Text('\u{1F44B}',
                            style: TextStyle(
                              fontSize: 20.spMin,
                            ),),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 130.w, top: 10.h, bottom: 10.h),
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
                      width: 120.w,
                      height: 37.h,
                      child: Text('\u{1F9E1}\u{1F49B}\u{1F49A}\u{1F499}',
                      style: TextStyle(
                        fontSize: 20.spMin,
                      ),),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text('${'matching-soon'.tr()}',
                    style: TextStyle(fontSize: 24.spMin, fontWeight: FontWeight.bold,),),
                  RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text:'${'matching-preferlan'.tr()}', style: TextStyle(fontSize: 16.spMin, color: Color(0xff3666FF)),),
                            TextSpan(text: '${'matching-matchdone'.tr()}', style: TextStyle(fontSize: 16.spMin,color: Colors.black, height: 2)),
                                ]
                            ),
                      ),
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text:'${'matching-sf'.tr()}', style: TextStyle(fontSize: 16.spMin, color: Color(0xff3666FF),),),
                          TextSpan(text: '${'matching-add'.tr()}', style: TextStyle(fontSize: 16.spMin, color: Colors.black)),
                        ]
                    ),

                  ),
                  SizedBox(height: 120.h,),
                  Button(
                    //수정
                    isEnabled: true,
                    child: Text('${'matching-start'.tr()}'),
                    onPressed: (){
                      Navigator.pushNamed(context,'/choose', arguments: args);
                    },
                  ),
                ],
              ),
            ),

          ],
    );
  }
}

