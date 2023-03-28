import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class LoginCheckMail extends StatefulWidget {
  const LoginCheckMail({super.key});

  @override
  State<LoginCheckMail> createState() => _LoginCheckMailState();
}

class _LoginCheckMailState extends State<LoginCheckMail> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          appBar: AppBar(),
          title: '',
          onPressed: () {},
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(right: 20, left: 20, bottom: 50, top: 120),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Color(0xffFFB5B5),
                ),
                SizedBox(height: 50),
                Text(
                  '메일을 확인해주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '작성하신 메일로 임시비밀번호를\n발급해드렸어요!\n\n다시 로그인 해주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
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
                SizedBox(height: 10),
                Container(
                  width: double.maxFinite,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '이메일 재입력하기',
                      style: TextStyle(color: Color(0xffA7A7A7), fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffEBEBEB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
