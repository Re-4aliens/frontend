import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingTermsPage extends StatefulWidget {
  const SettingTermsPage({super.key});

  @override
  State<SettingTermsPage> createState() => _SettingTermsPageState();
}

class _SettingTermsPageState extends State<SettingTermsPage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth <= 600;

    List termsList = [
      '${'setting-terms'.tr()}',
      '${'setting-private'.tr()}',
    ];



    List navigatorList = [
      '/setting/terms/use',
      '/setting/terms/private'
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:CustomAppBar(appBar: AppBar(),backgroundColor: Colors.transparent, infookay: false, infocontent: '', title: '${'setting-terms'.tr()}',),
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (contex, index){
            return ListTile(
              onTap:() {
                Navigator.pushNamed(context, navigatorList.elementAt(index));
            },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${termsList.elementAt(index)}',
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
          },

        ),
      )
    );
  }
}
