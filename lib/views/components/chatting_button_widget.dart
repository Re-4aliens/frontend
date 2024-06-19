import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/screen_argument.dart';

class ChattingButton extends StatelessWidget {
  const ChattingButton(
      {super.key, required this.isClick, required this.screenArguments});

  final bool isClick;
  final ScreenArguments screenArguments;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30).r,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((25).r),
            boxShadow: [
              //내부그림자
              BoxShadow(
                color: screenArguments.status == 'NotAppliedAndNotMatched'
                    ? const Color(0xffCBCBCB)
                    : const Color(0xffFF9393),
              ),
              //버튼색
              BoxShadow(
                blurRadius: 7,
                color: screenArguments.status == 'NotAppliedAndNotMatched'
                    ? const Color(0xffE0E0E0)
                    : const Color(0xffFFB5B5),
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
                width: 150,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: screenArguments.status ==
                                    'NotAppliedAndNotMatched'
                                ? const Color(0xffCBCBCB)
                                : const Color(0xffFF9393),
                          ),
                          BoxShadow(
                            blurRadius: 7,
                            color: screenArguments.status ==
                                    'NotAppliedAndNotMatched'
                                ? const Color(0xffEBEBEB)
                                : const Color(0xFFFFCECE),
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
                  color: screenArguments.status == 'NotAppliedAndNotMatched'
                      ? const Color(0xffD7D7D7)
                      : const Color(0xFFFFA6A6),
                  borderRadius: BorderRadius.circular(50),
                ),
                width: 100,
                height: 100,
              ),
            ),
            Container(
              height: 240.h,
              padding: EdgeInsets.only(left: 25.r, top: 20.r, right: 15.r).r,
              decoration: const BoxDecoration(),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    screenArguments.status == 'AppliedAndNotMatched'
                        ? 'homepage-progress'.tr()
                        : 'homepage-chatting'.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.spMin,
                      color: screenArguments.status == 'NotAppliedAndNotMatched'
                          ? const Color(0xffACACAC)
                          : Colors.white,
                    ),
                  ),
                  Text(
                    'How to Use?',
                    style: TextStyle(
                        fontSize: 12.spMin,
                        color:
                            screenArguments.status == 'NotAppliedAndNotMatched'
                                ? const Color(0xff888888)
                                : const Color(0xffFF8F8F)),
                  ),
                  const Expanded(flex: 3, child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      screenArguments.status == 'NotAppliedAndNotMatched'
                          ? SvgPicture.asset(
                              'assets/character/none_speech_bubble.svg',
                              width: 100.r,
                            )
                          : SvgPicture.asset(
                              'assets/character/speech_bubble.svg',
                              width: 100.r,
                            )
                    ],
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
