import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/screenArgument.dart';

class MatchingButton extends StatelessWidget {
  MatchingButton({super.key, required this.isClick, required this.screenArguments});

  final bool isClick;
  final ScreenArguments screenArguments;

@override
Widget build(BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: Container(
      decoration: BoxDecoration(boxShadow: [
        //내부 그림자
        BoxShadow(
          color:
          screenArguments.status != 'NOT_APPLIED' ? Color(0xffCBCBCB) : Color(0xff678CFF),
        ),
        //버튼색
        BoxShadow(
          blurRadius: 7,
          color:
          screenArguments.status != 'NOT_APPLIED' ? Color(0xffE0E0E0) : Color(0xffAEC1FF),
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
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        //큰원 내부그림자
                        BoxShadow(
                          color: screenArguments.status != 'NOT_APPLIED'
                              ? Color(0xffCBCBCB)
                              : Color(0xff678CFF),
                        ),
                        //큰원색
                        BoxShadow(
                          blurRadius: 7,
                          color: screenArguments.status != 'NOT_APPLIED'
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
                color: screenArguments.status != 'NOT_APPLIED'
                    ? Color(0xffD7D7D7) // 회색
                    : Color(0xFF99B1FF), //하늘
                borderRadius: BorderRadius.circular(50),
              ),
              width: 95,
              height: 95,
            ),
          ),
          Container(
            height: 240,
            padding: EdgeInsets.only(left:25, top:20, right:6),
            decoration: BoxDecoration(),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  screenArguments.status != 'NOT_APPLIED' ? '${'homepage-applydone'.tr()}' : '${'homepage-apply'.tr()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: screenArguments.status != 'NOT_APPLIED'
                        ? Color(0xffACACAC)
                        : Colors.white,
                  ),
                ),
                Text(
                  'How to Use?',
                  style: TextStyle(
                      fontSize: 12,
                      color: screenArguments.status != 'NOT_APPLIED'
                          ? Color(0xff888888)
                          : Color(0xff7898FF)),
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                        flex : 3,
                        child: SizedBox()),
                    Expanded(
                        flex: 8,
                        child: screenArguments.status != 'NOT_APPLIED'
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

}