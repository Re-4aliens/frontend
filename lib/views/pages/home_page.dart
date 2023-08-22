import 'dart:convert';
import 'dart:io';

import 'package:aliens/models/memberDetails_model.dart';
import 'package:aliens/views/components/board_tab_widget.dart';
import 'package:aliens/views/components/home_widget.dart';
import 'package:aliens/views/components/setting_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../apis/apis.dart';
import '../../main.dart';
import '../../mockdatas/mockdata_model.dart';
import '../../models/screenArgument.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../permissions.dart';
import '../../providers/auth_provider.dart';
import '../components/board_drawer_widget.dart';
import '../components/matching_widget.dart' as matching;
import '../components/setting_list_widget.dart';
import '../components/chatting_widget.dart';
import '../components/matching_chatting_widget.dart';
import '../components/setting_profile_widget.dart';

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

  @override
  void initState() {
    // TODO: implement initState

    //알림 설정
    _setNotification();
  }

  _setNotification() async {
    notification = await storage.read(key: 'notification');

    //알림 허용 팝업을 띄움

    //허용하면
    if(await Permissions.getNotificationPermission()){
      print('알림 허용 상태');
      //저장된 설정 정보가 없다면
      if (notification != null){
      }else{
        //true로 설정
        await storage.write(
          key: 'notification',
          value: jsonEncode({
            'allNotification': true,
            'matchingNotification': true,
            'chatNotification': true,
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
          key: 'notification',
          value: jsonEncode({
            'allNotification': false,
            'matchingNotification': false,
            'chatNotification': false,
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
      args.status == 'MATCHED'
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
            fontSize: selectedIndex == 2 ? 16 : 18,
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
                        width: 24,
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isDrawerStart = !isDrawerStart;
                        });
                      },
                      icon: Icon(Icons.format_list_bulleted_outlined),
                      color: Colors.white,
                    ),
                  ],
                )
            else
                Container(),
          ],
        ),
        actions: selectedIndex == 2 ? [
          IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none)),
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
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
                width: 25,
                height: 25,
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
                width: 25,
                height: 25,
                color:
                    selectedIndex == 1 ? Color(0xFF7898FF) : Color(0xFFD9D9D9),
              ),
            ),
            label:'${'homepage-chatting1'.tr()}' ,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(Icons.article),
            ),
            label: "board".tr() ,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                'assets/icon/icon_setting.svg',
                width: 25,
                height: 25,
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

