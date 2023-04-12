import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/screenArgument.dart';
import '../../components/button.dart';

class MatchingChoosePage extends StatefulWidget {
  const MatchingChoosePage({super.key});

  @override
  State<MatchingChoosePage> createState() => _MatchingChoosePageState();
}

class _MatchingChoosePageState extends State<MatchingChoosePage> {
  var selectedStack = -1;
  var selectedIndex = [-1, -1];
  static final storage = FlutterSecureStorage();

  //언어 리스트 불러오는 함수
  Future<List?> getLanguageList() async {
    List<String> languageTextList = [];
    try {
      const url =
          'http://13.125.205.59:8080/api/v1/matching/languages'; //mocksever

      //토큰 읽어오기
      var jwtToken = await storage.read(key: 'token');

      //accessToken만 보내기
      jwtToken = json.decode(jwtToken!)['accessToken'];

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'
        },
      );

      //success
      if (response.statusCode == 200) {
        print(response.body);
        var listLength =
            json.decode(response.body)['response']['languages'].length;
        for (int i = 0; i < listLength; i++) {
          languageTextList.add(json.decode(response.body)['response']
              ['languages'][i]['languageText']);
        }
      } else {
        //오류 생기면 상태 확인
        print("요청 오류: " + response.statusCode.toString());
      }
    } catch (error) {
      print(error);
      return null;
    }

    //리스트 반환
    return languageTextList;
  }



  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
        backgroundColor: Color(0xFFF4F4F4),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFF4F4F4),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
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
        body: Column(
          children: [
            Expanded(flex: 1, child: Container()),
            FutureBuilder(
                future: getLanguageList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData == false)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else if (snapshot.hasError) {
                    return Container();
                  } else {
                    var isEven = false;
                    var index;
                    if (snapshot.data!.length % 2 == 0) {
                      isEven = true;
                      index = snapshot.data!.length / 2;
                    } else {
                      index = snapshot.data!.length / 2 - 1;
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            '매칭 선호 언어 선택',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '상대방과 원하는 언어로 대화할 수 있어요.\n선호도에 따라 두가지 언어로 선택 가능합니다.',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          for (int i = 0; i < index; i++)
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    languageButton(
                                        snapshot.data!.toList()[2 * i],
                                        selectedIndex[0] == (2 * i),
                                        selectedIndex[1] == (2 * i), () {
                                      setState(() {
                                        //첫 번째가 선택이 안됐으면
                                        if (selectedIndex[0] == -1) {
                                          print('첫 번째 선택');
                                          //본인을 넣는다.
                                          selectedIndex[0] = (2 * i);
                                          //첫 번째가 선택이 됐는데
                                        } else if (selectedIndex[0] != -1 && selectedIndex[1] == -1) {
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
                                        } else if (selectedIndex[1] != -1) {
                                          //본인이면
                                          if (selectedIndex[1] == (2 * i)) {
                                            print('두 번째 취소');
                                            //값을 없앤다.
                                            selectedIndex[1] = -1;
                                          }
                                          //본인이 아니면
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
                                    languageButton(
                                        snapshot.data!.toList()[(2 * i + 1)],
                                        selectedIndex[0] == (2 * i + 1),
                                        selectedIndex[1] == (2 * i + 1), () {
                                      setState(() {
                                        //첫 번째가 선택이 안됐으면
                                        if (selectedIndex[0] == -1) {
                                          print('첫 번째 선택');
                                          //본인을 넣는다.
                                          selectedIndex[0] = (2 * i + 1);
                                          //첫 번째가 선택이 됐는데
                                        } else if (selectedIndex[0] != -1 && selectedIndex[1] == -1) {
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
                                          }//본인이 아니면
                                          else {
                                            print('두 번째 선택');
                                            //두 번째에 값을 넣는다.
                                            selectedIndex[1] = (2 * i + 1);
                                          }
                                        }
                                      });
                                    }),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          isEven
                              ? SizedBox(
                                  height: 0,
                                )
                              : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        languageButton(
                                            snapshot.data!.toList()[(snapshot.data!.length - 1)],
                                            selectedIndex[0] == (snapshot.data!.length - 1),
                                            selectedIndex[1] == (snapshot.data!.length - 1), () {
                                          setState(() {
                                            //첫 번째가 선택이 안됐으면
                                            if (selectedIndex[0] == -1) {
                                              //본인을 넣는다.
                                              print('첫 번째 선택');
                                              selectedIndex[0] = (snapshot.data!.length - 1);
                                              //첫 번째가 선택이 됐는데
                                            } else if (selectedIndex[0] != -1 && selectedIndex[1] == -1) {
                                              //본인이면
                                              if (selectedIndex[0] == (snapshot.data!.length - 1)) {
                                                //값을 없앤다.
                                                print('첫 번째 취소');
                                                selectedIndex[0] = -1;
                                              }
                                              //본인이 아니면
                                              else {
                                                print('두 번째 선택');
                                                //두 번째에 값을 넣는다.
                                                selectedIndex[1] = 4;
                                              }
                                            } else if (selectedIndex[1] != -1) {
                                              if (selectedIndex[1] == 4) {
                                                print('두 번째 취소');
                                                //값을 없앤다.
                                                selectedIndex[1] = -1;
                                              }//본인이 아니면
                                              else {
                                                print('두 번째 선택');
                                                //두 번째에 값을 넣는다.
                                                selectedIndex[1] = 4;
                                              }
                                            }
                                          });
                                        }),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          height: 117,
                                          width: 165,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Button(
                                child: Text('확인'),
                                onPressed: () async {
                                  //success
                                  if (args.status['status'] == 'MATCHED' &&selectedIndex[0] != -1 && selectedIndex[1] != -1) {
                                    //신청 요청

                                    //페이지 이동
                                    Navigator.pushNamed(context, '/apply/done', arguments: args);
                                    //fail
                                  } else {
                                    showDialog(context: context, builder: (BuildContext context) => CupertinoAlertDialog(
                                      title: Text('신청 실패',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text('확인',
                                              style: TextStyle(
                                                color: Colors.black,
                                              )),
                                        ),
                                      ],
                                    ));
                                  };
                                }),
                          )
                        ],
                      ),
                    );
                  }
                }),
            Expanded(flex: 2, child: Container()),
          ],
        ));
  }

  Widget languageButton(String languageText, bool selectedFirst,
      bool selectedSecond, VoidCallback onPressed) {

    Color changeColor( bool selectedFirst, bool selectedSecond){
      if(selectedFirst == true)
        return Color(0xff7898FF);
      else if(selectedSecond == true)
        return Color(0xffFF9878);
      else return Colors.white;
    }

    return Container(
      height: 117,
      width: 165,
      child: MaterialButton(
        elevation: 3.0,
        highlightElevation: 1.0,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: changeColor(selectedFirst, selectedSecond),
        textColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    width: 45,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9),
                    ),
                  ),
                  Text(
                    languageText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: selectedFirst || selectedSecond
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: selectedFirst || selectedSecond
                          ? Colors.white
                          : Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
