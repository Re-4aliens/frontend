import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../components/appbar.dart';
import '../../components/button.dart';

class MatchingApplyPage extends StatefulWidget {
  const MatchingApplyPage({super.key});

  @override
  State<MatchingApplyPage> createState() => _MatchingApplyPageState();
}

class _MatchingApplyPageState extends State<MatchingApplyPage> {
  @override
  Widget build(BuildContext context) {
    var memberDetails = ModalRoute.of(context)!.settings.arguments;


    return Scaffold(
        backgroundColor: Color(0xFFF4F4F4),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icon/icon_back.svg',
              width: 24,
              height: MediaQuery.of(context).size.height * 0.029,

            ),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        ),
        extendBodyBehindAppBar: true,
        body: _buildBody(memberDetails)
    );
  }

  Widget _buildBody(memberDetails){
    return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top : MediaQuery.of(context).size.height * 0.07, bottom: 60, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex : 3,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex : 5,
                    child: CustomPaint(
                        painter: HalfCircle(),
                      child: Container(),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.48, right: MediaQuery.of(context).size.width * 0.51,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.77,
                    height: 300,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xffF3F6FF))
                )),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('매칭신청을 시작합니다!',
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.039, fontWeight: FontWeight.bold),),
                  RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text:'\n선호언어', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),),
                            TextSpan(text: '에 따라 매칭이 되며,', style: TextStyle(fontSize: 16,color: Colors.black)),
                                ]
                            ),
                      ),
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text:'랜덤 선호언어 친구(SF)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.black),),
                          TextSpan(text: '가 추가됩니다', style: TextStyle(fontSize: 16,color: Colors.black)),
                        ]
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 20,left: 20,bottom: 40,top: 500),
              child: Positioned(
                child: Button(
                  child: Text('매칭 시작하기'),
                  onPressed: (){
                    Navigator.pushNamed(context,'/choose');
                  },

                ),

              ),
            )



          ],
    );
  }
}

class HalfCircle extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xffD8E1FF)
      ..style = PaintingStyle.fill;

    final radius = size.height / 2;
    final center = Offset(radius, size.height / 2);
    final startAngle = math.pi / 2; // 시작 각도 조정
    final sweepAngle = math.pi; // 반원 그리기

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, true, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
