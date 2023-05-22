import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class LoginCheckMail extends StatefulWidget {
  const LoginCheckMail({super.key});

  @override
  State<LoginCheckMail> createState() => _LoginCheckMailState();
}

class _LoginCheckMailState extends State<LoginCheckMail> {
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth <= 600;
    return Scaffold(
        appBar: CustomAppBar(
          appBar: AppBar(),
          title: '',
          backgroundColor: Colors.transparent, infookay: false, infocontent: '',
        ),
        body: Padding(
          padding: EdgeInsets.only(right: 24,left: 24,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:MediaQuery.of(context).size.height * 0.23),
                Container(
                  child: SvgPicture.asset(
                    'assets/icon/icon_check.svg',
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.07,
                    color: Color(0xff7898FF),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                Text(
                  '메일을 확인해주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isSmallScreen?22:24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '작성하신 메일로 임시비밀번호를 발급해드렸어요!\n다시 로그인 해주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isSmallScreen?14:16),
                ),
                Expanded(child: SizedBox()),
                Button(
                  child: Text('로그인하기'),
                  onPressed: () {
                    //스택 비우고
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
                    );
                    //login페이지를 push
                    Navigator.pushNamed(context, '/login');
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.028),
                Container(
                  width: double.maxFinite,
                  height: isSmallScreen?44:48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '이메일 재입력하기',
                      style: TextStyle(color: Color(0xffA7A7A7), fontSize: isSmallScreen?14:16),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffEBEBEB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
