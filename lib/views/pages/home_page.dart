import '../../main.dart';
import '../../models/screenArgument.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/matching_widget.dart' as matching;
import '../components/setting_widget.dart';
import '../components/chatting_widget.dart';
import '../components/matching_chatting_widget.dart';

int selectedIndex = 0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    final double fontSize = isSmallScreen ? 16.0 : 20.0;

    List _pageTitle = [
      '',
      '',
      '설정',
    ];

    List _pageWidget = [
      Container(
        decoration: BoxDecoration(
          color: Color(0xffF2F5FF),
        ),
        child: Stack(children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '어서오세요!\n',
                        style: TextStyle(
                            fontSize: 20, color: Color(0xff5A5A5A), height: 1),
                      ),
                      TextSpan(
                          text: '프렌드쉽',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.5)),
                      TextSpan(
                          text: '에 온 걸 환영해요.\n',
                          style: TextStyle(
                              fontSize: 24, color: Color(0xff5A5A5A))),
                      TextSpan(
                          text: '오늘의 내 기분은 해피!\n',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff888888),
                              height: 2)),
                      TextSpan(
                          text: '#파워긍정왕 ',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff888888),
                              height: 1.5)),
                      TextSpan(
                          text: 'ENFP',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xff7898ff))),
                      TextSpan(
                          text: '와 어울리는 ',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xff888888))),
                      TextSpan(
                          text: 'MBTI',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xff7898ff))),
                      TextSpan(
                          text: '는?\n',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xff888888))),
                      TextSpan(
                          text: '자세히보기\n',
                          style: TextStyle(
                              fontSize: 12, color: Colors.black, height: 2.5))
                    ]),
                  ),
                ),
              ),
              Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 30 : 40,
                      horizontal: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '설레는 새학기의 시작!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff5C5C5C),
                              ),
                            ),
                            Text(
                              '새로운 친구를 만나보세요.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffababab),
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Center(
                          child: Container(
                            //alignment: Alignment.center,
                            height: isSmallScreen ? 210 : 240,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildButton(
                                    true, 0, context, args, isSmallScreen),
                                SizedBox(
                                  width: 20,
                                ),
                                buildButton(
                                    true, 1, context, args, isSmallScreen),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ))
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 10,
            right: 0,
            child: Container(
              height: isSmallScreen ? 130 : 150,
              width: isSmallScreen ? 130 : 150,
              child: Text('캐릭터/일러스트'),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xffFFB5B5),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ]),
      ),
      args.status['status'] == 'MATCHED'
          ? matchingChattingWidget(context, args.partners)
          : chattingWidget(context, args.partners),
      settingWidget(context, args.memberDetails)
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _pageTitle.elementAt(selectedIndex),
          style: TextStyle(
            fontSize: isSmallScreen?16:18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: selectedIndex == 1 ? 90 : 56,
        elevation: selectedIndex == 1 ? 7 : 0,
        shadowColor: Colors.black26,
        backgroundColor: selectedIndex == 1 ? Colors.white :Color(0xffF2F5FF),
        leadingWidth: 100,
        leading: Column(
          children: [
            if (selectedIndex == 2)
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    icon: SvgPicture.asset(
                      'assets/icon/icon_back.svg',
                      color: Color(0xff4D4D4D),
                      width: 24,
                      height: MediaQuery.of(context).size.height * 0.029,
                    ),
                    color: Colors.black,
                  ),
                ],
              )
            else if(selectedIndex == 1)
              Container(
                alignment: Alignment.center,
                height: 90,
                child: Text(
                  '채팅',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              )
            else
              Container(),
          ],
        ),
        actions: [
          if (selectedIndex == 0)
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icon/icon_info.svg',
                width: MediaQuery.of(context).size.width * 0.062,
                height: MediaQuery.of(context).size.height * 0.029,
                color: Color(0xff7898FF),
              ),
            )
          else
            Container(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Color(0xFF7898FF),
        unselectedItemColor: Color(0xFFD9D9D9),
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                'assets/icon/icon_home.svg',
                width: 25,
                height: 25,
                color: selectedIndex == 0 ? Color(0xFF7898FF) : Color(0xFFD9D9D9),
              ),
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                'assets/icon/icon_chatting.svg',
                width: 25,
                height: 25,
                color: selectedIndex == 1 ? Color(0xFF7898FF) : Color(0xFFD9D9D9),
              ),
            ),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                'assets/icon/icon_setting.svg',
                width: 25,
                height: 25,
                color: selectedIndex == 2 ? Color(0xFF7898FF) : Color(0xFFD9D9D9),
              ),
            ),
            label: '설정',
          )
        ],
      ),
      body: _pageWidget.elementAt(selectedIndex),
    );
  }

  Widget buildButton(
      bool clicked, int index, BuildContext context, args, bool isSmallScreen) {
    bool isClick = false;
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: [
        BoxShadow(
          blurRadius: 4,
          color: Colors.black26,
          spreadRadius: 1,
          offset: const Offset(0, 3),
        ),
      ]),
      child: Material(
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
        child: Ink(
          width: isSmallScreen ? 140 : 160,
          decoration: BoxDecoration(
            color: index == 0 ? Color(0xffAEC1FF) : Color(0xffFFB5B5),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: InkWell(
              onTap: () {
                print(clicked);
                if (args.status['status'] == 'NOT_APPLIED' &&
                    index == 1 &&
                    clicked) {
                  showDialog(
                      context: context,
                      builder: (_) => Stack(
                            children: [
                              Positioned(
                                top: MediaQuery.of(context).size.height / 10 +
                                    AppBar().preferredSize.height,
                                right: 0,
                                child: Container(
                                  height: isSmallScreen ? 130 : 150,
                                  width: isSmallScreen ? 130 : 150,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFB5B5),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height / 10 -
                                    10,
                                left: 25,
                                child: Container(
                                  height: isSmallScreen ? 40 : 50,
                                  width: isSmallScreen ? 260 : 310,
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: "아래의 ",
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 14,
                                              color: Color(0xff5c5c5c),
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: "매칭 신청 ",
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 14,
                                              color: Color(0xff7898FF),
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: "버튼을 눌러 매칭을 시작해보세요!",
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 14,
                                              color: Color(0xff5c5c5c),
                                              fontWeight: FontWeight.bold)),
                                    ]),
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(60),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                            color: Colors.black38,
                                            offset: const Offset(0, 3))
                                      ]),
                                ),
                              ),
                              Positioned(
                                  top: MediaQuery.of(context).size.height / 10,
                                  right: 30,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 11,
                                          left: 0,
                                          child: Container(
                                            height: 11,
                                            width: 11,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            height: 9,
                                            width: 9,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 7,
                                          right: 7,
                                          child: Container(
                                            height: 7,
                                            width: 7,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Positioned(
                                child: Column(
                                  children: [
                                    Expanded(flex: 3, child: Container()),
                                    Expanded(
                                        flex: 7,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmallScreen ? 30 : 40,
                                            horizontal: 25,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [],
                                              ),
                                              Expanded(child: Container()),
                                              Center(
                                                child: Container(
                                                  //alignment: Alignment.center,
                                                  height:
                                                      isSmallScreen ? 210 : 240,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      buildButton(
                                                          false,
                                                          0,
                                                          context,
                                                          args,
                                                          isSmallScreen),
                                                      SizedBox(
                                                        width: isSmallScreen
                                                            ? 160
                                                            : 180,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(child: Container()),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ));
                } else if (args.status['status'] == 'PENDING' &&
                    index == 0 &&
                    clicked) {
                  showDialog(
                      context: context,
                      builder: (_) => Stack(
                            children: [
                              Positioned(
                                top: MediaQuery.of(context).size.height / 10 +
                                    AppBar().preferredSize.height,
                                right: 0,
                                child: Container(
                                  height: isSmallScreen ? 130 : 150,
                                  width: isSmallScreen ? 130 : 150,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFB5B5),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height / 10 -
                                    30,
                                left: 25,
                                child: Container(
                                  height: isSmallScreen ? 50 : 60,
                                  width: isSmallScreen ? 270 : 320,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text:
                                              "${args.memberDetails['name']}님! 이미 매칭신청을 완료해 진행 중이에요:)\n아래의 ",
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 13,
                                              color: Color(0xff5c5c5c),
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: "매칭 진행 중 ",
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 13,
                                              color: Color(0xffFF8282),
                                              fontWeight: FontWeight.bold,
                                              height: 1.5)),
                                      TextSpan(
                                          text: "버튼을 눌러 확인해보세요!",
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 12 : 13,
                                            color: Color(0xff5c5c5c),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ]),
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(60),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                            color: Colors.black38,
                                            offset: const Offset(0, 3))
                                      ]),
                                ),
                              ),
                              Positioned(
                                  top: MediaQuery.of(context).size.height / 10,
                                  right: 30,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 11,
                                          left: 0,
                                          child: Container(
                                            height: 11,
                                            width: 11,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            height: 9,
                                            width: 9,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 7,
                                          right: 7,
                                          child: Container(
                                            height: 7,
                                            width: 7,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Positioned(
                                child: Column(
                                  children: [
                                    Expanded(flex: 3, child: Container()),
                                    Expanded(
                                        flex: 7,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmallScreen ? 30 : 40,
                                            horizontal: 25,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [],
                                              ),
                                              Expanded(child: Container()),
                                              Center(
                                                child: Container(
                                                  //alignment: Alignment.center,
                                                  height:
                                                      isSmallScreen ? 210 : 240,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: isSmallScreen
                                                            ? 160
                                                            : 180,
                                                      ),
                                                      buildButton(
                                                          false,
                                                          1,
                                                          context,
                                                          args,
                                                          isSmallScreen),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(child: Container()),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ));
                } else if (args.status['status'] == 'MATCHED' &&
                    index == 0 &&
                    clicked) {
                  showDialog(
                      context: context,
                      builder: (_) => Stack(
                            children: [
                              Positioned(
                                top: MediaQuery.of(context).size.height / 10 +
                                    AppBar().preferredSize.height,
                                right: 0,
                                child: Container(
                                  height: isSmallScreen ? 130 : 150,
                                  width: isSmallScreen ? 130 : 150,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFB5B5),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height / 10 -
                                    30,
                                left: 25,
                                child: Container(
                                  height: isSmallScreen ? 50 : 60,
                                  width: isSmallScreen ? 250 : 300,
                                  child: RichText(
                                    textAlign: TextAlign.end,
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text:
                                              "${args.memberDetails['name']}님! 드디어 매칭이 완료되었어요!\n아래의 ",
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 13,
                                              color: Color(0xff5c5c5c),
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: "채팅하기 ",
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 13,
                                              color: Color(0xffFF8282),
                                              fontWeight: FontWeight.bold,
                                              height: 1.5)),
                                      TextSpan(
                                          text: "버튼을 눌러 채팅을 시작해보세요!",
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 12 : 13,
                                            color: Color(0xff5c5c5c),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ]),
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(60),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                            color: Colors.black38,
                                            offset: const Offset(0, 3))
                                      ]),
                                ),
                              ),
                              Positioned(
                                  top: MediaQuery.of(context).size.height / 10,
                                  right: 40,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 11,
                                          left: 0,
                                          child: Container(
                                            height: 11,
                                            width: 11,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            height: 9,
                                            width: 9,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 7,
                                          right: 7,
                                          child: Container(
                                            height: 7,
                                            width: 7,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Positioned(
                                child: Column(
                                  children: [
                                    Expanded(flex: 3, child: Container()),
                                    Expanded(
                                        flex: 7,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmallScreen ? 30 : 40,
                                            horizontal: 25,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [],
                                              ),
                                              Expanded(child: Container()),
                                              Center(
                                                child: Container(
                                                  //alignment: Alignment.center,
                                                  height:
                                                      isSmallScreen ? 210 : 240,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: isSmallScreen
                                                            ? 160
                                                            : 180,
                                                      ),
                                                      buildButton(
                                                          false,
                                                          1,
                                                          context,
                                                          args,
                                                          isSmallScreen),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(child: Container()),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ));
                } else if (args.status['status'] == 'PENDING' &&
                    index == 1 &&
                    clicked) {
                  print('매칭 상태 확인 ㄱ');
                  Navigator.pushNamed(context, '/state', arguments: args);
                } else if (args.status['status'] == 'NOT_APPLIED' &&
                    index == 0 &&
                    clicked) {
                  Navigator.pushNamed(context, '/apply', arguments: args);
                } else if (args.status['status'] == 'MATCHED' &&
                    index == 1 &&
                    clicked) {
                  Navigator.pushNamed(context, '/done',
                      arguments: args.partners);
                } else {}
              },
              onTapDown: (TapDownDetails details) {
                setState(() {
                  isClick = true;
                });
              },
              onTapUp: (TapUpDetails details) {
                setState(() {
                  isClick = false;
                });
              },
              borderRadius: const BorderRadius.all(
                Radius.circular(30),
              ),
              child: index == 0
                  ? matchingButton(isSmallScreen, isClick, args.status)
                  : chattingButton(isSmallScreen, isClick, args.status)),
        ),
      ),
    );
  }

  Widget matchingButton(isSmallScreen, isClick, status) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          //내부 그림자
          BoxShadow(
            color: status['status'] != 'NOT_APPLIED'
                ? Color(0xffCBCBCB)
                : Color(0xff678CFF),
          ),
          //버튼색
          BoxShadow(
            blurRadius: 7,
            color: status['status'] != 'NOT_APPLIED'
                ? Color(0xffE0E0E0)
                : Color(0xffAEC1FF),
            spreadRadius: 14,
            offset: const Offset(-20, -20),
          ),
        ]),
        child: Stack(
          children: [
            //큰원
            Positioned(
              right: -35,
              bottom: -25,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(75),
                ),
                width: isSmallScreen ? 130 : 150,
                height: isSmallScreen ? 130 : 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          //큰원 내부그림자
                          BoxShadow(
                            color: status['status'] != 'NOT_APPLIED'
                                ? Color(0xffCBCBCB)
                                : Color(0xff678CFF),
                          ),
                          //큰원색
                          BoxShadow(
                            blurRadius: 7,
                            color: status['status'] != 'NOT_APPLIED'
                                ? Color(0xffEBEBEB)
                                : Color(0xFFCAD6FE),
                            spreadRadius: -2,
                            offset: const Offset(-40, -30),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            //작은 원
            Positioned(
              left: -25,
              top: -25,
              child: Container(
                decoration: BoxDecoration(
                  color: isClick
                      ? Color(0xff3762EC)
                      : status['status'] != 'NOT_APPLIED'
                          ? Color(0xffD7D7D7)
                          : Color(0xFF99B1FF),
                  borderRadius: BorderRadius.circular(50),
                ),
                width: isSmallScreen ? 90 : 100,
                height: isSmallScreen ? 90 : 100,
              ),
            ),
            Container(
              height: isSmallScreen ? 210 : 240,
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status['status'] != 'NOT_APPLIED' ? '신청완료' : '매칭신청',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 18 : 20,
                      color: status['status'] != 'NOT_APPLIED'
                          ? Color(0xffACACAC)
                          : Colors.white,
                    ),
                  ),
                  Text(
                    'How to Use?',
                    style: TextStyle(
                        fontSize: 12,
                        color: status['status'] != 'NOT_APPLIED'
                            ? Color(0xff888888)
                            : Color(0xff7898FF)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chattingButton(isSmallScreen, isClick, status) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((25)),
            boxShadow: [
              //내부그림자
              BoxShadow(
                color: status['status'] == 'NOT_APPLIED'
                    ? Color(0xffCBCBCB)
                    : Color(0xffFF9393),
              ),
              //버튼색
              BoxShadow(
                blurRadius: 7,
                color: status['status'] == 'NOT_APPLIED'
                    ? Color(0xffE0E0E0)
                    : Color(0xffFFB5B5),
                spreadRadius: 14,
                offset: const Offset(-20, -20),
              ),
            ]),
        child: Stack(
          children: [
            Positioned(
              right: -35,
              top: -45,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(75),
                ),
                width: isSmallScreen ? 130 : 150,
                height: isSmallScreen ? 130 : 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: status['status'] == 'NOT_APPLIED'
                                ? Color(0xffCBCBCB)
                                : Color(0xffFF9393),
                          ),
                          BoxShadow(
                            blurRadius: 7,
                            color: status['status'] == 'NOT_APPLIED'
                                ? Color(0xffEBEBEB)
                                : Color(0xFFFFCECE),
                            spreadRadius: -2,
                            offset: const Offset(-40, 30),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            Positioned(
              left: -25,
              bottom: -25,
              child: Container(
                decoration: BoxDecoration(
                  color: status['status'] == 'NOT_APPLIED'
                      ? Color(0xffD7D7D7)
                      : Color(0xFFFFA6A6),
                  borderRadius: BorderRadius.circular(50),
                ),
                width: isSmallScreen ? 90 : 100,
                height: isSmallScreen ? 90 : 100,
              ),
            ),
            Container(
              height: isSmallScreen ? 210 : 240,
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status['status'] == 'PENDING' ? '매칭 진행 중' : '채팅하기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 18 : 20,
                      color: status['status'] == 'NOT_APPLIED'
                          ? Color(0xffACACAC)
                          : Colors.white,
                    ),
                  ),
                  Text(
                    'How to Use?',
                    style: TextStyle(
                        fontSize: 12,
                        color: status['status'] == 'NOT_APPLIED'
                            ? Color(0xff888888)
                            : Color(0xffFF8F8F)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
