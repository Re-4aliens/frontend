import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/member_model.dart';

class MemberDetails {
  Member member = new Member(
    email: 'email@naver.com',
    password: 'example_password',
    mbti: 'ENFJ',
    gender: 'MALE',
    nationality: 'Korea',
    birthday: '2000-01-01',
    name: 'RYAN',
    profileImage: 'url',
    age: 26,
  );
}

class MatchingInfoPage extends StatefulWidget {
  const MatchingInfoPage({super.key, required this.title});

  final String title;

  @override
  State<MatchingInfoPage> createState() => _MatchingInfoPageState();
}

class _MatchingInfoPageState extends State<MatchingInfoPage> {
  @override
  Widget build(BuildContext context) {
    //var memberDetails = ModalRoute.of(context)!.settings.arguments;
    MemberDetails memberDetails = new MemberDetails();
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF4F4F4),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: _buildBody(memberDetails),
    );
  }

  Widget _buildBody(memberDetails) {
    return Center(
      child: Column(
        children: [
          Expanded(flex: 1, child: Container()),
          Expanded(
            flex: 20,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 1,
                      blurRadius: 3,
                    )
                  ]),
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 5, child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        memberDetails.member.name.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          color: Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.female),
                      )
                    ],
                  ),
                  Expanded(child: Container()),
                  Container(
                    width: 140,
                    height: 140,
                    margin: EdgeInsetsDirectional.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      color: Color(0xffA8A8A8),
                    ),
                  ),
                  Expanded(child: Container()),
                  Text(
                    '만 나이',
                    style: TextStyle(
                      color: Color(0xffD9D9D9),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${memberDetails.member.age}세',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    width: 350,
                    margin: EdgeInsets.only(left: 50, right: 50, top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              '국가',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xffD9D9D9),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 30,
                                  decoration:
                                      BoxDecoration(color: Color(0xffD9D9D9)),
                                  margin: EdgeInsets.only(right: 5),
                                ),
                                Text(
                                  memberDetails.member.nationality.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'MBTI',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xffD9D9D9),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              memberDetails.member.mbti.toString(),
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(flex: 5, child: Container()),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 14,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  //color: Colors.blue.shade300,
                  ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: 350,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        //color: Colors.blue,
                        ),
                    child: Text(
                      '매칭 선호 언어',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFFC4C4C4),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 117,
                        width: 165,
                        padding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 1,
                                blurRadius: 3,
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (true)
                              Container(
                                height: 30,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: Color(0xffD9D9D9),
                                ),
                              )
                            else
                              Container(),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              '1순위',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffD9D9D9),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              '한국어',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 117,
                        width: 165,
                        padding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 1,
                                blurRadius: 3,
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 30,
                              width: 45,
                              decoration: BoxDecoration(
                                color: Color(0xffD9D9D9),
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              '1순위',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffD9D9D9),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              '한국어',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  if (this.widget.title == '나의 매칭 정보')
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          //color: Colors.blue,
                          ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/edit');
                        },
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1.0, color: Color(0xFFC4C4C4))),
                          ),
                          child: Text(
                            '언어 재설정',
                            style: TextStyle(
                              color: Color(0xFFC4C4C4),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
