import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class MatchingDonePage extends StatefulWidget {
  const MatchingDonePage({super.key});

  @override
  State<MatchingDonePage> createState() => _MatchingDonePageState();
}

class _MatchingDonePageState extends State<MatchingDonePage> {
  @override
  Widget build(BuildContext context) {
    dynamic partners = ModalRoute.of(context)!.settings.arguments;

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
                child: InkWell(
                  onTap: () {
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

class BottomBar extends StatefulWidget {
  final dynamic partners;

  const BottomBar({super.key, required this.partners});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Container(
      height: MediaQuery.of(context).size.height * 8 / 9,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Color(0xFFF5F7FF),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      margin: EdgeInsets.only(right: 15, top: 15),
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      alignment: Alignment.centerRight,
                    ),
                    Container(
                      //color: Colors.green,
                      height: 30,
                      child: Text(
                        '매칭 목록',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 9,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < widget.partners['partners'].length; i++)
                      MatchingList(
                        partner: widget.partners['partners'][i],
                        onPressed: () {
                          setState(() {
                            selectedIndex = i;
                          });
                        },
                        isClicked: selectedIndex == i,
                      ),
                  ],
                ),
              ),
              Expanded(flex: isSmallScreen ? 3 : 5, child: SizedBox())
            ],
          ),
          Column(
            children: [
              Expanded(flex: isSmallScreen ? 8 : 6, child: Container()),
              Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25, left: 25),
                      child: Positioned(
                        child: Container(
                          width: double.maxFinite,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {

                              if(selectedIndex != -1){

                                //login페이지를 push
                                Navigator.pushNamed(context, '/chatting', arguments: widget.partners['partners'][selectedIndex]);

/*
                                //스택 비우고
                                Navigator.of(context)
                                    .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false
                                );
                                //채팅 페이지를 push
                                Navigator.pushNamed(context, '/chat', arguments: widget.partners['partners'][selectedIndex]);
                        */
                              }
                            },
                            child: Text(
                              '채팅하기',
                              style: TextStyle(
                                color: selectedIndex == -1 ? Color(0xff888888) : Colors.white,
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                                backgroundColor: selectedIndex == -1 ? Color(0xffEBEBEB) : Color(0xff7898FF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class MatchingList extends StatefulWidget {
  final dynamic partner;
  final VoidCallback onPressed;
  final bool isClicked;

  const MatchingList(
      {super.key,
      required this.partner,
      required this.onPressed,
      required this.isClicked});

  @override
  State<MatchingList> createState() => _MatchingListState();
}

class _MatchingListState extends State<MatchingList> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0.5,
              offset: const Offset(0, 4)),
        ],
        color: widget.isClicked ? Color(0xff4976FF) : Colors.white,
      ),
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(30),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: isSmallScreen ? 70 : 80,
            width: isSmallScreen ? 300 : 350,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  //내부 그림자
                  BoxShadow(
                    color: widget.isClicked
                        ? Color(0xff4976FF)
                        : Color(0xff7898FF).withOpacity(0.3),
                  ),
                  //버튼색
                  BoxShadow(
                    blurRadius: 10,
                    color: widget.isClicked ? Color(0xff7898FF) : Colors.white,
                    offset: const Offset(-5, -5),
                  ),
                ]),
            padding: EdgeInsets.only(left: 20, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/info/your', arguments: widget.partner);
                  },
                  child: SvgPicture.asset(
                    'assets/icon/icon_profile.svg',
                    width: 50,
                    color: Color(0xffEBEBEB),
                  ),
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${widget.partner['name']}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 20,
                              fontWeight: FontWeight.bold,
                              color: widget.isClicked
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 18,
                            width: 18,
                            child: widget.partner['gender'] == 'MALE'
                                ? Icon(
                                    Icons.male_rounded,
                                    size: 15,
                              color: Colors.white,
                                  )
                                : Icon(
                                    Icons.female_rounded,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                            decoration: BoxDecoration(
                              color: widget.partner['gender'] == 'MALE'
                                  ? Color(0xffFFB5B5) : Color(0xffFFF3C7),
                              borderRadius: BorderRadius.circular(9),
                            ),
                          )
                        ],
                      ),
                      Text(
                        '${widget.partner['mbti']}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: widget.isClicked
                              ? Colors.white
                              : Color(0xffA4A4A4),
                        ),
                      ),
                    ],
                  ),
                )),
                Container(
                  height: 30,
                  width: 50,
                  child: SvgPicture.asset(
                    'assets/flag/${widget.partner['nationality']}.svg',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
