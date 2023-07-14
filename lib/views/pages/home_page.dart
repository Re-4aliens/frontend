import 'dart:io';

import 'package:aliens/models/memberDetails_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../apis.dart';
import '../../main.dart';
import '../../mockdatas/mockdata_model.dart';
import '../../models/screenArgument.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../providers/auth_provider.dart';
import '../components/matching_widget.dart' as matching;
import '../components/setting_list_widget.dart';
import '../components/chatting_widget.dart';
import '../components/matching_chatting_widget.dart';
import '../components/setting_profile_widget.dart';

int selectedIndex = 0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  MemberDetails memberDetails = MemberDetails();


  @override
  File? _profileImage;
  final picker = ImagePicker();

  //비동기 처리를 통해 이미지 가져오기
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);
    setState(() {
      _profileImage = File(image!.path); // 가져온 이미지를 _image에 저장
    });
  }

  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    final double fontSize = isSmallScreen ? 16.0 : 20.0;

    List _pageTitle = [
      '',
      '',
      '설정',
    ];

    List _pageWidget = [
      Container(
        decoration: BoxDecoration(
          color: Color(0xffF2F5FF),
        ),
        child: Stack(children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '${'homepage-welcome'.tr()}\n',
                        style: TextStyle(
                            fontSize: 20, color: Color(0xff5A5A5A), height: 1),
                      ),
                      EasyLocalization.of(context)!.locale == Locale.fromSubtags(languageCode: "ko", countryCode: "KR") ?
                      TextSpan(children: [
                        TextSpan(
                            text: '${'homepage-welome1.1'.tr()}',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.5)),
                        TextSpan(
                            text: '${'homepage-welcome1.2'.tr()}\n',
                            style: TextStyle(
                                fontSize: 24, color: Color(0xff5A5A5A))),
                      ]) :
                      TextSpan(children: [
                        TextSpan(
                            text: '${'homepage-welome1.1'.tr()}',
                            style: TextStyle(
                                fontSize: 24, color: Color(0xff5A5A5A))),
                        TextSpan(
                            text: '${'homepage-welcome1.2'.tr()}\n',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.5)),
                      ]),
                      TextSpan(
                          text: '${'homepage-happy'.tr()}\n',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff888888),
                              height: 2)),
                      TextSpan(
                          text: '${'homepage-positive1'.tr()}',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff888888),
                              height: 1.5)),
                      TextSpan(
                          text: '${'homepage-positive2'.tr()}'
                          /*'${args.memberDetails?.mbti}'*/,
                          style: TextStyle(
                              fontSize: 12, color: Color(0xff7898ff))),
                      TextSpan(
                          text: '${'homepage-positive3'.tr()}',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xff888888))),
                      TextSpan(
                          text: '${'homepage-positive4'.tr()}',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xff7898ff))),
                      TextSpan(
                          text: '${'homepage-positive5'.tr()}\n',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xff888888))),
                      TextSpan(
                          text: '${'homepage-more'.tr()}\n',
                          style: TextStyle(
                              fontSize: 12, color: Colors.black, height: 2.5))
                    ]),
                  ),
                ),
              ),
              Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 20 : 30,
                      horizontal: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${'homepage-start'.tr()}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff5C5C5C),
                              ),
                            ),
                            Text(
                              '${'homepage-meet'.tr()}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffababab),
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Center(
                          child: Container(
                            //alignment: Alignment.center,
                            height: isSmallScreen ? 210 : 240,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildButton(
                                    true, 0, context, args, isSmallScreen),
                                SizedBox(
                                  width: 20,
                                ),
                                buildButton(
                                    true, 1, context, args, isSmallScreen),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ))
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 13,
            right: 0,
            child: Container(
              child: SvgPicture.asset('assets/character/handsup1.svg',
                height: isSmallScreen ? 190 : 260,
                width: isSmallScreen ? 190 : 260,
                //color: Color(0xffFFB5B5),
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ]),
      ),
      args.status == 'MATCHED'
          ? matchingChattingWidget(
              screenArguments: args,
            )
          : chattingWidget(context, args.partners),
      settingWidget(context, args)
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _pageTitle.elementAt(selectedIndex),
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: selectedIndex == 1 ? 90 : 56,
        elevation: selectedIndex == 1 ? 7 : 0,
        shadowColor: Colors.black26,
        backgroundColor: selectedIndex == 1 ? Colors.white : Color(0xffF2F5FF),
        leadingWidth: 100,
        leading: Column(
          children: [
            if (selectedIndex == 2)
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
                      height: MediaQuery.of(context).size.height * 0.029,
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
            else
              Container(),
          ],
        ),
        actions: [
          if (selectedIndex == 0)
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icon/icon_info.svg',
                width: MediaQuery.of(context).size.width * 0.062,
                height: MediaQuery.of(context).size.height * 0.029,
                color: Color(0xff7898FF),
              ),
            )
          else
            Container(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Color(0xFF7898FF),
        unselectedItemColor: Color(0xFFD9D9D9),
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
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
              child: SvgPicture.asset(
                'assets/icon/icon_setting.svg',
                width: 25,
                height: 25,
                color:
                    selectedIndex == 2 ? Color(0xFF7898FF) : Color(0xFFD9D9D9),
              ),
            ),
            label: '${'homepage-setting'.tr()}',
          )
        ],
      ),
      body: _pageWidget.elementAt(selectedIndex),
    );
  }

  Widget buildButton(
      bool clicked, int index, BuildContext context, args, bool isSmallScreen) {
    bool isClick = false;
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: [
        BoxShadow(
          blurRadius: 4,
          color: Colors.black26,
          spreadRadius: 1,
          offset: const Offset(0, 3),
        ),
      ]),
      child: Material(
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
        child: Ink(
          width: isSmallScreen ? 140 : 160,
          decoration: BoxDecoration(
            color: index == 0 ? Color(0xffAEC1FF) : Color(0xffFFB5B5),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: InkWell(
              onTap: () {
                print(clicked);
                if (args.status == 'NOT_APPLIED' && index == 1 && clicked) {
                  showDialog(
                      context: context,
                      builder: (_) => Stack(
                            children: [
                              Positioned(
                                top: MediaQuery.of(context).size.height / 15 +
                                    AppBar().preferredSize.height,
                                right: 0,
                                child: Container(
                                  child: SvgPicture.asset('assets/character/handsdown1.svg',
                                    height: isSmallScreen ? 160 : 230,
                                    width: isSmallScreen ? 160 : 230,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ), //팔내리는 캐릭터
                              Positioned(
                                top: MediaQuery.of(context).size.height / 12 -
                                    10,
                                left: 20,
                                child: Container(
                                  height: isSmallScreen ? 40 : 50,
                                  width: isSmallScreen ? 270 : 320,
                                  child: RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: '${'homepage-press'.tr()}',
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 14,
                                              color: Color(0xff5c5c5c),
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: '${'homepage-apply'.tr()}',
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 14,
                                              color: Color(0xff7898FF),
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: '${'homepage-matchingstart'.tr()}',
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 14,
                                              color: Color(0xff5c5c5c),
                                              fontWeight: FontWeight.bold,),

                                      ),
                                    ]),
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(60),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                            color: Colors.black38,
                                            offset: const Offset(0, 3))
                                      ]),
                                ),
                              ),//말풍선
                              Positioned(
                                  top: MediaQuery.of(context).size.height /10,
                                  right: 7,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 11,
                                          left: 0,
                                          child: Container(
                                            height: 11,
                                            width: 11,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(5)),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            height: 9,
                                            width: 9,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(5)),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 7,
                                          right: 7,
                                          child: Container(
                                            height: 7,
                                            width: 7,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),//말풍선 똥똥똥
                              Positioned(
                                child: Column(
                                  children: [
                                    Expanded(flex: 3, child: Container()),
                                    Expanded(
                                        flex: 7,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmallScreen ? 30 : 40,
                                            horizontal: 25,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [],
                                              ),
                                              Expanded(child: Container()),
                                              Center(
                                                child: Container(
                                                  //alignment: Alignment.center,
                                                  height:
                                                      isSmallScreen ? 210 : 240,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      buildButton(
                                                          false,
                                                          0,
                                                          context,
                                                          args,
                                                          isSmallScreen),
                                                      SizedBox(
                                                        width: isSmallScreen
                                                            ? 160
                                                            : 180,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(child: Container()),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ));
                } else if (args.status == 'PENDING' && index == 0 && clicked) {
                  showDialog(
                      context: context,
                      builder: (_) => Stack(
                            children: [
                              Positioned(
                                top: MediaQuery.of(context).size.height / 15 +
                                    AppBar().preferredSize.height,
                                right: 0,
                                child: Container(
                                  child: SvgPicture.asset('assets/character/handsdown1.svg',
                                    height: isSmallScreen ? 160 : 230,
                                    width: isSmallScreen ? 160 : 230,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ), //팔내리는 캐릭터
                              Positioned(
                                top: MediaQuery.of(context).size.height / 12 -
                                    35,
                                left: 25,
                                child: Container(
                                  height: isSmallScreen ? 50 : 65,
                                  width: isSmallScreen ? 270 : 320,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text:
                                              "${args.memberDetails.name}${'homepage-already'.tr()} ",
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 13,
                                              color: Color(0xff5c5c5c),
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: '${'homepage-progress'.tr()}' ,
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 13,
                                              color: Color(0xffFF8282),
                                              fontWeight: FontWeight.bold,
                                              height: 1.5)),
                                      TextSpan(
                                          text: '${'homepage-check'.tr()}',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 12 : 13,
                                            color: Color(0xff5c5c5c),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ]),
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(60),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                            color: Colors.black38,
                                            offset: const Offset(0, 3))
                                      ]),
                                ),
                              ),//말풍선
                              Positioned(
                                  top: MediaQuery.of(context).size.height / 10,
                                  right: 30,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 11,
                                          left: 0,
                                          child: Container(
                                            height: 11,
                                            width: 11,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            height: 9,
                                            width: 9,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 7,
                                          right: 7,
                                          child: Container(
                                            height: 7,
                                            width: 7,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )), //말풍선 똥똥똥
                              Positioned(
                                child: Column(
                                  children: [
                                    Expanded(flex: 3, child: Container()),
                                    Expanded(
                                        flex: 7,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmallScreen ? 30 : 40,
                                            horizontal: 25,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [],
                                              ),
                                              Expanded(child: Container()),
                                              Center(
                                                child: Container(
                                                  //alignment: Alignment.center,
                                                  height:
                                                      isSmallScreen ? 210 : 240,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: isSmallScreen
                                                            ? 160
                                                            : 180,
                                                      ),
                                                      buildButton(
                                                          false,
                                                          1,
                                                          context,
                                                          args,
                                                          isSmallScreen),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(child: Container()),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ));
                } else if (args.status == 'MATCHED' && index == 0 && clicked) {
                  showDialog(
                      context: context,
                      builder: (_) => Stack(
                            children: [
                              Positioned(
                                top: MediaQuery.of(context).size.height / 10 +
                                    AppBar().preferredSize.height,
                                right: 0,
                                child: Container(
                                  child: SvgPicture.asset('assets/character/handsdown1.svg',
                                    height: isSmallScreen ? 160 : 230,
                                    width: isSmallScreen ? 160 : 230,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height / 15-
                                    20,
                                left: 30,
                                child: Container(
                                  padding: EdgeInsets.only(right: 10),
                                  height: isSmallScreen ? 55 : 65,
                                  width: isSmallScreen ?290:320,
                                  child: RichText(
                                    textAlign: TextAlign.end,
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text:
                                              "${args.memberDetails.name}${'homepage-complete'.tr()} ",
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 13,
                                              color: Color(0xff5c5c5c),
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: '${'homepage-chatting'.tr()}',
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 13,
                                              color: Color(0xffFF8282),
                                              fontWeight: FontWeight.bold,
                                              height: 1.5)),
                                      TextSpan(
                                          text: '${'homepage-chatbutton'.tr()}',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 12 : 13,
                                            color: Color(0xff5c5c5c),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ]),
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(60),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                            color: Colors.black38,
                                            offset: const Offset(0, 3))
                                      ]),
                                ),
                              ),
                              Positioned(
                                  top: MediaQuery.of(context).size.height / 10,
                                  right: 40,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 10,
                                          left: 0,
                                          child: Container(
                                            height: 11,
                                            width: 11,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            height: 8,
                                            width: 9,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 6,
                                          right: 7,
                                          child: Container(
                                            height: 7,
                                            width: 7,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Positioned(
                                child: Column(
                                  children: [
                                    Expanded(flex: 3, child: Container()),
                                    Expanded(
                                        flex: 7,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmallScreen ? 30 : 40,
                                            horizontal: 25,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [],
                                              ),
                                              Expanded(child: Container()),
                                              Center(
                                                child: Container(
                                                  //alignment: Alignment.center,
                                                  height:
                                                      isSmallScreen ? 210 : 240,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: isSmallScreen
                                                            ? 160
                                                            : 180,
                                                      ),
                                                      buildButton(
                                                          false,
                                                          1,
                                                          context,
                                                          args,
                                                          isSmallScreen),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(child: Container()),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ));
                } else if (args.status == 'PENDING' && index == 1 && clicked) {
                  print('매칭 상태 확인 ㄱ');
                  Navigator.pushNamed(context, '/state', arguments: args);
                } else if (args.status == 'NOT_APPLIED' &&
                    index == 0 &&
                    clicked) {
                  Navigator.pushNamed(context, '/apply', arguments: args);
                } else if (args.status == 'MATCHED' && index == 1 && clicked) {
                  Navigator.pushNamed(context, '/done', arguments: args);
                } else {}
              },
              onTapDown: (TapDownDetails details) {
                setState(() {
                  isClick = true;
                });
              },
              onTapUp: (TapUpDetails details) {
                setState(() {
                  isClick = false;
                });
              },
              borderRadius: const BorderRadius.all(
                Radius.circular(30),
              ),
              child: index == 0
                  ? matchingButton(isSmallScreen, isClick, args.status)
                  : chattingButton(isSmallScreen, isClick, args.status)),
        ),
      ),
    );
  }

  Widget matchingButton(isSmallScreen, isClick, status) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          //내부 그림자
          BoxShadow(
            color:
                status != 'NOT_APPLIED' ? Color(0xffCBCBCB) : Color(0xff678CFF),
          ),
          //버튼색
          BoxShadow(
            blurRadius: 7,
            color:
                status != 'NOT_APPLIED' ? Color(0xffE0E0E0) : Color(0xffAEC1FF),
            spreadRadius: 14,
            offset: const Offset(-20, -20),
          ),
        ]),
        child: Stack(
          children: [
            //큰원
            Positioned(
              right: -35,
              bottom: -25,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(75),
                ),
                width: isSmallScreen ? 130 : 150,
                height: isSmallScreen ? 130 : 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          //큰원 내부그림자
                          BoxShadow(
                            color: status != 'NOT_APPLIED'
                                ? Color(0xffCBCBCB)
                                : Color(0xff678CFF),
                          ),
                          //큰원색
                          BoxShadow(
                            blurRadius: 7,
                            color: status != 'NOT_APPLIED'
                                ? Color(0xffEBEBEB)
                                : Color(0xFFCAD6FE),
                            spreadRadius: -2,
                            offset: const Offset(-40, -30),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            //작은 원
            Positioned(
              left: -25,
              top: -25,
              child: Container(
                decoration: BoxDecoration(
                  color: isClick
                      ? Color(0xff3762EC)
                      : status != 'NOT_APPLIED'
                          ? Color(0xffD7D7D7)
                          : Color(0xFF99B1FF),
                  borderRadius: BorderRadius.circular(50),
                ),
                width: isSmallScreen ? 90 : 95,
                height: isSmallScreen ? 90 : 95,
              ),
            ),
            Container(
              height: isSmallScreen ? 210 : 240,
              padding: EdgeInsets.only(left:25, top:20, right:6),
              decoration: BoxDecoration(),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status != 'NOT_APPLIED' ? '${'homepage-applydone'.tr()}' : '${'homepage-apply'.tr()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 16 : 18,
                      color: status != 'NOT_APPLIED'
                          ? Color(0xffACACAC)
                          : Colors.white,
                    ),
                  ),
                  Text(
                    'How to Use?',
                    style: TextStyle(
                        fontSize: isSmallScreen ? 10 : 12,
                        color: status != 'NOT_APPLIED'
                            ? Color(0xff888888)
                            : Color(0xff7898FF)),
                  ),
                  SizedBox(height: isSmallScreen?20:40),
                  Row(
                    children: [
                      Expanded(
                          flex : 3,
                          child: SizedBox()),
                      Expanded(
                          flex: 8,
                          child: status != 'NOT_APPLIED'
                              ? SvgPicture.asset('assets/character/none_puzzle.svg')
                              :SvgPicture.asset('assets/character/matching_puzzle.svg',
                          )
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chattingButton(isSmallScreen, isClick, status) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((25)),
            boxShadow: [
              //내부그림자
              BoxShadow(
                color: status == 'NOT_APPLIED'
                    ? Color(0xffCBCBCB)
                    : Color(0xffFF9393),
              ),
              //버튼색
              BoxShadow(
                blurRadius: 7,
                color: status == 'NOT_APPLIED'
                    ? Color(0xffE0E0E0)
                    : Color(0xffFFB5B5),
                spreadRadius: 14,
                offset: const Offset(-20, -20),
              ),
            ]),
        child: Stack(
          children: [
            Positioned(
              right: -35,
              top: -45,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(75),
                ),
                width: isSmallScreen ? 130 : 150,
                height: isSmallScreen ? 130 : 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: status == 'NOT_APPLIED'
                                ? Color(0xffCBCBCB)
                                : Color(0xffFF9393),
                          ),
                          BoxShadow(
                            blurRadius: 7,
                            color: status == 'NOT_APPLIED'
                                ? Color(0xffEBEBEB)
                                : Color(0xFFFFCECE),
                            spreadRadius: -2,
                            offset: const Offset(-40, 30),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            Positioned(
              left: -25,
              bottom: -25,
              child: Container(
                decoration: BoxDecoration(
                  color: status == 'NOT_APPLIED'
                      ? Color(0xffD7D7D7)
                      : Color(0xFFFFA6A6),
                  borderRadius: BorderRadius.circular(50),
                ),
                width: isSmallScreen ? 90 : 100,
                height: isSmallScreen ? 90 : 100,
              ),
            ),
            Container(
              height: isSmallScreen ? 210 : 240,
              padding: EdgeInsets.only(left:25, top:20, right:6),
              decoration: BoxDecoration(),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status == 'PENDING' ? '${'homepage-progress'.tr()}' : '${'homepage-chatting'.tr()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 16 : 18,
                      color: status == 'NOT_APPLIED'
                          ? Color(0xffACACAC)
                          : Colors.white,
                    ),
                  ),
                  Text(
                    'How to Use?',
                    style: TextStyle(
                        fontSize: isSmallScreen ? 10 : 12,
                        color: status == 'NOT_APPLIED'
                            ? Color(0xff888888)
                            : Color(0xffFF8F8F)),
                  ),
                  SizedBox(height: isSmallScreen?40:50),
                  Row(
                    children: [
                      Expanded(
                          flex : 3,
                          child: SizedBox()),
                      Expanded(
                          flex: 9,
                          child:status == 'NOT_APPLIED'?
                          SvgPicture.asset('assets/character/none_speech_bubble.svg')
                                :SvgPicture.asset('assets/character/speech_bubble.svg',
                            )
                          )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget settingWidget(BuildContext context, screenArguments) {
    //final AuthProvider authProvider = new AuthProvider();
    final storage = FlutterSecureStorage();
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth <= 600;

    File imageFile = File(screenArguments.memberDetails.profileImage);

    return Container(
      color: Color(0xffF5F7FF),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
                padding:
                    EdgeInsets.only(right: 20, left: 20, top: 17, bottom: 17),
                decoration: BoxDecoration(
                  color: Color(0xff7898FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.87,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: screenArguments.memberDetails.name.toString(),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 30 : 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: '님',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 12 : 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              screenArguments.memberDetails.birthday.toString(),
                              style: TextStyle(
                                  fontSize: isSmallScreen ? 12 : 14,
                                  color: Colors.white),
                            ),
                            Text(screenArguments.memberDetails.email.toString(),
                                style: TextStyle(
                                    fontSize: isSmallScreen ? 12 : 14,
                                    color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.09,
                            width: 80,
                            decoration: BoxDecoration(
                                color: screenArguments.memberDetails.profileImage != "" ? Colors.white : Colors.transparent,

                                borderRadius: BorderRadius.circular(40)),
                            child: screenArguments.memberDetails.profileImage != ""
                                ? SizedBox()
                                : SvgPicture.asset('assets/icon/icon_profile.svg', color:Colors.white,),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.038,
                                width: 30,
                                child: FloatingActionButton(
                                    backgroundColor: Color(0xffE5EBFF),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SimpleDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              children: [
                                                SimpleDialogOption(
                                                  child: Text(
                                                    '사진 찍기',
                                                  ),
                                                  onPressed: () async{
                                                    await getImage(ImageSource.camera);
// 로딩 재생
                                                    if (_profileImage != null && _profileImage?.path != null) {
                                                      String? imagePath = _profileImage?.path!;
                                                      if (await APIs.updateProfile(File(imagePath!))) {
                                                    Navigator.of(context).pushNamedAndRemoveUntil('/loading', (Route<dynamic> route) => false);
                                                    }
                                                  }

                                                    //로딩 재생
                                                  },
                                                ),
                                                SimpleDialogOption(child: Text('사진첩에서 가져오기'),
                                                  onPressed: () async {
                                                  await getImage(ImageSource.gallery);

                                                  // 로딩 재생
                                                  if (_profileImage != null && _profileImage?.path != null) {
                                                    String? imagePath = _profileImage?.path!;
                                                    if (await APIs.updateProfile(File(imagePath!))) {
                                                      Navigator.of(context).pushNamedAndRemoveUntil('/loading', (Route<dynamic> route) => false);
                                                    }
                                                  }

                                                  },
                                            ),
                                              ],
                                            );
                                          });
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icon/icon_modify.svg',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.019,
                                      width: MediaQuery.of(context).size.width *
                                          0.0415,
                                      color: Color(0xff7898FF),
                                    )),
                              ))
                        ],
                      ),
                    )
                  ],
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Expanded(
              flex: 5,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.87,
                padding:
                    EdgeInsets.only(right: 23, left: 23, top: 17, bottom: 17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.03,
                        child: Text(
                          '프로필 확인 및 수정',
                          style: TextStyle(
                            color: Color(0xffC1C1C1),
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: buildProfileList(
                              context, index - 1, screenArguments.memberDetails));
                    }
                  },
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Expanded(
              flex: 4,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.87,
                //margin: EdgeInsets.only(right: 24, left: 24),
                padding:
                    EdgeInsets.only(right: 20, left: 20, top: 17, bottom: 17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.03,
                        child: Text(
                          '계정관리',
                          style: TextStyle(
                            color: Color(0xffC1C1C1),
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: buildSettingList(
                              context, index - 1, screenArguments));
                    }
                  },
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () async {
                //http 로그아웃 요청
                //authProvider.logout(context);
                await APIs.logOut(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1.0, color: Color(0xFF7898FF))),
                ),
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    color: Color(0xFF7898FF),
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

/*  void updateMBTIValue(String selectedMBTI) {
    setState(() {
      memberInfo[index] = selectedMBTI;
    });
  }*/
}

