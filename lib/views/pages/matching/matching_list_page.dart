import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

import '../../../models/screenArgument.dart';
import '../chatting/chatting_page.dart';

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height + 20, size.width, size.height - 100);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MatchingListPage extends StatefulWidget {
  final ScreenArguments screenArguments;

  const MatchingListPage({super.key, required this.screenArguments});

  @override
  State<MatchingListPage> createState() => _MatchingListPageState();
}

class _MatchingListPageState extends State<MatchingListPage> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff7898ff),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icon/icon_back.svg',
            height: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              height: MediaQuery.of(context).size.height * 3 / 5,
              decoration: BoxDecoration(
                color: Color(0xff7898ff),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Spacer(),
              Container(
                child: Text(
                  '매칭 완료 !',
                  style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  '4명의 친구와 매칭되었어요!',
                  style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18, color: Colors.white),
                ),
                alignment: Alignment.center,
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < widget.screenArguments.partners['partners'].length; i++)
                    MatchingList(
                      partner: widget.screenArguments.partners['partners'][i],
                      onPressed: () {
                        setState(() {
                          selectedIndex = i;
                        });
                      },
                      isClicked: selectedIndex == i,
                    ),
                ],
              ),
              Spacer(
                flex: isSmallScreen ? 6 : 8,
              ),
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
                              if (selectedIndex != -1) {
                                //login페이지를 push
                                /*
                                Navigator.pushNamed(context, '/chatting',
                                    arguments: widget.partners['partners']
                                        [selectedIndex]);*/
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChattingPage(screenArguments: widget.screenArguments, memberIndex: selectedIndex)),
                                );

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
                                color: selectedIndex == -1
                                    ? Color(0xff888888)
                                    : Colors.white,
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                backgroundColor: selectedIndex == -1
                                    ? Color(0xffEBEBEB)
                                    : Color(0xff7898FF),
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0.5,
              offset: const Offset(0, 4)),
        ],
        gradient: widget.isClicked
            ? LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0.45, 0.55],
            transform: GradientRotation(math.pi / 2),
            colors: [
              Color(0xff95AEFF),
              Color(0xff4976ff),
            ])
            : LinearGradient(colors: [Colors.white, Colors.white]),
      ),
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: isSmallScreen ? 70 : 80,
            width: isSmallScreen ? 300 : 350,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  //내부 그림자
                  BoxShadow(
                    color: widget.isClicked
                        ? Colors.transparent
                        : Color(0xff7898FF).withOpacity(0.3),
                  ),

                  //버튼색

                  widget.isClicked
                      ? BoxShadow(
                    color: Color(0xff7898ff),
                    spreadRadius: -5.0,
                    blurRadius: 10,
                  )
                      : BoxShadow(
                    blurRadius: 10,
                    color: Colors.white,
                    offset: const Offset(-5, -5),
                  )
                ]),
            padding: EdgeInsets.only(left: 20, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    /*
                      Navigator.pushNamed(context, '/info/your',
                          arguments: widget.partner);

                       */
                    showDialog(
                        context: context,
                        builder: (_) => Center(
                          child: Container(
                            width: 340,
                            height: 275,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: 340,
                                    height: 225,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 50,
                                        ),
                                        Text(
                                          '${widget.partner['name']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 36,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Text(
                                            '안녕하세요! 경영학과 23학번 입니다!',
                                            style: TextStyle(
                                              color: Color(0xff888888),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xffF1F1F1),
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          padding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 15,
                                              right: 20),
                                          child: Stack(
                                            children: [
                                              Text(
                                                '       ${widget.partner['nationality']}, ${widget.partner['mbti']}',
                                                style: TextStyle(
                                                    fontSize: isSmallScreen
                                                        ? 14
                                                        : 16,
                                                    color:
                                                    Color(0xff616161)),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                bottom: 0,
                                                child: SvgPicture.asset(
                                                  'assets/flag/${widget.partner['nationality']}.svg',
                                                  width: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 340,
                                  height: 105,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(100),
                                              color: Colors.white),
                                          padding: EdgeInsets.all(5),
                                          child: SvgPicture.asset(
                                            'assets/icon/icon_profile.svg',
                                            color: Color(0xffEBEBEB),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          child: Icon(
                                            widget.partner['gender'] == 'MALE' ? Icons.male_rounded : Icons.female_rounded,
                                            size: 15,
                                            color: Color(0xff7898ff),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0xffebebeb),
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
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
                                      ? Color(0xffFFB5B5)
                                      : Color(0xffFFF3C7),
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
                  child: SvgPicture.asset(
                    'assets/flag/${widget.partner['nationality']}.svg',
                    height: 30,
                    width: 50,
                  ),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 3),
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.2),
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
