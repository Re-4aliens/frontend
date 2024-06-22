import 'package:aliens/models/screen_argument.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aliens/views/components/build_button_widget.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key, required this.screenArguments});

  final ScreenArguments screenArguments;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffF2F5FF),
      ),
      child: Stack(children: [
        Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 25.w,
                ),
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '${'homepage-welcome'.tr()}\n',
                          style: TextStyle(
                              fontSize: 20.spMin,
                              color: const Color(0xff5A5A5A),
                              height: 1),
                        ),
                        EasyLocalization.of(context)!.locale ==
                                const Locale.fromSubtags(
                                    languageCode: "ko", countryCode: "KR")
                            ? TextSpan(children: [
                                TextSpan(
                                    text: 'homepage-welcome1.1'.tr(),
                                    style: TextStyle(
                                        fontSize: 24.spMin,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        height: 1.5.h)),
                                TextSpan(
                                    text: '${'homepage-welcome1.2'.tr()}\n',
                                    style: TextStyle(
                                        fontSize: 24.spMin,
                                        color: const Color(0xff5A5A5A))),
                              ])
                            : TextSpan(children: [
                                TextSpan(
                                    text: 'homepage-welcome1.1'.tr(),
                                    style: TextStyle(
                                        fontSize: 24.spMin,
                                        color: const Color(0xff5A5A5A))),
                                TextSpan(
                                    text: '${'homepage-welcome1.2'.tr()}\n',
                                    style: TextStyle(
                                        fontSize: 24.spMin,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        height: 1.5.h)),
                              ]),
                        TextSpan(
                            text: '${'homepage-happy'.tr()}\n',
                            style: TextStyle(
                                fontSize: 12.spMin,
                                color: const Color(0xff888888),
                                height: 2.h)),
                        TextSpan(
                            text: '${'homepage-positive1'.tr()} ',
                            style: TextStyle(
                                fontSize: 12.spMin,
                                color: const Color(0xff888888),
                                height: 1.5.h)),
                        TextSpan(
                            text: 'homepage-positive2'
                                .tr() /*'${args.memberDetails?.mbti}'*/,
                            style: TextStyle(
                                fontSize: 12.spMin,
                                color: const Color(0xff7898ff))),
                        TextSpan(
                            text: 'homepage-positive3'.tr(),
                            style: TextStyle(
                                fontSize: 12.spMin,
                                color: const Color(0xff888888))),
                        TextSpan(
                            text: 'homepage-positive4'.tr(),
                            style: TextStyle(
                                fontSize: 12.spMin,
                                color: const Color(0xff7898ff))),
                        TextSpan(
                            text: '${'homepage-positive5'.tr()}\n',
                            style: TextStyle(
                                fontSize: 12.spMin,
                                color: const Color(0xff888888))),
                        TextSpan(
                          text: '${'homepage-more'.tr()}\n',
                          style: TextStyle(
                              fontSize: 12.spMin,
                              color: Colors.black,
                              height: 2.5),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: InteractiveViewer(
                                        child: Image.asset(EasyLocalization.of(
                                                        context)!
                                                    .locale ==
                                                const Locale.fromSubtags(
                                                    languageCode: "ko",
                                                    countryCode: "KR")
                                            ? 'assets/character/${screenArguments.memberDetails!.mbti}_ko.PNG'
                                            : 'assets/character/${screenArguments.memberDetails!.mbti}_en.PNG'),
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(flex: 1, child: SizedBox()),
                      Text(
                        'homepage-start'.tr(),
                        style: TextStyle(
                          fontSize: 20.spMin,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff5C5C5C),
                        ),
                      ),
                      Text(
                        'homepage-meet'.tr(),
                        style: TextStyle(
                          fontSize: 16.spMin,
                          color: const Color(0xffababab),
                        ),
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: 240.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BuildButton(
                                  context: context,
                                  screenArguments: screenArguments,
                                  index: 0,
                                  clicked: true),
                              SizedBox(
                                width: 20.w,
                              ),
                              BuildButton(
                                  context: context,
                                  screenArguments: screenArguments,
                                  index: 1,
                                  clicked: true),
                            ],
                          ),
                        ),
                      ),
                      const Expanded(flex: 2, child: SizedBox()),
                    ],
                  ),
                ))
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 13,
          right: 0,
          child: SvgPicture.asset(
            'assets/character/handsup1.svg',
            height: 300.r,
            width: 300.r,
            //color: Color(0xffFFB5B5),
          ),
        ),
      ]),
    );
  }
}
