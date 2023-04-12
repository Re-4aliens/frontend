import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class SignUpWelcome extends StatefulWidget {
  const SignUpWelcome({super.key});

  @override
  State<SignUpWelcome> createState() => _SignUpWelcomeState();
}

class _SignUpWelcomeState extends State<SignUpWelcome> {
  Widget build(BuildContext context) {
    //Members members = new Members('','','','','','','','');

    return Scaffold(
        appBar: CustomAppBar(
          appBar: AppBar(),
          title: '',
          onPressed: () {},
        ),
        body: Padding(
          padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:MediaQuery.of(context).size.height * 0.1),
                Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.186,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.036),
                Text(
                  '환영합니다!\n가입이 완료되었습니다',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.04, fontWeight: FontWeight.bold),
                ),
                Text(
                  '이제 매칭을 할 수 있어요\n아래 버튼을 통해 매칭 신청을 해보세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.026),
                ),
                Expanded(child: SizedBox()),
                Button(
                  child: Text('매칭 신청하러 가기'),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/apply', (Route<dynamic> route) => false
                    );
                  },
                ),
                SizedBox(height: 10),
                Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.057,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false
                      );
                    },
                    child: Text(
                      '홈으로 가기',
                      style: TextStyle(color: Color(0xffA7A7A7)),
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
