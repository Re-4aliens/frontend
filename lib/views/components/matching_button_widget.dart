import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/screenArgument.dart';

class MatchingButton extends StatefulWidget {
  const MatchingButton({super.key, required this.isSmallScreen,
    required this.isClick,});

  final bool isSmallScreen;
  final bool isClick;

  @override
  State<MatchingButton> createState() => _MatchingButtonState();
}

class _MatchingButtonState extends State<MatchingButton> {
@override
Widget build(BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xff678CFF),
        ),
        BoxShadow(
          blurRadius: 7,
          color: Color(0xffAEC1FF),
          spreadRadius: 14,
          offset: const Offset(-20, -20),
        ),
      ]),
      child: Stack(
        children: [
          Positioned(
            right: -35,
            bottom: -25,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFCAD6FE),
                borderRadius: BorderRadius.circular(75),
              ),
              width: this.widget.isSmallScreen ? 130 : 150,
              height: this.widget.isSmallScreen ? 130 : 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff678CFF),
                        ),
                        BoxShadow(
                          blurRadius: 7,
                          color: Color(0xFFCAD6FE),
                          spreadRadius: -2,
                          offset: const Offset(-40, -30),
                        ),
                      ]),
                ),
              ),
            ),
          ),
          Positioned(
            left: -25,
            top: -25,
            child: Container(
              decoration: BoxDecoration(
                color: this.widget.isClick ? Color(0xff3762EC) : Color(0xFF99B1FF),
                borderRadius: BorderRadius.circular(50),
              ),
              width: this.widget.isSmallScreen ? 90 : 100,
              height: this.widget.isSmallScreen ? 90 : 100,
            ),
          ),
          Container(
            height: this.widget.isSmallScreen ? 210 : 240,
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '매칭신청',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'How to Use?',
                  style: TextStyle(fontSize: 12, color: Color(0xff7898FF)),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}