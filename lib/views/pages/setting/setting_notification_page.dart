import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingNotificationPage extends StatefulWidget {
  const SettingNotificationPage({super.key});

  @override
  State<SettingNotificationPage> createState() => _SettingNotificationPageState();
}

class _SettingNotificationPageState extends State<SettingNotificationPage> {
  bool switchValue1 = false;
  bool switchValue2 = false;
  bool switchValue3 = false;
  bool switchValue4 = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/icon/icon_back.svg',
            width: MediaQuery.of(context).size.width * 0.062,
            height: MediaQuery.of(context).size.height * 0.029,),
          color: Color(0xff7898FF),
        ),
        title: Text(
          '알림',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('알림 수신',
                  style: TextStyle(
                    fontSize: isSmallScreen?14:16,
                  ),),
                CupertinoSwitch(
                  value: switchValue1,
                  activeColor: Color(0xff7898FF),
                  trackColor: Color(0xffC1C1C1),
                  onChanged:  (value) => setState(() {
                    this.switchValue1 = value;
                  }),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('매칭 알림',
                  style: TextStyle(
                    fontSize: isSmallScreen?14:16,
                  ),),
                CupertinoSwitch(
                  value: switchValue2,
                  activeColor: Color(0xff7898FF),
                  trackColor: Color(0xffC1C1C1),
                  onChanged:  (value) => setState(() {
                    this.switchValue2 = value;
                  }),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('채팅 알림',
                  style: TextStyle(
                    fontSize: isSmallScreen?14:16,
                  ),),
                CupertinoSwitch(
                  value: switchValue3,
                  activeColor: Color(0xff7898FF),
                  trackColor: Color(0xffC1C1C1),
                  onChanged:  (value) => setState(() {
                    this.switchValue3 = value;
                  }),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 15,
            color: Color(0xffEFEFEF),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('앱 내부 알림',
                  style: TextStyle(
                    fontSize: isSmallScreen?14:16,
                  ),),
                CupertinoSwitch(
                  value: switchValue4,
                  activeColor: Color(0xff7898FF),
                  trackColor: Color(0xffC1C1C1),
                  onChanged:  (value) => setState(() {
                    this.switchValue4 = value;
                  }),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}
