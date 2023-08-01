import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_svg/svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Animation animation;

  bool isStart = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 5), () {
      setState(() {
        isStart = true;
      });
    });


    //5초 후에 넘어가기
    Timer(Duration(milliseconds: 5000), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff7898FF),
      body: Stack(
        children: <Widget>[
          AnimatedPositioned(
            duration: Duration(milliseconds: 3000),
            curve: Curves.elasticInOut,
            child: Container(
              child: SvgPicture.asset('assets/character/splash_eightstar.svg',
                width: 200, height: 200,
              ),
              alignment: Alignment.center,
            ),
            left: isStart? -30 : -200,
            top: isStart? -70 : -200,
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: 3000),
            curve: Curves.elasticInOut,
            child: Container(
              child: SvgPicture.asset('assets/character/splash_fivestar.svg',
              width: 120,
              height: 120,),
              alignment: Alignment.center,
            ),
            right: isStart? -60 : -120,
            top: 150,
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: 3000),
            curve: Curves.elasticInOut,
            child: SvgPicture.asset(
              'assets/character/splash_hi.svg',
            ),

            right: isStart? -200 : -500,
            bottom: isStart? -150 : -400,
          ),


          //title
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/character/splash_logo.svg'),
                RichText(
                  text:
                  EasyLocalization.of(context)!.locale == Locale.fromSubtags(languageCode: "ko", countryCode: "KR") ?
                  TextSpan(
                      children: [
                        TextSpan(text:'title1'.tr(), style: TextStyle(fontSize: 14, color: Colors.white),),
                        TextSpan(text:'title2'.tr(), style: TextStyle(fontSize: 14,color: Colors.white, fontWeight: FontWeight.bold)),
                      ]
                  ) :
                  TextSpan(
                      children: [
                        TextSpan(text:'title1'.tr(), style: TextStyle(fontSize: 14,color: Colors.white, fontWeight: FontWeight.bold)),
                        TextSpan(text:'title2'.tr(), style: TextStyle(fontSize: 14, color: Colors.white),),
                      ]
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
