import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aliens/apis/apis.dart';

import '../../../apis/apis.dart';
import '../../../models/screenArgument.dart';

class MatchingChoosePage extends StatefulWidget {
  const MatchingChoosePage({super.key});

  @override
  State<MatchingChoosePage> createState() => _MatchingChoosePageState();
}

class _MatchingChoosePageState extends State<MatchingChoosePage> {
  var selectedStack = -1;
  var selectedIndex = [-1, -1];
  static final storage = FlutterSecureStorage();

  final List<Map<String, dynamic>> nationlist = [
    {
      'language': '한국어',
      'lan': 'kr',
      'value': 'KOREAN',
      'puzzle': 'assets/character/yellow_puzzle.svg',
    }, //한국어
    {
      'language': 'English',
      'lan': 'EN',
      'value': 'ENGLISH',
      'puzzle': 'assets/character/blue_puzzle.svg',
    }, //영어
    {
      'language': '中國語',
      'lan': 'CN',
      'value': 'JAPANESE',
      'puzzle': 'assets/character/pink_puzzle.svg',
    },//중국어
    {
      'language': '日本語',
      'lan': 'JP',
      'value': 'CHINESE',
      'puzzle': 'assets/character/green_puzzle.svg',
    }//일본어
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
              color: Color(0xff4D4D4D),
              width: 24,
              height: MediaQuery.of(context).size.height * 0.029,),
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
                                    width: MediaQuery.of(context).size.width * 0.062,
                                    height: MediaQuery.of(context).size.height * 0.029,
                                  ),
                                ),
                                Text('${'matching-chooseinfo'.tr()}',
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
                width: MediaQuery.of(context).size.width * 0.062,
                height: MediaQuery.of(context).size.height * 0.029,
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
                              onPressed: () async {
                                //success
                                if (selectedIndex[0] != -1 &&
                                    selectedIndex[1] != -1) {
                                  //신청 요청
                                  var success;
                                  try {
                                    success = await APIs.applicantMatching(nationlist[selectedIndex[0]]['value'], nationlist[selectedIndex[1]]['value']);
                                  } catch (e) {
                                    if(e == "AT-C-002"){
                                      try{
                                        await APIs.getAccessToken();
                                      }catch (e){
                                        if(e == "AT-C-005") {
                                          //토큰 및 정보 삭제
                                          await storage.delete(key: 'auth');
                                          await storage.delete(key: 'token');
                                          print('로그아웃, 정보 지움');

                                          //스택 비우고 화면 이동
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
                                          );
                                        }else if(e == "AT-C-007"){
                                          //토큰 및 정보 삭제
                                          await APIs.logOut(context);
                                        }
                                        else{
                                          success = await APIs.applicantMatching(nationlist[selectedIndex[0]]['value'], nationlist[selectedIndex[1]]['value']);
                                        }
                                      }
                                    }
                                    else if(e == "AT-C-007"){
                                      //토큰 및 정보 삭제
                                      await APIs.logOut(context);
                                    }

                                    else{
                                      success = await APIs.applicantMatching(nationlist[selectedIndex[0]]['value'], nationlist[selectedIndex[1]]['value']);
                                    }
                                  }
                                  if(success){
                                    //페이지 이동
                                    Navigator.pushNamed(context, '/apply/done', arguments: args);
                                  }else{
                                    print('요청 실패');
                                  };
                                } else {
                                  //fail
                                };
                              },
                              child: Text(
                                selectedIndex[0] == -1
                                    ? '${'matching-chooselan'.tr()}'
                                    : selectedIndex[1] == -1
                                        ? '${'matching-choosetwo'.tr()}'
                                        : '${'done'.tr()}',
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
                    Padding(
                      padding: const EdgeInsets.only(right: 25,left: 25),
                      child: Column(
                        children: [
                          Text(
                            '${'matching-chooselan'.tr()}',
                            style: TextStyle(
                              fontSize: isSmallScreen?22:24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height *0.03 ,
                          ),
                          Text(
                            '${'matching-choosedetail'.tr()}',
                            style: TextStyle(fontSize: isSmallScreen?14:16, color: Color(0xff616161)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.047,
                    ),
                    for (int i = 0; i < 2; i++)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LanguageButton(
                                  language: nationlist[2 * i]['language'],
                                  lan : nationlist[2 * i]['lan'],
                                  puzzle: nationlist[2 * i]['puzzle'],
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
                                          selectedIndex[1] == (2 * i);
                                        }
                                      }
                                    });
                                  },
                                /*puzzle : nationlist[2 * i],*/),
                              SizedBox(
                                width: 20,
                              ),
                              LanguageButton(
                                language: nationlist[2 * i+1]['language'],
                                lan : nationlist[2 * i+1]['lan'],
                                puzzle: nationlist[2 * i+1]['puzzle'],                                  selectedFirst:
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
                                  },
                               )
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

  final language;
  final lan;
  final selectedFirst;
  final selectedSecond;
  final puzzle;
  final VoidCallback onPressed;

  const LanguageButton(
      {Key? key,
        required this.language,
        required this.lan,
        required this.selectedFirst,
        required this.selectedSecond,
        required this.puzzle,
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
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
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
                      child : SvgPicture.asset(puzzle,
                        width: isSmallScreen?40:45,
                        height: isSmallScreen?40:45,
                      )
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
                      language,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen?18:20,
                        color: selectedFirst || selectedSecond
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      lan,
                      style: TextStyle(
                        fontSize: isSmallScreen?10:12,
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
