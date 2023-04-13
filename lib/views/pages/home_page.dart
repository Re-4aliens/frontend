
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
print(args.applicant);
    List _pageTitle = [
      '',
      '',
      '채팅',
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
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 70,
                      horizontal: 20,
                    ),
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text:'어서오세요!\n', style: TextStyle( fontSize: 20, color: Colors.black),),
                            TextSpan(text: '프렌드쉽', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                            TextSpan(text:'에 온 걸 환영해요.\n', style: TextStyle(fontSize: 24, color: Colors.black)),
                            TextSpan(text: '오늘의 내 기분은 해피!\n', style: TextStyle(fontSize: 12, color: Colors.black)),
                            TextSpan(text: '#파워긍정왕', style: TextStyle(fontSize: 12, color: Colors.black)),
                            TextSpan(text: 'ENFP', style: TextStyle(fontSize: 12, color: Color(0xff7898ff))),
                            TextSpan(text: '와 어울리는', style: TextStyle(fontSize: 12, color: Colors.black)),
                            TextSpan(text: 'MBTI', style: TextStyle(fontSize: 12, color: Color(0xff7898ff))),
                            TextSpan(text: '는?', style: TextStyle(fontSize: 12, color: Colors.black))
                          ]
                      ),
                    ),


                    ),
                  ),
              Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffefefef),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '설레는 새학기의 시작!, ${args.memberDetails['name']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('새로운 친구를 만나보세요.', style: TextStyle(fontSize: 16),),
                          ],
                        ),
                        Center(
                          child: Container(
                            //alignment: Alignment.center,
                            height: 245,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildButton(
                                    '매칭', 1, context, args.memberDetails),
                                SizedBox(
                                  width: 20,
                                ),
                                buildButton(
                                    '채팅', 2, context, args.memberDetails),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 60,
                          alignment: Alignment.topRight,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 5,
            right: 0,
            child: Container(
              height: 150,
              width: 150,
              child: Text('캐릭터/일러스트'),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ]),
      ),
      matching.matchingWidget(context, args),
      args.status['status'] == 'MATCHED'? matchingChattingWidget(context, args.partners):chattingWidget(context, args.partners),
      settingWidget(context, args.memberDetails)
    ];

    return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  _pageTitle.elementAt(selectedIndex),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: Column(
                  children: [
                    if (selectedIndex != 0)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        icon: Icon(Icons.arrow_back_ios_new),
                        color: Colors.black,
                      )
                    else
                      Container(),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    //아이콘 수정 필요
                    icon: SvgPicture.asset(
                      'assets/icon/icon_info.svg',
                      width: 24,
                      height: 24,
                      color: Color(0xff7898ff),
                    ),

                  )
                ],
              ),
              //extendBodyBehindAppBar: true,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: selectedIndex,
                selectedItemColor: Color(0xFF737373),
                unselectedItemColor: Color(0xFFBDBDBD),
                onTap: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icon/icon_home.svg',
                      width: 32.9,
                      height: 32.9,
                    ),
                    label: '홈',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icon/icon_matching.svg',
                      width: 32.9,
                      height: 32.9,
                    ),
                    label: '매칭',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icon/icon_chatting.svg',
                      width: 32.9,
                      height: 32.9,
                    ),
                    label: '채팅',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icon/icon_setting.svg',
                      width: 32.9,
                      height: 32.9,
                    ),
                    label: '설정',
                  )
                ],
              ),
              body: _pageWidget.elementAt(selectedIndex),
            );
  }

  Widget buildButton(String _title, int index,
      BuildContext context, memberDetails) {
    return MaterialButton(
      minWidth: 165,
      height: 245,
      elevation: 3.0,
      highlightElevation: 1.0,
      onPressed: () {
        setState(() {
          selectedIndex = index;
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      color: Colors.white,
      textColor: Colors.black,
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(54),
            ),
            width: 108,
            height: 108,
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            _title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
  Future<void> future()async {

  }
}

