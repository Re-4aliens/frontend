
import 'package:aliens/views/components/matching_button_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/screenArgument.dart';
import 'chatting_button_widget.dart';

class buildButton extends StatefulWidget{
  buildButton({super.key, required this.context, required this.screenArguments, required this.index, required this.clicked});

  final ScreenArguments screenArguments;
  final BuildContext context;
  final bool clicked;
  final int index;


  @override
  State<StatefulWidget> createState() => _buildButtonState();
}

class _buildButtonState extends State<buildButton>{

  bool isClick = false;

  @override
  Widget build(BuildContext context) {
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
        borderRadius: BorderRadius.all(
          Radius.circular(30).r,
        ),
        child: Ink(
          width: 160.r,
          decoration: BoxDecoration(
            color: widget.index == 0 ? Color(0xffAEC1FF) : Color(0xffFFB5B5),
            borderRadius: BorderRadius.all(
              Radius.circular(30).r,
            ),
          ),
          child: InkWell(
              onTap: () {
                print(widget.clicked);
                if (widget.screenArguments.status == 'NOT_APPLIED' && widget.index == 1 && widget.clicked) {
                  /*
                  showDialog(
                      context: context,
                      builder: (_) => Stack(
                        children: [
                          Positioned(
                            top: MediaQuery.of(context).size.height / 13 +
                                AppBar().preferredSize.height,
                            right: 0,
                            child: Container(
                              child: SvgPicture.asset('assets/character/handsdown1.svg',
                                height: 260,
                                width: 260,
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
                              height: 50,
                              width: 320,
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: '${'homepage-press'.tr()}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff5c5c5c),
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: '${'homepage-apply'.tr()}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff7898FF),
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text: '${'homepage-matchingstart'.tr()}',
                                    style: TextStyle(
                                      fontSize: 14,
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
                                        vertical: 40,
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
                                              height:240,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  /*
                                                  buildButton(
                                                      false,
                                                      0,
                                                      context,
                                                      args,
                                                      isSmallScreen),

                                                   */
                                                  SizedBox(
                                                    width: 180,
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
                  */
                }
                else if (widget.screenArguments.status == 'PENDING' && widget.index == 0 && widget.clicked) {
                  /*
                  showDialog(
                      context: context,
                      builder: (_) => Stack(
                        children: [
                          Positioned(
                            top: MediaQuery.of(context).size.height / 13 +
                                AppBar().preferredSize.height,
                            right: 0,
                            child: Container(
                              child: SvgPicture.asset('assets/character/handsdown1.svg',
                                height: 260,
                                width: 260,
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
                              height: 65,
                              width: 320,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                      "${widget.screenArguments.memberDetails!.name}${'homepage-already'.tr()} ",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xff5c5c5c),
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: '${'homepage-progress'.tr()}' ,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xffFF8282),
                                          fontWeight: FontWeight.bold,
                                          height: 1.5)),
                                  TextSpan(
                                      text: '${'homepage-check'.tr()}',
                                      style: TextStyle(
                                        fontSize: 13,
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
                                        vertical: 40,
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
                                              240,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  SizedBox(
                                                    width: 180,
                                                  ),
                                                  /*
                                                  buildButton(
                                                      false,
                                                      1,
                                                      context,
                                                      args,
                                                      isSmallScreen),

                                                   */
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
                  */
                }
                else if (widget.screenArguments.status == 'MATCHED' && widget.index == 0 && widget.clicked) {
                  /*
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
                                height: 260,
                                width:  260,
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
                              height: 65,
                              width: 320,
                              child: RichText(
                                textAlign: TextAlign.end,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                      "${widget.screenArguments.memberDetails!.name}${'homepage-complete'.tr()} ",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xff5c5c5c),
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: '${'homepage-chatting'.tr()}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xffFF8282),
                                          fontWeight: FontWeight.bold,
                                          height: 1.5)),
                                  TextSpan(
                                      text: '${'homepage-chatbutton'.tr()}',
                                      style: TextStyle(
                                        fontSize: 13,
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
                                        vertical: 40,
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
                                              height: 240,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  SizedBox(
                                                    width:180,
                                                  ),
                                                  /*
                                                  buildButton(
                                                      false,
                                                      1,
                                                      context,
                                                      args,
                                                      isSmallScreen),

                                                   */
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
                  */
                }
                else if (widget.screenArguments.status == 'PENDING' && widget.index == 1 && widget.clicked) {
                  Navigator.pushNamed(context, '/state', arguments: widget.screenArguments);
                }
                else if (widget.screenArguments.status == 'NOT_APPLIED' &&
                    widget.index == 0 &&
                    widget.clicked) {
                  Navigator.pushNamed(context, '/apply', arguments: widget.screenArguments);
                }
                else if (widget.screenArguments.status == 'MATCHED' && widget.index == 1 && widget.clicked) {
                  Navigator.pushNamed(context, '/done', arguments: widget.screenArguments);
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
              borderRadius: BorderRadius.all(
                Radius.circular(30).r,
              ),
              child: widget.index == 0
                  ? MatchingButton(isClick: isClick,screenArguments: widget.screenArguments,)
                  : ChattingButton(isClick: isClick,screenArguments: widget.screenArguments,),
        ),
      ),
      )
    );
  }

}