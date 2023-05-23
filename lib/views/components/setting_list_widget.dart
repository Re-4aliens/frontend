
import 'package:flutter/material.dart';



Widget buildSettingList(context, index, memberDetails) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final bool isSmallScreen = screenWidth <= 600;
  List settingList = [
    '보안관리',
    '알림설정',
    '이용약관',
  ];

  List settingIcon = [
    Icon(
      Icons.lock_outline,
      size: isSmallScreen?18:20,
      color: Colors.black,
    ),
    Icon(
      Icons.notifications_none,
      size: isSmallScreen?18:20,
      color: Colors.black,
    ),
    Icon(
      Icons.assignment_outlined,
      size: isSmallScreen?18:20,
      color: Colors.black,
    ),
  ];


  List navigatorList = [
    '/setting/security',
    '/setting/notification',
    '/setting/terms',
  ];

  return ListTile(
    onTap: () {
      Navigator.pushNamed(context, navigatorList.elementAt(index), arguments: memberDetails);
    },
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.04),
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
        Icon(
          Icons.arrow_forward_ios,
          size: isSmallScreen?14:16,
          color: Color(0xffC1C1C1),
        ),
      ],
    ),
  );
}