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
  dynamic token =null;


  String selectedValue = 'English';


  @override
  void initState(){
    super.initState();

    //비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //토큰 유효성 검사
      _isValid();
    });

  }


  _isValid() async {
    userInfo = await storage.read(key: 'auth');
    //저장된 정보가 있다면
    if (userInfo != null){
      //토큰 저장 시간
      token = await storage.read(key: 'token');
      DateTime timestamp = DateTime.parse(json.decode(token!)['timestamp']);
      Duration diff = DateTime.now().difference(timestamp);

      print('지금 시간: ${DateTime.now()}\n토큰 저장 시간: ${timestamp}\n 차이: ${diff}');
      //리프레시 토큰 기간(60s)이 지났다면
      if(diff > Duration(days: 6)){
        //토큰 및 정보 지움
        //자동로그인 해제
        await storage.delete(key: 'auth');
        await storage.delete(key: 'token');
      } else if (diff <= Duration(days: 6) && diff > Duration(minutes: 29)){
        //액세스 토큰 기간(30s)이 지났다면
        //액세스 토큰 재발급
        print('액세스 토큰 재발급');
        await APIs.getAccessToken(context);
      } else{
        //else
        Navigator.pushNamedAndRemoveUntil(context, '/loading', (route) => false);
      }
    }else{
      //저장된 정보가 없다면
      print('로그인 필요');
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
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Text(
                        '${'title1'.tr()}${'title2'.tr()}',
                        style: TextStyle(fontSize: isSmallScreen ? 16 : 18, color: Color(0xff414141)),
                      ),
                    ),
                    DropdownButton<String>(
                      underline: SizedBox(),
                      value: selectedValue,
                      items: <String>['English', '한국어']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                            color: Color(0xff616161)),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                          switch (selectedValue){
                            case '한국어':
                              EasyLocalization.of(context)!.setLocale(Locale('ko', 'KR'));
                              break;
                            case 'English':
                              EasyLocalization.of(context)!.setLocale(Locale('en', 'US'));
                              break;
                          }
                        });
                      },
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SvgPicture.asset(
                          'assets/icon/icon_dropdown.svg',
                          height: 8,
                        ),
                      )
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
