import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../components/button.dart';

class MatchingStatePage extends StatefulWidget {
  const MatchingStatePage({super.key});

  @override
  State<MatchingStatePage> createState() => _MatchingStatePageState();
}

class _MatchingStatePageState extends State<MatchingStatePage> {
  @override
  Widget build(BuildContext context) {
    var memberDetails = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
       // backgroundColor: Color(0xFFF4F4F4),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/icon/icon_back.svg',
              width: MediaQuery.of(context).size.width * 0.062,
              height: MediaQuery.of(context).size.height * 0.029,            ),
            color: Colors.black,
          ),
        ),
        body: Column(
          children: [
            Column(
              children: [
                Expanded(flex:1, child: Container()),

                Text(
                  '매칭 대기중...',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.039,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child:  LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width * 0.513,
                  animation: true,
                  lineHeight: MediaQuery.of(context).size.height * 0.009,
                  animationDuration: 2000,
                  percent: 0.9,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Color(0xff7898FF),
                ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.059,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(90),
                  ),
                  width: MediaQuery.of(context).size.width * 0.361,
                  height: MediaQuery.of(context).size.height * 0.21,
                ),
                SizedBox(
                  height: 70,
                ),
                Text(
                  '조금만 기다려주세요.\n내 성향과 스타일에 꼭 맞는\n친구를 찾고 있어요!',
                  style: TextStyle(
                    color: Color(0xff616161),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20,left: 20,bottom: 40),
                  child: Button(
                      child: Text('나의 신청 확인하기'),
                      onPressed: (){
                        Navigator.pushNamed(context, '/info/my', arguments: memberDetails);
                      }),
                ),
                /*SizedBox(
                  height: 40,
                ),
                Text('위 버튼을 누르면 나의 접수 정보를 확인하고\n언어를 수정할 수 있어요.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB1B1B1),
                  ),
                  textAlign: TextAlign.center,
                ),*/
              ],
            ),
            Expanded(flex: 3,child: Container()),
          ],
        ));
  }
}
