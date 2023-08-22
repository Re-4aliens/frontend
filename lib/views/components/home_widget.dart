
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/views/components/build_button_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeWidget extends StatelessWidget{

  HomeWidget({super.key, required this.screenArguments});

  final ScreenArguments screenArguments;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '${'homepage-welcome'.tr()}\n',
                          style: TextStyle(
                              fontSize: 20, color: Color(0xff5A5A5A), height: 1),
                        ),
                        EasyLocalization.of(context)!.locale == Locale.fromSubtags(languageCode: "ko", countryCode: "KR") ?
                        TextSpan(children: [
                          TextSpan(
                              text: '${'homepage-welcome1.1'.tr()}',
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
                              text: '${'homepage-welcome1.1'.tr()}',
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
                            text: '${'homepage-positive1'.tr()} ',
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
                              fontSize: 12, color: Colors.black, height: 2.5),

                          recognizer: new TapGestureRecognizer()..onTap = () {
                            showDialog(context: context, builder: (context){
                              return InteractiveViewer(
                                child: Image.asset(
                                    EasyLocalization.of(context)!.locale == Locale.fromSubtags(languageCode: "ko", countryCode: "KR") ?
                                    'assets/character/${screenArguments.memberDetails!.mbti}_ko.PNG' :
                                    'assets/character/${screenArguments.memberDetails!.mbti}_en.PNG'
                                ),
                              );
                            });
                          },
                        )
                      ]),
                    ),
                  ],
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
                    vertical: 30,
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
                          height: 240,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildButton(context: context, screenArguments: screenArguments, index: 0, clicked: true),
                              SizedBox(
                                width: 20,
                              ),
                              buildButton(context: context, screenArguments: screenArguments, index: 1, clicked: true),
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
              height: 260,
              width: 260,
              //color: Color(0xffFFB5B5),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ]),
    );
  }

}