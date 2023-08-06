import 'dart:convert';

import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aliens/apis/apis.dart';
import '../../../apis/apis.dart';
import '../../components/button.dart';

class MatchingEditPage extends StatefulWidget {
  const MatchingEditPage({super.key, required this.screenArguments});

  final ScreenArguments screenArguments;
  @override
  State<MatchingEditPage> createState() => _MatchingEditPageState();
}

class _MatchingEditPageState extends State<MatchingEditPage> {
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

    _firstPreferLanguage = _nationlist.firstWhere((element) => element['value'] == widget.screenArguments!.applicant!.preferLanguages!.firstPreferLanguage!)['language'];
    _secondPreferLanguage = _nationlist.firstWhere((element) => element['value'] == widget.screenArguments!.applicant!.preferLanguages!.secondPreferLanguage!)['language'];

  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth <= 600;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(appBar: AppBar(), backgroundColor: Colors.transparent, infookay: false, infocontent: '',title: '',),
        body: Container(
          padding: EdgeInsets.only(right: 24,left: 24,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Row(
                  children: [
                    Text('${'matchingpreferlan'.tr()}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: isSmallScreen?22:24,
                    ),),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                /*Container(
                  height: MediaQuery.of(context).size.height*0.14,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    //color: Colors.green.shade300,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('표시 언어',
                      style: TextStyle(
                        fontSize: isSmallScreen?14:16,
                      ),),
                      Container(
                        width: 110,
                        child: DropdownButton(
                          isExpanded: true,
                          hint: Text("한국어",
                            style: TextStyle(
                              fontSize: isSmallScreen?20:22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),),
                          items: [

                          ],
                          onChanged: (newValue) {

                          },
                        ),
                      ),
                    ],
                  ),
                ),*/
                Container(
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
                                          child: Text(value['language'],
                                          style: TextStyle(fontSize: isSmallScreen?20:22, fontWeight: FontWeight.bold),),
                                    value: value['language']);
                                    }).toList(),
                                          value: _firstPreferLanguage,
                                          onChanged: (value){
                                            print(value);
                                            setState(() {
                                              _firstPreferLanguage = value!.toString();
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
                                      child: Text(value['language'],
                                        style: TextStyle(fontSize: isSmallScreen?20:22, fontWeight: FontWeight.bold),),
                                      value: value['language']);
                                }).toList(),
                                value: _secondPreferLanguage,
                                onChanged: (value){
                                  setState(() {
                                    _secondPreferLanguage = value!.toString();
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
                      onPressed: () async {
                        if(_firstPreferLanguage != _secondPreferLanguage){
                          _firstPreferLanguage = _nationlist.firstWhere((element) => element['language'] == _firstPreferLanguage)['value'];
                          _secondPreferLanguage = _nationlist.firstWhere((element) => element['language'] == _secondPreferLanguage)['value'];

                          if(await APIs.updatePreferLanguage(_firstPreferLanguage, _secondPreferLanguage)){
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/loading', (Route<dynamic> route) => false);
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
