import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../apis/apis.dart';
import '../../../models/applicant_model.dart';
import '../../../models/screenArgument.dart';
import '../../components/button.dart';

class SettingLanEditPage extends StatefulWidget {
  const SettingLanEditPage({super.key});

  @override
  State<SettingLanEditPage> createState() => _SettingLanEditPageState();
}

class _SettingLanEditPageState extends State<SettingLanEditPage> {
  @override
  String? _selectedLanguage = '한국어';
  final _nationlist = ['한국어', 'English', '中國語', '日本語'];
  var _firstPreferLanguage = '한국어';
  var _secondPreferLanguage = 'English';

  ScreenArguments? args;

/*  void initState() {
    super.initState();
    _selectedLanguage = _nationlist[0];
    print(ModalRoute.of(context)?.settings.arguments);
    _loadInitialLanguages();
  }

  // 서버에서 언어 정보를 가져오는 함수
  Future<void> _loadInitialLanguages() async {
    try {
      final applicant = await APIs.getMemberDetails();
      final applicantData = Applicant.fromJson(applicant);

      args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

      if (args != null && args!.status != 'NOT_APPLIED') {
        setState(() {
          _firstPreferLanguage = applicantData.preferLanguages?.firstPreferLanguage ?? _nationlist[0];
          _secondPreferLanguage = applicantData.preferLanguages?.secondPreferLanguage ?? _nationlist[1];
        });
      }
    } catch (error) {
      print('Error loading initial languages: $error');
      // 에러 처리
    }
  }*/


  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),

            /*Row(
              children: [
                Text('${'setting-lan'.tr()}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: isSmallScreen?22:24,
                  ),),
              ],
            ),*/
            //SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              height: MediaQuery.of(context).size.height*0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                //color: Colors.green.shade300,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${'setting-displaylan'.tr()}',
                    style: TextStyle(
                      fontSize: isSmallScreen?16:18,
                      fontWeight: FontWeight.bold
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
            Divider(
              thickness: 1,
              color: Color(0xffECECEC),
            ),

            //신청이 안된 상태일때는 빈공간
            args.status == 'NOT_APPLIED'
                ? SizedBox(child: Container(),)
                : Container(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${'matchingpreferlan'.tr()}',
                          style: TextStyle(
                            fontSize: isSmallScreen?14:16,
                          ),),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text('${'first'.tr()}',
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
                                      items: _nationlist.map((value){
                                        return DropdownMenuItem(
                                            child: Text(value,
                                              style: TextStyle(fontSize: isSmallScreen?20:22, fontWeight: FontWeight.bold),),
                                            value: value);
                                      }).toList(),
                                      value: _firstPreferLanguage,
                                      onChanged: (value){
                                        print(value);
                                        setState(() {
                                          _firstPreferLanguage = value!;
                                        });}
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ), //1순위
                  ), //매칭선호언어 글자+1순위
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${'second'.tr()}',
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
                            items: _nationlist.map((value){
                              return DropdownMenuItem(
                                  child: Text(value,
                                    style: TextStyle(fontSize: isSmallScreen?20:22, fontWeight: FontWeight.bold),),
                                  value: value);
                            }).toList(),
                            value: _secondPreferLanguage,
                            onChanged: (value){
                              print(value);
                              setState(() {
                                _secondPreferLanguage = value!;
                              });}
                        ),
                      ),
                    ],
                  ),//2순위
                ],
              ),
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
