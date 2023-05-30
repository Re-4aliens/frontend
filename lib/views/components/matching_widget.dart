import 'package:aliens/views/pages/loading_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/matching/matching_done_page.dart';


Widget matchingWidget(BuildContext context, args){
  return Stack(
    children: [
      //배경 디자인
      /*
          Expanded(child: Container(
            decoration: BoxDecoration( color: Colors.white),
          ),),
           */

      //버튼
      Center(

        child: Container(
          //alignment: Alignment.center,
          height: 245,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton('매칭 신청', 0, context, args),
              SizedBox(
                width: 20,
              ),

              buildButton('현재 진행 상황', 1, context, args),
            ],
          ),
        ),
      ),
      //글
      Container(
        padding: EdgeInsets.all(25),
        //decoration: BoxDecoration(color: Colors.green.shade500),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('매칭하기',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),
            SizedBox(height: 10,),

            Text('내 성향과 스타일을 분석해',
              style: TextStyle(
                fontSize: 16,
              ),),
            SizedBox(height: 5,),
            Text('나와 잘 맞는 친구를 소개해드려요',
              style: TextStyle(
                fontSize: 16,
              ),),
          ],
        ),
      ),
    ],
  );
}

Widget buildButton(String _title, int btnIndex, BuildContext context, args){
  return MaterialButton(
    minWidth: 165,
    height: 245,

    elevation: 3.0,
    highlightElevation: 1.0,
    onPressed: () async {
      if (btnIndex == 0)
        Navigator.pushNamed(context, '/apply', arguments: args);
      else{
        print(args.partners);
        Navigator.pushNamed(context, '/done', arguments: args.partners);
      }
    },
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
    color: Colors.white,
    textColor: Colors.black,
    child: Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(54),
          ),
          width: 108,
          height: 108,
        ),
        SizedBox(
          height: 40,
        ),
        Text(_title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
      ],
    ),
  );
}