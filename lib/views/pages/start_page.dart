import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../components/button.dart';
import '../components/button_big.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'package:aliens/providers/member_provider.dart';
import 'package:provider/provider.dart';


class StartPage extends StatefulWidget{
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();

}

class _StartPageState extends State<StartPage>{
  static final storage = FlutterSecureStorage();

  //storage로부터 읽을 모델
  dynamic userInfo = null;
/*
  @override
  void initState(){
    super.initState();

    //비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });


  }
*/
  //비동기로 storage 정보 확인
  _asyncMethod() async{
    //auth값 읽어서 userInfo에 저장
    userInfo = await storage.read(key:'auth');
    //Navigator.pushNamedAndRemoveUntil(context, '/loading', (route)=>false);
    //user 정보가 있다면 로그인된 것이므로 메인 페이지로 넘어가게 한다.
    if (userInfo != null){
      //여기서 유저 정보 요청하기

      //var memberDetails = Provider.of<MemberProvider>(context, listen: false);
      Navigator.pushNamedAndRemoveUntil(context, '/loading', (route)=>false);
    } else {
      print('로그인 필요');  //정보가 없으면 로그인 필요
    }
  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: SizedBox(),
            ),
            Expanded(
              flex:5,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(width: 100, height: 50,
                      decoration: BoxDecoration(color: Colors.grey.shade400),
                        ),
                    Text('FRIEND SHIP',
                      style : TextStyle(fontSize: isSmallScreen ? 22 : 24, fontWeight: FontWeight.bold),
                    ),
                    Text('내 손안의 외국인 프렌즈',
                        style: TextStyle(fontSize: isSmallScreen ? 12 : 14),),
                      ],),),),
              Expanded(
                flex:4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20,left: 20),
                      child: Column(
                        children: [
                          BigButton(onPressed: () {
                            Navigator.pushNamed(context, '/name');},
                              child: Text('시작하기', style: TextStyle(fontSize: isSmallScreen ? 14 : 16),)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('이미 계정이 있나요?', style: TextStyle(fontSize: isSmallScreen ? 12 : 14),),
                              TextButton(onPressed: (){
                                Navigator.pushNamed(context, '/login');
                              },
                                  child: Text('로그인',
                                      style: TextStyle(color: Color(0xff000000),
                                      fontSize: isSmallScreen ? 12 : 14,
                                      fontWeight: FontWeight.bold,
                                      )))
                            ],
                          )

                        ],
                      )

                    )
                  ],
                ),
              ),
          ],

        ),
        
      ) ,
    );
  }

}