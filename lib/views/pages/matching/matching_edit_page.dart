import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/button.dart';

class MatchingEditPage extends StatefulWidget {
  const MatchingEditPage({super.key});

  @override
  State<MatchingEditPage> createState() => _MatchingEditPageState();
}

class _MatchingEditPageState extends State<MatchingEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              //아이콘 수정 필요
              icon: Icon(CupertinoIcons.question_circle),
              color: Colors.black,
            )
          ],
        ),
        body: Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Row(
                  children: [
                    Text('언어 재설정',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),),
                  ],
                ),
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    //color: Colors.green.shade300,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('표시 언어',
                      style: TextStyle(
                        fontSize: 16,
                      ),),
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
                          fontSize: 16,
                        ),),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text('1순위',
                                style: TextStyle(
                                  color: Color(0xffD9D9D9),
                                  fontSize: 14,
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
                      color: Color(0xffD9D9D9),
                      fontSize: 14,
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
                SizedBox(
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Button(
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
