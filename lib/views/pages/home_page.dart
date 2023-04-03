
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/matching_widget.dart' as matching;
import '../components/setting_widget.dart';
import '../components/chatting_widget.dart';
import '../components/home_widget.dart';


import 'package:aliens/providers/member_provider.dart';
import 'package:provider/provider.dart';

int selectedIndex = 0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    var memberDetails = Provider.of<MemberProvider>(context, listen: false);

    List _pageTitle = [
      '',
      '',
      '채팅',
      '설정',
    ];

    List _pageWidget = [
      Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
        ),
        child: Stack(children: [
          Column(
            children: [
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
                    alignment: Alignment.topLeft,
                    child: Text(
                      '로고 또는 어플 이름',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  )),
              Expanded(
                  flex: 4,
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
                              'HI, ${memberDetails.member.name}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('어플 메인 문구'),
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
                                    '매칭', 1, context, memberDetails),
                                SizedBox(
                                  width: 20,
                                ),
                                buildButton(
                                    '채팅', 2, context, memberDetails),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 100,
                          alignment: Alignment.topRight,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 15,
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
      matching.matchingWidget(context, memberDetails),
      chattingWidget(context),
      settingWidget(context, memberDetails)
    ];

    return FutureBuilder(
        future: memberDetails.memberInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //데이터를 받아오기 전 보여줄 위젯
          if (snapshot.hasData == false) {
            //로딩 화면으로 수정
            return Center(child: CircularProgressIndicator());
          }
          //오류가 생기면 보여줄 위젯
          else if (snapshot.hasError) {
            //오류가 생기면 보여줄 위젯
            //미정
            return Container();
          } else {
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
                backgroundColor: Colors.white,
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
                    icon: Icon(CupertinoIcons.question_circle),
                    color: Colors.black,
                  )
                ],
              ),
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
                    icon: Icon(Icons.home_filled),
                    label: '홈',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: '매칭',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_rounded),
                    label: '채팅',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: '설정',
                  )
                ],
              ),
              body: _pageWidget.elementAt(selectedIndex),
            );
          }
        });
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
}

