import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aliens/models/memberDetails_model.dart';
import 'package:aliens/views/components/board_tab_widget.dart';
import 'package:aliens/views/components/home_widget.dart';
import 'package:aliens/views/components/setting_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../apis/apis.dart';
import '../../apis/firebase_apis.dart';
import '../../main.dart';
import '../../mockdatas/mockdata_model.dart';
import '../../models/screenArgument.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../permissions.dart';
import '../../providers/auth_provider.dart';
import '../components/board_drawer_widget.dart';
import '../components/setting_list_widget.dart';
import '../components/chatting_widget.dart';
import '../components/matching_chatting_widget.dart';
import '../components/setting_profile_widget.dart';
import 'board/notification_page.dart';
import 'board/search_page.dart';

int selectedIndex = 0;
bool isDrawerStart = false;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  MemberDetails memberDetails = MemberDetails();
  static final storage = FlutterSecureStorage();
  dynamic notification = null;
  dynamic inAppNotification = null;
  StreamSubscription<RemoteMessage>? _messageStreamSubscription;

  @override
  void initState() {
    //알림 설정
    _setNotification();

    _messageStreamSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

          print('앱 내부 알림 도착${message.data}');

          var inAppNotification = await storage.read(key: 'inAppNotification');

          if(message.data['type']=='ARTICLE_LIKE'){
            print(json.decode(inAppNotification!)['inAppNotification']);
            if(json.decode(inAppNotification!)['inAppNotification'] == true){
              showOverlayNotification((context) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: SafeArea(
                    child: Container(
                      padding: EdgeInsets.only(top: 15, bottom: 15, left: 15).r,
                      child: ListTile(
                        title: Text('Friendship'),
                        subtitle: Text('${message.data['name']}${'liked noti'.tr()}'),
                        trailing: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              OverlaySupportEntry.of(context)?.dismiss();
                            }),
                      ),
                    ),
                  ),
                );
              }, duration: Duration(milliseconds: 4000));

            }
          }else if(message.data['type']=='ARTICLE_COMMENT_REPLY'){

            if(json.decode(inAppNotification!)['inAppNotification'] == true){
              showOverlayNotification((context) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: SafeArea(
                    child: Container(
                      padding: EdgeInsets.only(top: 15, bottom: 15, left: 15).r,
                      child: ListTile(
                        title: Text('Friendship'),
                        subtitle: Text('${message.data['name']}${'reply'.tr()}'),
                        trailing: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              OverlaySupportEntry.of(context)?.dismiss();
                            }),
                      ),
                    ),
                  ),
                );
              }, duration: Duration(milliseconds: 4000));

            }
          }else if(message.data['type']=='ARTICLE_COMMENT'){
            if(json.decode(inAppNotification!)['inAppNotification'] == true){

              showOverlayNotification((context) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: SafeArea(
                    child: Container(
                      padding: EdgeInsets.only(top: 15, bottom: 15, left: 15).r,
                      child: ListTile(
                        title: Text('Friendship'),
                        subtitle: Text('${message.data['name']}${'comment'.tr()}'),
                        trailing: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              OverlaySupportEntry.of(context)?.dismiss();
                            }),
                      ),
                    ),
                  ),
                );
              }, duration: Duration(milliseconds: 4000));

            }
          }

        }
        );
  }

  _setNotification() async {
    notification = await storage.read(key: 'notifications');
    inAppNotification = await storage.read(key: 'inAppNotification');

    //알림 허용 팝업을 띄움

    //허용하면
    if(await Permissions.getNotificationPermission()){
      print('알림 허용 상태');
      //저장된 설정 정보가 없다면
      if (notification != null){
      }else{
        //true로 설정
        await storage.write(
          key: 'notifications',
          value: jsonEncode({
            'allNotification': true,
            'matchingNotification': true,
            'chatNotification': true,
            'communityNotification' : true,
          }),
        );
      }
      if(inAppNotification != null){
      }else{
        await storage.write(
          key: 'inAppNotification',
          value: jsonEncode({
            'inAppNotification': true,
          }),
        );
      }
    }else{
      print('알림 불허 상태');
      //저장된 설정 정보가 없다면
      if (notification != null){
      }else{
        //false로 설정
        await storage.write(
          key: 'notifications',
          value: jsonEncode({
            'allNotification': false,
            'matchingNotification': false,
            'chatNotification': false,
            'communityNotification' : false,
          }),
        );
      }
      if(inAppNotification != null){
      }else{
        await storage.write(
          key: 'inAppNotification',
          value: jsonEncode({
            'inAppNotification': false,
          }),
        );
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    final double fontSize = isSmallScreen ? 16.0 : 20.0;

    List _pageTitle = [
      '',
      '',
      '${'total-board'.tr()}',
      '${'setting'.tr()}',
    ];

    List _pageWidget = [
      HomeWidget(screenArguments: args,),
      args.status == 'AppliedAndMatched' || args.status == 'NotAppliedAndMatched'
          ? matchingChattingWidget(
              screenArguments: args,
            )
          : chattingWidget(context, args.partners),
      isDrawerStart ? BoardDrawerWidget(screenArguments: args, isTotalBoard: true, onpressd: (){
        setState(() {
          isDrawerStart = false;
        });
      },) : TotalBoardWidget(screenArguments: args),
      SettingWidget(context: context, screenArguments: args)
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _pageTitle.elementAt(selectedIndex),
          style: TextStyle(
            fontSize: 18.spMin,
            color: selectedIndex == 2 ? Colors.white : Colors.black,
            fontWeight: selectedIndex == 2 ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        toolbarHeight: selectedIndex == 1 ? 90 : 56,
        elevation: selectedIndex == 1 ? 7 : 0,
        shadowColor: Colors.black26,
        backgroundColor: selectedIndex == 1 ? Colors.white : (selectedIndex == 2 ? Color(0xff7898ff) : Color(0xffF2F5FF)),
        leadingWidth: 100,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedIndex == 3)
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    icon: SvgPicture.asset(
                      'assets/icon/icon_back.svg',
                      color: Color(0xff4D4D4D),
                      width: 24,
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    color: Colors.black,
                  ),
                ],
              )
            else if (selectedIndex == 1)
              Container(
                alignment: Alignment.center,
                height: 90,
                child: Text(
                  'chat1'.tr(),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              )
            else if(selectedIndex == 2)
                Row(
                  children: [
                    IconButton(
                      onPressed: () {

                        setState(() {
                          if(isDrawerStart){
                            isDrawerStart = false;
                          }else{
                            selectedIndex = 0;
                          }
                        });
                      },
                      icon: SvgPicture.asset(
                        'assets/icon/icon_back.svg',
                        color: Colors.white,
                        width: 17.r,
                        height: 17.r,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isDrawerStart = !isDrawerStart;
                        });
                      },
                      icon: SvgPicture.asset(
                        'assets/icon/ICON_list.svg',
                        width: 20.r,
                        height: 20.r,
                        color: Colors.white,
                      ),
                      color: Colors.white,
                    ),
                  ],
                )
            else
                Container(),
          ],
        ),
        actions: selectedIndex == 2 ? [
          Padding(
            padding: EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationBoardWidget(
                      screenArguments: args,
                    ),
                  ),
                );
              },
              child: SvgPicture.asset(
                'assets/icon/ICON_notification.svg',
                width: 28.r,
                height: 28.r,
                color: Colors.white,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => SearchPage(screenArguments: args, category: "전체게시판", nationCode: '',)),
                );
              },
              child: SvgPicture.asset(
                'assets/icon/icon_search.svg',
                width: 25.r,
                height: 25.r,
                color: Colors.white,
              ),
            ),
          ),
        ] : null,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Color(0xFF7898FF),
        unselectedItemColor: Color(0xFFD9D9D9),
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
            isDrawerStart = false;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                'assets/icon/icon_home.svg',
                width: 25.r,
                height: 25.r,
                color:
                    selectedIndex == 0 ? Color(0xFF7898FF) : Color(0xFFD9D9D9),
              ),
            ),
            label: '${'homepage-home'.tr()}',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                'assets/icon/icon_chatting.svg',
                width: 25.r,
                height: 25.r,
                color:
                    selectedIndex == 1 ? Color(0xFF7898FF) : Color(0xFFD9D9D9),
              ),
            ),
            label:'${'homepage-chatting1'.tr()}' ,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(8),
              child: SvgPicture.asset(
                'assets/icon/ICON_board.svg',
                width: 25.r,
                height: 25.r,
                color: selectedIndex == 2 ? Color(0xFF7898FF) : Color(0xFFD9D9D9),
              ),
            ),
            label: "board".tr(),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                'assets/icon/icon_setting.svg',
                width: 25.r,
                height: 25.r,
                color:
                    selectedIndex == 3 ? Color(0xFF7898FF) : Color(0xFFD9D9D9),
              ),
            ),
            label: '${'homepage-setting'.tr()}',
          )
        ],
      ),
      body: _pageWidget.elementAt(selectedIndex),
    );
  }




}

