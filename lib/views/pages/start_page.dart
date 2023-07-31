import 'dart:convert';
import 'package:aliens/models/applicant_model.dart';
import 'package:aliens/models/memberDetails_model.dart';
import 'package:aliens/models/partner_model.dart';
import 'package:aliens/mockdatas/mockdata_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../apis/apis.dart';
import '../../models/chatRoom_model.dart';
import '../components/button.dart';
import '../components/button_big.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:aliens/providers/member_provider.dart';
import 'package:provider/provider.dart';

import 'chatting/chatting_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  static final storage = FlutterSecureStorage();

  //storage로부터 읽을 모델
  dynamic userInfo = null;


  @override
  void initState(){
    super.initState();

    //비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });


  }

  //비동기로 storage 정보 확인
  _asyncMethod() async {
    //auth값 읽어서 userInfo에 저장
    userInfo = await storage.read(key: 'auth');
    //Navigator.pushNamedAndRemoveUntil(context, '/loading', (route)=>false);
    //user 정보가 있다면 로그인된 것이므로 메인 페이지로 넘어가게 한다.
    if (userInfo != null) {
      //여기서 유저 정보 요청하기

      //var memberDetails = Provider.of<MemberProvider>(context, listen: false);
      Navigator.pushNamedAndRemoveUntil(context, '/loading', (route) => false);
    } else {
      print('로그인 필요'); //정보가 없으면 로그인 필요
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
              flex: 5,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: SvgPicture.asset(
                          'assets/character/logoimage.svg',
                        )),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: SvgPicture.asset(
                        'assets/character/logotext.svg',
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${'title1'.tr()}${'title2'.tr()}',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(right: 20, left: 20),
                      child: Column(
                        children: [
                          BigButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/name');
                              },
                              child: Text(
                                'start'.tr(),
                                style: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 16),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'login2'.tr(),
                                style: TextStyle(
                                    fontSize: isSmallScreen ? 12 : 14),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  child: Text('login1'.tr(),
                                      style: TextStyle(
                                        color: Color(0xff000000),
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.bold,
                                      )))
                            ],
                          )
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: ()=>EasyLocalization.of(context)!.setLocale(Locale('ko', 'KR')), child: Text(
                          '한국어'
                      ),),
                      TextButton(onPressed: ()=>EasyLocalization.of(context)!.setLocale(Locale('en', 'US')), child: Text(
                          'English'
                      ),),
                      TextButton(onPressed: () async {
                       await APIs.signUp(signUpModel);
                      }
                        ,child: Text('회원가입'),),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
