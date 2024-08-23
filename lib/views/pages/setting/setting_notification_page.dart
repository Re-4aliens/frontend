import 'dart:convert';

import 'package:aliens/services/notification_service.dart';
import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../models/screen_argument.dart';
import '../../../util/permissions.dart';

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
  late bool communityNotification;
  late bool inAppNotification;

  late bool notificationStatus;

  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getNotificationStatus();
  }

  Future<void> getNotificationStatus() async {
    final status = await NotificationService.getNotificationStatus();

    setState(() {
      notificationStatus = status;
    });
  }

  Future<void> getNotification() async {
    //토큰 읽어오기
    var notification = await storage.read(key: 'notifications');
    var inApp = await storage.read(key: 'inAppNotification');

    allNotification = json.decode(notification!)['allNotification'] == true;
    matchingNotification =
        json.decode(notification)['matchingNotification'] == true;
    chatNotification = json.decode(notification)['chatNotification'] == true;
    communityNotification =
        json.decode(notification)['communityNotification'] == true;
    inAppNotification = json.decode(inApp!)['inAppNotification'] == true;
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
          title: 'setting-noti'.tr(),
          backgroundColor: Colors.transparent,
          infookay: false,
          infocontent: '',
        ),
        body: FutureBuilder(
          future: getNotification(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                    child: const Image(
                        image:
                            AssetImage("assets/illustration/loading_01.gif"))),
              );
            } else {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.05),
                      child: Text(
                        'setting-noti1'.tr(),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                            color: const Color(0xff888888)),
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
                                'setting-notiall'.tr(),
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 18 : 20,
                                ),
                              ),
                            ],
                          ),

                          // 전체 알림 설정
                          CupertinoSwitch(
                            value: allNotification,
                            activeColor: const Color(0xff7898FF),
                            trackColor: const Color(0xffC1C1C1),
                            onChanged: (value) async {
                              if (await Permissions
                                  .getNotificationPermission()) {
                                await storage.delete(key: 'notifications');

                                await storage.write(
                                  key: 'notifications',
                                  value: jsonEncode({
                                    'allNotification': value,
                                    'matchingNotification': value,
                                    'chatNotification': value,
                                    'communityNotification': value
                                  }),
                                );
                                print("value $value");
                                NotificationService.setNotification(value);
                                setState(() {
                                  notificationStatus = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Color(0xffEFEFEF),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'setting-notimatch'.tr(),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                            ),
                          ),
                          CupertinoSwitch(
                            value: matchingNotification,
                            activeColor: const Color(0xff7898FF),
                            trackColor: const Color(0xffC1C1C1),
                            onChanged: (value) async {
                              if (await Permissions
                                  .getNotificationPermission()) {
                                await storage.delete(key: 'notifications');

                                await storage.write(
                                  key: 'notifications',
                                  value: jsonEncode({
                                    'allNotification': value,
                                    'matchingNotification': value,
                                    'chatNotification': value,
                                    'communityNotification': value
                                  }),
                                );
                                NotificationService.setNotification(value);
                                setState(() {
                                  notificationStatus = value;
                                });
                              }
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
                            'setting-notichat'.tr(),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                            ),
                          ),
                          CupertinoSwitch(
                            value: chatNotification,
                            activeColor: const Color(0xff7898FF),
                            trackColor: const Color(0xffC1C1C1),
                            onChanged: (value) async {
                              if (await Permissions
                                  .getNotificationPermission()) {
                                await storage.delete(key: 'notifications');

                                await storage.write(
                                  key: 'notifications',
                                  value: jsonEncode({
                                    'allNotification': value,
                                    'matchingNotification': value,
                                    'chatNotification': value,
                                    'communityNotification': value
                                  }),
                                );
                                NotificationService.setNotification(value);
                                setState(() {
                                  notificationStatus = value;
                                });
                              }
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
                            "setting-noticommunity".tr(),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                            ),
                          ),
                          CupertinoSwitch(
                            value: communityNotification,
                            activeColor: const Color(0xff7898FF),
                            trackColor: const Color(0xffC1C1C1),
                            onChanged: (value) async {
                              if (await Permissions
                                  .getNotificationPermission()) {
                                await storage.delete(key: 'notifications');

                                await storage.write(
                                  key: 'notifications',
                                  value: jsonEncode({
                                    'allNotification': value,
                                    'matchingNotification': value,
                                    'chatNotification': value,
                                    'communityNotification': value
                                  }),
                                );
                                NotificationService.setNotification(value);
                                setState(() {
                                  notificationStatus = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.085),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'setting-notiinapp'.tr(),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 20,
                            ),
                          ),
                          CupertinoSwitch(
                            value: inAppNotification,
                            activeColor: const Color(0xff7898FF),
                            trackColor: const Color(0xffC1C1C1),
                            onChanged: (value) async {
                              if (await Permissions
                                  .getNotificationPermission()) {
                                await storage.delete(key: 'notifications');

                                await storage.write(
                                  key: 'notifications',
                                  value: jsonEncode({
                                    'allNotification': value,
                                    'matchingNotification': value,
                                    'chatNotification': value,
                                    'communityNotification': value
                                  }),
                                );
                                NotificationService.setNotification(value);
                                setState(() {
                                  notificationStatus = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(
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
