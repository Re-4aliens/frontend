import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import '../../../models/screen_argument.dart';

class SettingDeleteWhatPage extends StatefulWidget {
  const SettingDeleteWhatPage({super.key});

  @override
  State<SettingDeleteWhatPage> createState() => _SettingDeleteWhatPageState();
}

class _SettingDeleteWhatPageState extends State<SettingDeleteWhatPage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    var screenArguments =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/icon/icon_back.svg',
              width: MediaQuery.of(context).size.width * 0.062,
              height: MediaQuery.of(context).size.height * 0.029,
            ),
            color: const Color(0xff7898FF),
          ),
          title: Text(
            'setting-memwithdrawal'.tr(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
            padding: EdgeInsets.only(
                right: 20,
                left: 20,
                top: MediaQuery.of(context).size.height * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'setting-withdrawal'.tr(),
                  style: TextStyle(
                      fontSize: isSmallScreen ? 22 : 24,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'setting-deletewhat'.tr(),
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: const Color(0xff888888),
                      ),
                    )),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 11 / 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 0.5,
                                    offset: const Offset(0, 4)),
                              ],
                              gradient: const LinearGradient(
                                  colors: [Colors.white, Colors.white]),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      //내부 그림자
                                      BoxShadow(
                                        color: const Color(0xff7898FF)
                                            .withOpacity(0.3),
                                      ),

                                      const BoxShadow(
                                        blurRadius: 10,
                                        color: Colors.white,
                                        offset: Offset(-5, -5),
                                      )
                                    ]),
                                padding:
                                    const EdgeInsets.only(left: 20, right: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'setting-delete1'.tr(),
                                      style: TextStyle(
                                          fontSize: isSmallScreen ? 12 : 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'setting-delete1.1'.tr(),
                                      style: TextStyle(
                                          fontSize: isSmallScreen ? 10 : 12,
                                          color: const Color(0xff888888)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 11 / 35,
                            margin: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 10 : 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 0.5,
                                    offset: const Offset(0, 4)),
                              ],
                              gradient: const LinearGradient(
                                  colors: [Colors.white, Colors.white]),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      //내부 그림자
                                      BoxShadow(
                                        color: const Color(0xff7898FF)
                                            .withOpacity(0.3),
                                      ),

                                      const BoxShadow(
                                        blurRadius: 10,
                                        color: Colors.white,
                                        offset: Offset(-5, -5),
                                      )
                                    ]),
                                padding:
                                    const EdgeInsets.only(left: 20, right: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'setting-delete2'.tr(),
                                      style: TextStyle(
                                          fontSize: isSmallScreen ? 12 : 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'setting-delete2.1'.tr(),
                                      style: TextStyle(
                                          fontSize: isSmallScreen ? 10 : 12,
                                          color: const Color(0xff888888)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 11 / 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 0.5,
                                    offset: const Offset(0, 4)),
                              ],
                              gradient: const LinearGradient(
                                  colors: [Colors.white, Colors.white]),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      //내부 그림자
                                      BoxShadow(
                                        color: const Color(0xff7898FF)
                                            .withOpacity(0.3),
                                      ),

                                      const BoxShadow(
                                        blurRadius: 10,
                                        color: Colors.white,
                                        offset: Offset(-5, -5),
                                      )
                                    ]),
                                padding:
                                    const EdgeInsets.only(left: 20, right: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'setting-delete3'.tr(),
                                      style: TextStyle(
                                          fontSize: isSmallScreen ? 12 : 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'setting-delete3.1'.tr(),
                                      style: TextStyle(
                                          fontSize: isSmallScreen ? 10 : 12,
                                          color: const Color(0xff888888)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text('setting-onemore'.tr(),
                      style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: const Color(0xff888888))),
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Row(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.43,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xffEBEBEB), // 여기 색 넣으면됩니다
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40))),
                                child: Text(
                                  'cancel'.tr(),
                                  style: TextStyle(
                                      color: const Color(0xff888888),
                                      fontSize: isSmallScreen ? 14 : 16),
                                ),
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.43,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/setting/delete',
                                        arguments:
                                            screenArguments.memberDetails);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(
                                          fontSize: isSmallScreen ? 14 : 16),
                                      backgroundColor: const Color(0xff7898FF),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40))),
                                  child: Text('setting-withdrawal'.tr())),
                            )
                          ],
                        )))
              ],
            )));
  }
}
