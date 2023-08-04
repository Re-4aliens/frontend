import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../apis/apis.dart';
import '../../components/button.dart';
import 'package:aliens/providers/auth_provider.dart';

class SettingEditPWDonePage extends StatefulWidget {
  const SettingEditPWDonePage({super.key});

  @override
  State<SettingEditPWDonePage> createState() => _SettingEditPWDonePageState();
}

class _SettingEditPWDonePageState extends State<SettingEditPWDonePage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          backgroundColor: Colors.transparent,
          appBar: AppBar(), title: '',infookay: false, infocontent: '',
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20, bottom: 50, top:120),
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    //decoration: BoxDecoration(color: Colors.green),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${'setting-pasdone'.tr()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: isSmallScreen?22:24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          child: SvgPicture.asset(
                            'assets/icon/icon_check.svg',
                            color: Color(0xff7898ff),
                          ),
                          height: isSmallScreen?100:110,
                          width: isSmallScreen?100:110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        )
                      ],
                    ),
                  )),

              Expanded(
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Button(
                      //수정
                        isEnabled: true,
                        child: Text('${'setting-gohome'.tr()}'),
                        onPressed: () async {

                          final fcmToken = await FirebaseMessaging.instance.getToken();
                          //로그아웃
                          APIs.logOut(context, fcmToken!);
                        }),
                  )),

          ],
          ),
        ));
  }
}
