import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../components/button.dart';

class SettingLanEditPage extends StatefulWidget {
  const SettingLanEditPage({super.key});

  @override
  State<SettingLanEditPage> createState() => _SettingLanEditPageState();
}

class _SettingLanEditPageState extends State<SettingLanEditPage> {
  @override
  String? _selectedLanguage = '한국어';

  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth <= 600;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(appBar: AppBar(), backgroundColor: Colors.transparent, infookay: false, infocontent: '',title: '${'setting-lan'.tr()}',),
      body: Container(
        padding: EdgeInsets.only(right: 24,left: 24,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            /*Row(
              children: [
                Text('${'setting-lan'.tr()}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: isSmallScreen?22:24,
                  ),),
              ],
            ),*/
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              height: MediaQuery.of(context).size.height*0.14,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                //color: Colors.green.shade300,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${'setting-displaylan'.tr()}',
                    style: TextStyle(
                      fontSize: isSmallScreen?14:16,
                    ),),
                  Container(
                    width: 110,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedLanguage,
                      hint: Text(
                        _selectedLanguage!,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 20 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      items: <String>['한국어', 'English'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLanguage = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                //color: Colors.green,
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('매칭 선호 언어',
                    style: TextStyle(
                      fontSize: isSmallScreen?14:16,
                    ),),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text('1순위',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: isSmallScreen?12:14,
                            ),),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 110,
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text("한국어",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),),
                              items: [],
                              onChanged: (newValue) {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('2순위',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize:isSmallScreen?12:14,
                  ),),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: 110,
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text("English",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                    items: [],
                    onChanged: (newValue) {},
                  ),
                ),
              ],
            ),
            Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Button(
                //수정
                  isEnabled: true,
                  child: Text('${'confirm'.tr()}'),
                  onPressed: (){
                    if (_selectedLanguage == '한국어') {
                      EasyLocalization.of(context)!.setLocale(Locale('ko', 'KR'));
                    } else if (_selectedLanguage == 'English') {
                      EasyLocalization.of(context)!.setLocale(Locale('en', 'US'));
                    }
                    Navigator.pop(context);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
