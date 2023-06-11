import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildProfileList(context, index, memberDetails){
/*  var updatedMBTI = await Navigator.pushNamed(
    context, '/setting/MBTI/edit'
  );*/

  final double screenWidth = MediaQuery.of(context).size.width;
  final bool isSmallScreen = screenWidth <= 600;
  List settingList = [
    '성별',
    '국적',
    'MBTI',
    '언어 재설정',
  ];

  List settingIcon = [
    null,
    null,
    null,
    null,
  ];

  List memberInfo = [
    memberDetails.gender.toString(),
    memberDetails.nationality.toString(),
    memberDetails.mbti.toString(),
  ];


  return ListTile(
    onTap: () {
      if (index == 3)
        Navigator.pushNamed(context, '/setting/lan/edit');
      else if(index ==2)
        Navigator.pushNamed(context, '/setting/MBTI/edit');

    },
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (index > 3)
          Container(
            padding: EdgeInsets.only(right: 20),
            child: settingIcon.elementAt(index),
          ),
        Text(
          '${settingList.elementAt(index)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen?14:16,
          ),
        ),
        Expanded(child: Container()),
        if (index < 2)
          Text(
            '${memberInfo.elementAt(index)}',
            style: TextStyle(
                fontSize: isSmallScreen?16:18, color: Color(0xff7898FF)),
          )
        else if(index == 2)
          Row(children: [
            Text(
              '${memberInfo.elementAt(index)}',
              style: TextStyle(
                  fontSize: isSmallScreen?16:18, color: Color(0xff7898FF)),
            ),
            SizedBox(width: 1),
            Icon(
              Icons.arrow_forward_ios,
              size: isSmallScreen?14:16,
              color: Color(0xff4D4D4D),
            )
          ],
          )
        else
          Icon(
            Icons.arrow_forward_ios,
            size: isSmallScreen?14:16,
            color: Color(0xff4d4d4d),
          ),
      ],
    ),
  );
}