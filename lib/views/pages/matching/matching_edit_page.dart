import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/button.dart';

class MatchingEditPage extends StatefulWidget {
  const MatchingEditPage({super.key});

  @override
  State<MatchingEditPage> createState() => _MatchingEditPageState();
}

class _MatchingEditPageState extends State<MatchingEditPage> {
  final _nationlist = ['한국어', 'English', '中國語', '日本語'];
  var _firstPreferLanguage = '한국어';
  var _secondPreferLanguage = 'English';

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
                    Text('언어 재설정',
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
                ),
                Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Button(
                    //수정
                      isEnabled: true,
                      child: Text('확인'),
                      onPressed: (){
                        Navigator.pop(context);
                      }),
                )
              ],
            ),
        ),
        );
  }
}
