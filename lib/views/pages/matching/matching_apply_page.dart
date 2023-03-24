import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MatchingApplyPage extends StatefulWidget {
  const MatchingApplyPage({super.key});

  @override
  State<MatchingApplyPage> createState() => _MatchingApplyPageState();
}

class _MatchingApplyPageState extends State<MatchingApplyPage> {
  @override
  Widget build(BuildContext context) {
    var memberDetails = ModalRoute.of(context)!.settings.arguments;


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
        body: _buildBody(memberDetails)
    );
  }

  Widget _buildBody(memberDetails){
    return Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
              ),),
            Column(
              children: [
                Text(
                  '매칭신청',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '맞춤 매칭을 위해\n2단계 질문을 완성해주세요',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(70),
                  ),
                  width: 140,
                  height: 140,
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '1단계',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('사용 언어 선택',style: TextStyle(
                      fontSize: 16,
                    ),),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text('어플 사용시  표시되는 언어입니다.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB1B1B1),
                  ),
                ),
                Text('사용하기 가장 편한 언어를 선택해주세요',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB1B1B1),
                  ),),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '2단계',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('매칭 언어 선택',style: TextStyle(
                      fontSize: 16,
                    ),),
                  ],
                ),
                Text('어떤 언어로 대화하고 싶으신가요?',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB1B1B1),
                  ),),
                Text('2순위까지 선호하는 언어를 선택할 수 있어요.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB1B1B1),
                  ),),
                SizedBox(
                  height: 60,
                ),
                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context,'/choose', arguments: memberDetails);
                  },
                  child: Container(
                    child: Text('버튼'),
                  ),
                )
              ],
            ),
            Expanded(
              flex: 3,
              child: Container(
              ),),
          ],
        )
    );
  }
}
