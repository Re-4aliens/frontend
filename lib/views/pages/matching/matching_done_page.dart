import 'dart:convert';

import 'package:aliens/models/screenArgument.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:transition/transition.dart';

import 'matching_list_page.dart';

class MatchingDonePage extends StatefulWidget {
  const MatchingDonePage({super.key});

  @override
  State<MatchingDonePage> createState() => _MatchingDonePageState();
}

class _MatchingDonePageState extends State<MatchingDonePage> {
  @override
  Widget build(BuildContext context) {

    final screenArguments = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

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
            icon: Icon(Icons.arrow_back_ios_new),
            color: Color(0xff212121),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(flex: 1, child: Container()),
              Text(
                '매칭이 완료되었어요!',
                style: TextStyle(
                  fontSize: isSmallScreen ? 22 : 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '새로운 친구를 만나러 가볼까요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: 300,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 40,
                        left: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          width: 50,
                          height: 50,
                        ),
                      ),
                      Positioned(
                        top: 80,
                        right: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          width: 80,
                          height: 80,
                        ),
                      ),
                      Positioned(
                        bottom: 80,
                        right: 70,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(78),
                          ),
                          width: 156,
                          height: 156,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    /*
                    setState(() {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        barrierColor: Colors.white,
                        backgroundColor: Colors.white,
                        builder: (context) {
                          return BottomBar(
                            partners: partners,
                          );
                        },
                      );
                    });

                     */
                    Navigator.push(
                      context,
                      Transition(
                          child: MatchingListPage(screenArguments: screenArguments,), transitionEffect: TransitionEffect.BOTTOM_TO_TOP),);
                  },
                  onVerticalDragStart: (DragStartDetail){
                    Navigator.push(
                      context,
                      Transition(
                          child: MatchingListPage(screenArguments: screenArguments,), transitionEffect: TransitionEffect.BOTTOM_TO_TOP),);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '매칭 목록',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Icon(Icons.keyboard_arrow_down_outlined,
                              color: Colors.white),
                        ),
                        Expanded(flex: 4, child: Container()),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xff7898FF),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}


