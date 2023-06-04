import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_svg/svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
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
  void dispose() {
    super.dispose();
    controller.removeListener(() {
      controller.dispose();
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
            left: isStart? 0 : -200,
            top: isStart? 0 : -200,
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
            /*
            child: Image.asset(
              'assets/component_1.png',
              width: 120,
              height: 120,
            ),

             */
            right: isStart? 0 : -120,
            top: 150,
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: 3000),
            curve: Curves.elasticInOut,
            /*
            child: Image.asset(
              'assets/character.png',
              width: 400,
              height: 300,
            ),

             */
            child: SvgPicture.asset(
              'assets/character/splash_hi.svg',
            ),

            right: isStart? 0 : -400,
            bottom: isStart? 0 : -300,
          ),


          //title
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/character/splash_logo.svg'),
               // Text('타이틀 로고', style: TextStyle(fontSize: 25, color: Colors.white),),
                RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text:'내 손안의 ', style: TextStyle(fontSize: 14, color: Colors.white),),
                        TextSpan(text: '외국인 프렌즈', style: TextStyle(fontSize: 14,color: Colors.white, fontWeight: FontWeight.bold)),
                      ]
                  ),
                ),
              ],
            ),
            /*
              child: Image.asset('assets/titleImage.png',height: 80,)

             */
          )
        ],
      ),
    );
  }
}
