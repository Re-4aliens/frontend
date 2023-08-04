
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';




Widget buildSettingList(context, index, screenArguments) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final bool isSmallScreen = screenWidth <= 600;
  List settingList = [
    '${'setting-security'.tr()}',
    '${'setting-noti'.tr()}',
    '${'setting-terms'.tr()}',
    '${'setting-inqury'.tr()}',
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
    Icon(
      Icons.contact_support,
      size: isSmallScreen?18:20,
      color: Colors.black,
    ),

  ];


  List navigatorList = [
    '/setting/security',
    '/setting/notification',
    '/setting/terms',
    ''
  ];

  return ListTile(
    onTap: () {
      Navigator.pushNamed(context, navigatorList.elementAt(index), arguments: screenArguments);
    },
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: EdgeInsets.only(left : MediaQuery.of(context).size.width * 0.012, right: MediaQuery.of(context).size.width * 0.04),
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
        Icon(
          Icons.arrow_forward_ios,
          size: isSmallScreen?16:18,
          color: Color(0xffC1C1C1),
        ),
      ],
    ),
  );
}