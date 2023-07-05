import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingNotificationPage extends StatefulWidget {
  const SettingNotificationPage({super.key});

  @override
  State<SettingNotificationPage> createState() => _SettingNotificationPageState();
}

class _SettingNotificationPageState extends State<SettingNotificationPage> {
  bool switchValue1 = false;
  List<bool> itemNotifications = [false, false];
  bool switchValue4 = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(appBar: AppBar(), title: '${'setting-noti'.tr()}', backgroundColor: Colors.transparent, infookay: false, infocontent: '',
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.05),
              child: Text('${'setting-noti1'.tr()}',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: isSmallScreen?12:14,
                color: Color(0xff888888)
              ),),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: isSmallScreen?22:24,
                        color: Colors.black,
                      ),
                      Text('${'setting-notiall'.tr()}',
                        style: TextStyle(
                          fontSize: isSmallScreen?18:20,
                        ),),
                    ],
                  ),
                  CupertinoSwitch(
                    value: switchValue1,
                    activeColor: Color(0xff7898FF),
                    trackColor: Color(0xffC1C1C1),
                    onChanged:  (value) => setState(() {
                      this.switchValue1 = value;
                      itemNotifications = List<bool>.filled(itemNotifications.length, value);
                    }),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Color(0xffEFEFEF),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${'setting-notimatch'.tr()}',
                    style: TextStyle(
                      fontSize: isSmallScreen?16:18,
                    ),),
                  CupertinoSwitch(
                    value: itemNotifications[0],
                    activeColor: Color(0xff7898FF),
                    trackColor: Color(0xffC1C1C1),
                    onChanged:  (value) => setState(() {
                      this.itemNotifications[0] = value;
                    }),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${'setting-notichat'.tr()}',
                    style: TextStyle(
                      fontSize: isSmallScreen?16:18,
                    ),),
                  CupertinoSwitch(
                    value: itemNotifications[1],
                    activeColor: Color(0xff7898FF),
                    trackColor: Color(0xffC1C1C1),
                    onChanged:  (value) => setState(() {
                      this.itemNotifications[1] = value;
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height* 0.085),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${'setting-notiinapp'.tr()}',
                    style: TextStyle(
                      fontSize: isSmallScreen?18:20,
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
            ),
            Divider(
              thickness: 1,
              color: Color(0xffEFEFEF),
            ),
          ],
        ),
      )
    );
  }
}
