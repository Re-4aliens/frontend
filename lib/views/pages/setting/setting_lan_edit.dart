import 'dart:convert';

import 'package:aliens/mockdatas/mockdata_model.dart';
import 'package:aliens/models/memberDetails_model.dart';
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

  const SettingLanEditPage({super.key, required this.screenArguments, required this.isKorean});
  final ScreenArguments? screenArguments;
  final bool isKorean;

  @override
  State<SettingLanEditPage> createState() => _SettingLanEditPageState();
}

class _SettingLanEditPageState extends State<SettingLanEditPage> {
  late String _selectedLanguage;
  final List<Map<String, dynamic>> _nationlist = [
    {
      'language': '한국어',
      'value': 'KOREAN',
    }, //한국어
    {
      'language': 'English',
      'value': 'ENGLISH',
    }, //영어
    {
      'language': '中國語',
      'value': 'CHINESE',
    },//중국어
    {
      'language': '日本語',
      'value': 'JAPANESE',
    }//일본어
  ];
  late String _firstPreferLanguage;
  late String _secondPreferLanguage;

  @override
  void initState() {

    _selectedLanguage = widget.isKorean ? '한국어' : 'English';

    if(widget.screenArguments!.status != 'NOT_APPLIED'){

      _firstPreferLanguage = _nationlist.firstWhere((element) =>
      element['value'] == widget.screenArguments!.applicant!.preferLanguages!
          .firstPreferLanguage!)['language'];

      _secondPreferLanguage = _nationlist.firstWhere((element) => element['value'] == widget.screenArguments!.applicant!.preferLanguages!.secondPreferLanguage!)['language'];
    }else{
      _firstPreferLanguage = '한국어';
      _secondPreferLanguage = 'English';
    }

  }


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
            widget.screenArguments!.status != 'PENDING'
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
                            fontSize: isSmallScreen?16:18,
                            fontWeight: FontWeight.bold
                          ),),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text('${'first'.tr()}',
                                  style: TextStyle(
                                    color: Color(0xff7898ff),
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
                                            child: Text(value['language'],
                                              style: TextStyle(fontSize: isSmallScreen?20:22, fontWeight: FontWeight.bold),),
                                            value: value['language']);
                                      }).toList(),
                                      value: _firstPreferLanguage,
                                      onChanged: (value){
                                        setState(() {
                                          _firstPreferLanguage = value.toString();
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
                          color: Color(0xff7898ff),
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
                                  child: Text(value['language'],
                                    style: TextStyle(fontSize: isSmallScreen?20:22, fontWeight: FontWeight.bold),),
                                  value: value['language']);
                            }).toList(),
                            value: _secondPreferLanguage,
                            onChanged: (value){
                              print(value);
                              setState(() {
                                _secondPreferLanguage = value.toString();
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
                  onPressed: ()async{
                    if(_firstPreferLanguage != _secondPreferLanguage){
                      _firstPreferLanguage = _nationlist.firstWhere((element) => element['language'] == _firstPreferLanguage)['value'];
                      _secondPreferLanguage = _nationlist.firstWhere((element) => element['language'] == _secondPreferLanguage)['value'];
                      //펜딩일때만 수정
                      if(widget.screenArguments!.status == 'PENDING'){
                        if(await APIs.updatePreferLanguage(_firstPreferLanguage, _secondPreferLanguage)){
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/loading', (Route<dynamic> route) => false);
                          if (_selectedLanguage == '한국어') {
                            EasyLocalization.of(context)!.setLocale(Locale('ko', 'KR'));
                          } else {
                            EasyLocalization.of(context)!.setLocale(Locale('en', 'US'));
                          }
                        }
                      }
                      else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/loading', (Route<dynamic> route) => false);
                        if (_selectedLanguage == '한국어') {
                          EasyLocalization.of(context)!.setLocale(Locale('ko', 'KR'));
                        } else if (_selectedLanguage == 'English') {
                          EasyLocalization.of(context)!.setLocale(Locale('en', 'US'));
                        }
                      }
                    }

                  }),
            )
          ],
        ),
      ),
    );
  }
}
