import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingNotificationPage extends StatefulWidget {
  const SettingNotificationPage({super.key});

  @override
  State<SettingNotificationPage> createState() => _SettingNotificationPageState();
}

class _SettingNotificationPageState extends State<SettingNotificationPage> {
  bool value = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
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
                    fontSize: 16,
                  ),),
                CupertinoSwitch(
                  value: value,
                  activeColor: Colors.grey,
                  onChanged:  (value) => setState(() {
                    this.value = value;
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
                    fontSize: 16,
                  ),),
                CupertinoSwitch(
                  value: value,
                  activeColor: Colors.grey,
                  onChanged:  (value) => setState(() {
                    this.value = value;
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
                    fontSize: 16,
                  ),),
                CupertinoSwitch(
                  value: value,
                  activeColor: Colors.grey,
                  onChanged:  (value) => setState(() {
                    this.value = value;
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
                    fontSize: 16,
                  ),),
                CupertinoSwitch(
                  value: value,
                  activeColor: Colors.grey,
                  onChanged:  (value) => setState(() {
                    this.value = value;
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
