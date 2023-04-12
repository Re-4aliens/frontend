import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/button.dart';

class MatchingApplyDonePage extends StatefulWidget {
  const MatchingApplyDonePage({super.key});

  @override
  State<MatchingApplyDonePage> createState() => _MatchingApplyDonePageState();
}

class _MatchingApplyDonePageState extends State<MatchingApplyDonePage> {
  @override
  Widget build(BuildContext context) {
    var memberDetails = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        backgroundColor: Colors.white,
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
            Expanded(flex:1, child: Container()),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(78),
                  ),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.186,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                ),Text(
                  '매칭 신청 완료!',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.039,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.012,
                ),
                Text(
                  '아래 버튼을 클릭하면\n매칭 진행 상황을 알 수 있어요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff616161),
                    fontSize: MediaQuery.of(context).size.height * 0.026,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0833,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Button(
                      child: Text('매칭 진행 상황 보기'),
                      onPressed: (){
                        //스택 비우고
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false
                        );
                        //state페이지를 push
                        Navigator.pushNamed(context, '/state', arguments: memberDetails);

                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Button(
                      child: Text('홈으로 돌아가기'),
                      onPressed: (){
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }),
                ),
              ],
            ),
            Expanded(flex:2, child: Container()),
          ],
        )
    );
  }
}
