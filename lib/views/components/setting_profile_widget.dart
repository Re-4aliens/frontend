import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../pages/setting/setting_lan_edit.dart';
import '../pages/setting/setting_mbti_edit.dart';


Widget buildProfileList(context, index, screenArgument){
/*  var updatedMBTI = await Navigator.pushNamed(
    context, '/setting/MBTI/edit'
  );*/

  final double screenWidth = MediaQuery.of(context).size.width;
  final bool isSmallScreen = screenWidth <= 600;
  List settingList = [
    '${'setting-gender'.tr()}',
    '${'setting-nationality'.tr()}',
    'MBTI',
    '${'setting-lan'.tr()}',
  ];

  List settingIcon = [
    Icon(
      Icons.sentiment_very_satisfied,
      size: isSmallScreen?18:20,
      color: Colors.black,
    ),
    Icon(
      Icons.favorite_border,
      size: isSmallScreen?18:20,
      color: Colors.black,
    ),
    Icon(
      Icons.drafts,
      size: isSmallScreen?18:20,
      color: Colors.black,
    ),
    Icon(
      Icons.sentiment_very_satisfied,
      size: isSmallScreen?18:20,
      color: Colors.black,
    ),
  ];

  List memberInfo = [
    screenArgument.memberDetails.gender.toString(),
    screenArgument.memberDetails.nationality.toString(),
    screenArgument.memberDetails.mbti.toString(),
  ];


  bool _isKorean = EasyLocalization.of(context)!.locale == Locale.fromSubtags(languageCode: "ko", countryCode: "KR");
  return ListTile(
    onTap: () {
      if (index == 3)
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SettingLanEditPage(
                  screenArguments: screenArgument,
                isKorean: _isKorean
              )),
        );
      else if(index ==2)
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SettingMBTIEditPage(
                  screenArguments: screenArgument
              )),
        );
    },
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(left : MediaQuery.of(context).size.width * 0.012, right: MediaQuery.of(context).size.width * 0.04),
          child: settingIcon.elementAt(index),
        ),
        if (index > 3)
          Container(
            padding: EdgeInsets.only(right: 20),
            child: settingIcon.elementAt(index),
          ),
        Text(
          '${settingList.elementAt(index)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen?16:18,
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
              size: isSmallScreen?16:18,
              color: Color(0xff4D4D4D),
            )
          ],
          )
        else
          Icon(
            Icons.arrow_forward_ios,
            size: isSmallScreen?16:18,
            color: Color(0xff4d4d4d),
          ),
      ],
    ),
  );
}