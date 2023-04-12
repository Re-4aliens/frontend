import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class LoginChangeMail extends StatefulWidget {
  const LoginChangeMail({super.key});

  @override
  State<LoginChangeMail> createState() => _LoginChangeMailState();
}

class _LoginChangeMailState extends State<LoginChangeMail> {
  Widget build(BuildContext context) {
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
                  child: SvgPicture.asset(
                    'assets/icon/icon_check.svg',
                    width: MediaQuery.of(context).size.width * 0.22,
                    height: MediaQuery.of(context).size.height * 0.10,
                    color: Color(0xffFFB5B5),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Text(
                  '비밀번호를 변경해주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.039, fontWeight: FontWeight.bold),
                ),
                Text(
                  '현재 임시비밀번호~~~~\n~~~~해주세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.026 ),
                ),
                Expanded(child: SizedBox()),
                Button(
                  child: Text('비밀번호 변경하기'),
                  onPressed: () {
                    //스택 비우고
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
                    );
                    //login페이지를 push
                    Navigator.pushNamed(context, '/login');
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.012),
                Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.057,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '다음에 변경하기',
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
