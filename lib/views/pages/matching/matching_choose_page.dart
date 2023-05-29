import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/screenArgument.dart';

class MatchingChoosePage extends StatefulWidget {
  const MatchingChoosePage({super.key});

  @override
  State<MatchingChoosePage> createState() => _MatchingChoosePageState();
}

class _MatchingChoosePageState extends State<MatchingChoosePage> {
  var selectedStack = -1;
  var selectedIndex = [-1, -1];

  List<List<String>> nationlist = [
    ['한국어', 'KR'],
    ['English', 'EN'],
    ['中國語', 'CN'],
    ['日本語', 'JP'],
  ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    final double fontSize = isSmallScreen ? 14.0 : 16.0;

    return Scaffold(
        backgroundColor: Color(0xFFF5F7FF),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xffF5F7FF),
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icon/icon_back.svg',
              height: 16,
            ),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              onPressed: () {

                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30) //모서리
                          ),
                          alignment: Alignment.center,
                          title: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: SvgPicture.asset(
                                    'assets/icon/icon_info.svg',
                                    color: Color(0xff7898ff),
                                    height: 25,
                                  ),
                                ),
                                Text('상대방과 대화할 때\n어떤 언어를 사용하길 원하시나요?\n언어 2가지를 선택 해주세요\n매칭 시 우선순위로 진행돼요!',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    height: 1.5,
                                  ),
                                textAlign: TextAlign.center,)
                              ],
                            ),
                          )

                        ),
                );
              },
              //아이콘 수정 필요
              icon: SvgPicture.asset(
                'assets/icon/icon_info.svg',
                width: 24,
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(flex: 7, child: SizedBox()),
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
                                //success
                                if (selectedIndex[0] != -1 &&
                                    selectedIndex[1] != -1) {
                                  //신청 요청
                                  //args.applicant['preferLanguages']['firstPreferLanguage'] = nationlist[selectedIndex[0]][0];
                                  //args.applicant['preferLanguages']['secondPreferLanguage'] = nationlist[selectedIndex[1]][0];
                                  //페이지 이동
                                  Navigator.pushNamed(context, '/apply/done', arguments: args);
                                } else {
                                  //fail
                                };
                              },
                              child: Text(
                                selectedIndex[0] == -1
                                    ? '선호언어를 선택해주세요'
                                    : selectedIndex[1] == -1
                                        ? '2가지를 선택해주세요'
                                        : '완료',
                                style: TextStyle(
                                  color: selectedIndex[0] != -1 &&
                                          selectedIndex[1] != -1
                                      ? Colors.white
                                      : Color(0xffA7A7A7),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: fontSize),
                                  backgroundColor: selectedIndex[0] != -1 &&
                                          selectedIndex[1] != -1
                                      ? Color(0xff7898FF)
                                      : Color(0xffEBEBEB), // 여기 색 넣으면됩니다
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  elevation: 0.0),
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
            Column(
              children: [
                Expanded(flex: 2, child: Container()),
                Column(
                  children: [
                    Text(
                      '선호언어 선택',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      '상대방과 원하는 언어로 대화할 수 있어요.\n선호도에 따라 4가지 언어 중 선택 가능합니다.',
                      style: TextStyle(fontSize: 16, color: Color(0xff616161)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    for (int i = 0; i < 2; i++)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LanguageButton(
                                  languageText: nationlist[2 * i],
                                  selectedFirst:
                                  selectedIndex[0] == (2 * i),
                                  selectedSecond:
                                  selectedIndex[1] == (2 * i),
                                  onPressed: () {
                                    setState(() {
                                      //첫 번째가 선택이 안됐으면
                                      if (selectedIndex[0] == -1) {
                                        print('첫 번째 선택');
                                        //본인을 넣는다.
                                        selectedIndex[0] = (2 * i);
                                        //첫 번째가 선택이 됐는데
                                      } else if (selectedIndex[0] != -1 &&
                                          selectedIndex[1] == -1) {
                                        //본인이면
                                        if (selectedIndex[0] == (2 * i)) {
                                          print('첫 번째 취소');
                                          //값을 없앤다.
                                          selectedIndex[0] = -1;
                                        }
                                        //본인이 아니면
                                        else {
                                          print('두 번째 선택');
                                          //두 번째에 값을 넣는다.
                                          selectedIndex[1] = (2 * i);
                                        }
                                        //두 번째가 선택이 됐는데
                                      } else if (selectedIndex[1] != -1) {
                                        //본인이면
                                        if (selectedIndex[1] == (2 * i)) {
                                          print('두 번째 취소');
                                          //값을 없앤다.
                                          selectedIndex[1] = -1;
                                        } //본인이 아닌데 1번 값이라면
                                        else if (selectedIndex[0] ==
                                            (2 * i)) {
                                          //변화 x
                                          print('첫번째꺼 이미선택됨');
                                        } //본인이 아니면
                                        else {
                                          print('두 번째 선택');
                                          //두 번째에 값을 넣는다.
                                          selectedIndex[1] = (2 * i);
                                        }
                                      }
                                    });
                                  }),
                              SizedBox(
                                width: 20,
                              ),
                              LanguageButton(
                                  languageText: nationlist[(2 * i + 1)],
                                  selectedFirst:
                                  selectedIndex[0] == (2 * i + 1),
                                  selectedSecond:
                                  selectedIndex[1] == (2 * i + 1),
                                  onPressed: () {
                                    setState(() {
                                      //첫 번째가 선택이 안됐으면
                                      if (selectedIndex[0] == -1) {
                                        print('첫 번째 선택');
                                        //본인을 넣는다.
                                        selectedIndex[0] = (2 * i + 1);
                                        //첫 번째가 선택이 됐는데
                                      } else if (selectedIndex[0] != -1 &&
                                          selectedIndex[1] == -1) {
                                        //본인이면
                                        if (selectedIndex[0] == (2 * i + 1)) {
                                          print('첫 번째 취소');
                                          //값을 없앤다.
                                          selectedIndex[0] = -1;
                                        }
                                        //본인이 아니면
                                        else {
                                          print('두 번째 선택');
                                          //두 번째에 값을 넣는다.
                                          selectedIndex[1] = (2 * i + 1);
                                        }
                                        //두 번째가 선택이 됐는데
                                      } else if (selectedIndex[1] != -1) {
                                        //본인이면
                                        if (selectedIndex[1] == (2 * i + 1)) {
                                          print('두 번째 취소');
                                          //값을 없앤다.
                                          selectedIndex[1] = -1;
                                        } //본인이 아닌데 1번 값이라면
                                        else if (selectedIndex[0] ==
                                            (2 * i + 1)) {
                                          //변화 x
                                          print('첫번째꺼 이미선택됨');
                                        } //본인이 아니면
                                        else {
                                          print('두 번째 선택');
                                          //두 번째에 값을 넣는다.
                                          selectedIndex[1] = (2 * i + 1);
                                        }
                                      }
                                    });
                                  })
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                  ],
                ),
                Expanded(flex: 3, child: Container()),
              ],
            ),
          ],
        ));
  }
}

class LanguageButton extends StatelessWidget {
  final List<String> languageText;
  final selectedFirst;
  final selectedSecond;
  final VoidCallback onPressed;

  const LanguageButton(
      {Key? key,
      required this.languageText,
      required this.selectedFirst,
      required this.selectedSecond,
      required this.onPressed})
      : super(key: key);

  Color changeColor(bool selectedFirst, bool selectedSecond) {
    if (selectedFirst == true)
      return Color(0xff7898FF);
    else if (selectedSecond == true)
      return Color(0xffFFB5B5);
    else
      return Colors.white;
  }

  Color changeShadowColor(bool selectedFirst, bool selectedSecond) {
    if (selectedFirst == true)
      return Color(0xff4976FF);
    else if (selectedSecond == true)
      return Color(0xffFF9393);
    else
      return Color(0xff7898FF).withOpacity(0.3);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: changeColor(selectedFirst, selectedSecond),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0.5,
              offset: const Offset(0, 4)),
        ],
        borderRadius: BorderRadius.circular(25),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            height: 117,
            width: 165,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  //내부 그림자
                  BoxShadow(
                      color: changeShadowColor(selectedFirst, selectedSecond)),
                  //버튼색
                  BoxShadow(
                    blurRadius: 10,
                    color: changeColor(selectedFirst, selectedSecond),
                    offset: const Offset(-5, -5),
                  ),
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: selectedFirst || selectedSecond
                            ? Colors.white
                            : Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      alignment: Alignment.center,
                      child: selectedFirst
                          ? Text(
                              '1',
                              style: TextStyle(
                                color: Color(0xff7898FF),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : selectedSecond
                              ? Text(
                                  '2',
                                  style: TextStyle(
                                    color: Color(0xffffb5b5),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageText[0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: selectedFirst || selectedSecond
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      languageText[1],
                      style: TextStyle(
                        fontSize: 12,
                        color: selectedFirst || selectedSecond
                            ? Colors.white
                            : Color(0xff888888),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
