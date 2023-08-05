import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../apis/apis.dart';
import '../../../models/screenArgument.dart';

class SettingNotificationPage extends StatefulWidget {
  const SettingNotificationPage({super.key});

  @override
  State<SettingNotificationPage> createState() =>
      _SettingNotificationPageState();
}

class _SettingNotificationPageState extends State<SettingNotificationPage> {
  late bool allNotification;
  //List<bool> itemNotifications = [false, false];
  bool switchValue4 = false;
  late bool matchingNotification;
  late bool chatNotification;


  static final storage = FlutterSecureStorage();

 @override
  void initState() {
    //getNotification();
  }

  Future<void> getNotification() async {
    //토큰 읽어오기
    var notification = await storage.read(key: 'notification');

    allNotification = json.decode(notification!)['allNotification'] == true;
    matchingNotification = json.decode(notification!)['matchingNotification'] == true;
    chatNotification = json.decode(notification!)['chatNotification'] == true;

    print(allNotification);
    print(matchingNotification);
    print(chatNotification);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          appBar: AppBar(),
          title: '${'setting-noti'.tr()}',
          backgroundColor: Colors.transparent,
          infookay: false,
          infocontent: '',
        ),
        body: FutureBuilder(
          future: getNotification(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: Container(
                    child: Image(image: AssetImage("assets/illustration/loading_01.gif"))),
              );
            }
            else {
              //chatNotifacion = snapshot.data!;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.05),
                      child: Text(
                        '${'setting-noti1'.tr()}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                            color: Color(0xff888888)),
                      ),
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
                                size: isSmallScreen ? 22 : 24,
                                color: Colors.black,
                              ),
                              Text(
                                '${'setting-notiall'.tr()}',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 18 : 20,
                                ),
                              ),
                            ],
                          ),
                          CupertinoSwitch(
                            value: allNotification,
                            activeColor: Color(0xff7898FF),
                            trackColor: Color(0xffC1C1C1),
                            onChanged: (value) async {
                              bool success;
                              print('값: $value');
                              try{
                                success = await APIs.setChatNotification(value, true);
                              }catch (e){
                                print(e);
                                await APIs.getAccessToken();
                                success = await APIs.setChatNotification(value, true);
                              }
                              if(success){
                                setState(() {

                                  print('설정 중 $value');
                                  this.allNotification = value;
                                  this.matchingNotification = value;
                                  this.chatNotification = value;
                                });
                              }
                              else{

                              }
                            },
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
                          Text(
                            '${'setting-notimatch'.tr()}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                            ),
                          ),
                          CupertinoSwitch(
                            value: matchingNotification,
                            activeColor: Color(0xff7898FF),
                            trackColor: Color(0xffC1C1C1),
                            onChanged: (value) async {
                              //알림값 읽어오기
                              var notification = await storage.read(key: 'notification');

                              var allNotification = json.decode(notification!)['allNotification'];
                              var matchingNotification = json.decode(notification!)['matchingNotification'];
                              var chatNotification = json.decode(notification!)['chatNotification'];


                              await storage.delete(key: 'notification');
                              if(chatNotification != value){
                                allNotification = false;
                              }else if(chatNotification == value){
                                allNotification = true;
                              }
                              await storage.write(
                                key: 'notification',
                                value: jsonEncode({
                                  'allNotification' : allNotification,
                                  'matchingNotification' : value,
                                  'chatNotification' : chatNotification,
                                }),
                              );
                              setState(() {

                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${'setting-notichat'.tr()}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                            ),
                          ),
                          CupertinoSwitch(
                            value: chatNotification,
                            activeColor: Color(0xff7898FF),
                            trackColor: Color(0xffC1C1C1),
                            onChanged: (value) async {
                              bool success;
                              try{
                                success = await APIs.setChatNotification(value, false);
                              }catch (e){
                                await APIs.getAccessToken();
                                success = await APIs.setChatNotification(value, false);
                              }
                              setState(() {
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.085),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${'setting-notiinapp'.tr()}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 20,
                            ),
                          ),
                          CupertinoSwitch(
                            value: switchValue4,
                            activeColor: Color(0xff7898FF),
                            trackColor: Color(0xffC1C1C1),
                            onChanged: (value) => setState(() {
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
              );
            }
          },
        ));
  }
}
