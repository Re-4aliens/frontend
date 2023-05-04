import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

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
    Timer(Duration(milliseconds: 10), () {
      isStart = true;
    });


    //4초 후에 넘어가기
    Timer(Duration(milliseconds: 4000), () {
      Navigator.pushNamed(context, '/');
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
            duration: Duration(milliseconds: 2000),
            curve: Curves.elasticInOut,
            child: Image.asset(
              'assets/component_2.png',
              width: 200,
              height: 200,
            ),
            left: isStart? 0 : -200,
            top: isStart? 0 : -200,
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: 2000),
            curve: Curves.elasticInOut,
            child: Image.asset(
              'assets/component_1.png',
              width: 120,
              height: 120,
            ),
            right: isStart? 0 : -120,
            top: 150,
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: 2000),
            curve: Curves.elasticInOut,
            child: Image.asset(
              'assets/character.png',
              width: 400,
              height: 300,
            ),
            right: isStart? 0 : -400,
            bottom: isStart? 0 : -300,
          ),


          //title
          Center(
              child: Image.asset('assets/titleImage.png',height: 80,)
          )
        ],
      ),
    );
  }
}
