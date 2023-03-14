import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Widget matchingWidget(BuildContext context){
  return Stack(
    children: [
      //배경 디자인
      /*
          Expanded(child: Container(
            decoration: BoxDecoration(color: Colors.white),
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
              buildButton('매칭 신청', '/apply', context),
              SizedBox(
                width: 20,
              ),

              buildButton('현재 진행 상황', '/done', context),
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

Widget buildButton(String _title, String _path, BuildContext context){
  return MaterialButton(
    minWidth: 165,
    height: 245,

    elevation: 3.0,
    highlightElevation: 1.0,
    onPressed: () {
      Navigator.pushNamed(context, _path);
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