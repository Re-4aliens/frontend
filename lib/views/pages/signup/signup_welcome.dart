import 'package:aliens/views/components/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    final double fontSize = isSmallScreen ? 14.0 : 16.0;

    return Scaffold(
        appBar: CustomAppBar(
          backgroundColor: Colors.transparent,
          appBar: AppBar(),
          title: '',
           infookay: false, infocontent: '',
        ),
        body: Padding(
          padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:MediaQuery.of(context).size.height * 0.18),
                Container(
                  child: SvgPicture.asset(
                    'assets/character/welcome.svg',
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Text(
                  '${'signup-done1'.tr()}\n${'signup-done2'.tr()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isSmallScreen?22:24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  '${'signup-done3'.tr()}\n${'signup-done4'.tr()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isSmallScreen?14:16, color: Color(0xff414141)),
                ),
                Expanded(child: SizedBox()),
                Button(
                  //수정
                  isEnabled: true,
                  child: Text('${'signup-done5'.tr()}'),
                  onPressed: () {
                    //스택 비우고
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
                    );
                    //login페이지를 push
                    Navigator.pushNamed(context, '/login');
                    /*
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/apply', (Route<dynamic> route) => false
                    );

                     */
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                /*
                Container(
                  width: double.maxFinite,
                  height: isSmallScreen?44:48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false
                      );
                    },
                    child: Text(
                      '홈으로 가기',
                      style: TextStyle(color: Color(0xffA7A7A7), fontSize: fontSize),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffEBEBEB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                  ),
                )

                 */
              ],
            ),
          ),
        ));
  }
}
