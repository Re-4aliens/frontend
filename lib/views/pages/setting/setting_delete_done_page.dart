import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import '../../../apis/apis.dart';
import '../../components/appbar.dart';
import '../../components/button.dart';

class SettingDeleteDonePage extends StatefulWidget {
  const SettingDeleteDonePage({super.key});

  @override
  State<SettingDeleteDonePage> createState() => _SettingDeleteDonePageState();
}

class _SettingDeleteDonePageState extends State<SettingDeleteDonePage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    //final AuthProvider authProvider = new AuthProvider();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(left: 20,right: 20, bottom: 60, top:100),
          child: Column(
            children: [
              Expanded(
                  flex: 6,
                  child: Container(
                    //decoration: BoxDecoration(color: Colors.green),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${'setting-withdrawaldone'.tr()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: isSmallScreen?22:24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Container(
                          child: SvgPicture.asset(
                            'assets/icon/icon_check.svg',
                            color: Color(0xff7898ff),
                          ),
                          height: MediaQuery.of(context).size.height * 0.126,
                          width: MediaQuery.of(context).size.width*0.272,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Text('${'setting-thank'.tr()}',
                          style: TextStyle(
                            color: Color(0xff414141),
                            fontSize: isSmallScreen?14:16
                          ),
                          textAlign: TextAlign.center,
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
                          await APIs.logOut(context);
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
                          );
                        }),
                  )),

            ],
          ),
        ));
  }
}
