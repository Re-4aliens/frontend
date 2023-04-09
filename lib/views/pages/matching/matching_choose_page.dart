import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../components/appbar.dart';
import '../../components/button.dart';
import '../../components/language_button.dart';

class MatchingChoosePage extends StatefulWidget {
  const MatchingChoosePage({super.key});

  @override
  State<MatchingChoosePage> createState() => _MatchingChoosePageState();
}

class _MatchingChoosePageState extends State<MatchingChoosePage> {
  @override
  Widget build(BuildContext context) {
    var memberDetails = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        backgroundColor: Color(0xFFF4F4F4),
        appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
        body: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20,),
          child: Column(
            children: [
              Expanded(flex: 1,child: Container()),
              Column(
                children: [
                  Text(
                    '선호 언어 선택',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '상대방과 원하는 언어로 대화할 수 있어요.\n선호도에 따라 4가지 언어 중 선택 가능합니다.',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          languageButton(language: ('한국어'),),
                          SizedBox(
                            width: 20,
                          ),
                          languageButton(language: ('English'),),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          languageButton(language: ('中國語'),),
                          SizedBox(
                            width: 20,
                          ),
                          languageButton(language: ('日本語'),),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Button(
                      child: Text('확인'),
                      onPressed: (){
                        Navigator.pushNamed(context, '/apply/done', arguments: memberDetails);
                      }),
                ],
              ),
              Expanded(flex: 2,child: Container()),
            ],
          ),
        ));
  }
  
}
