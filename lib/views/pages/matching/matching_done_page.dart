import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../components/button.dart';

class MatchingDonePage extends StatefulWidget {
  const MatchingDonePage({super.key});

  @override
  State<MatchingDonePage> createState() => _MatchingDonePageState();
}

class _MatchingDonePageState extends State<MatchingDonePage> {
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
        body: Center(
          child: Column(
            children: [
              Expanded(flex: 1, child: Container()),
              Text(
                '매칭이 완료되었어요!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '새로운\n친구를 만나러 가볼까요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Expanded(
                flex: 6,
                child: Container(
                  width: 300,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 40,
                        left: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          width: 50,
                          height: 50,
                        ),
                      ),
                      Positioned(
                        top: 80,
                        right: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          width: 80,
                          height: 80,
                        ),
                      ),
                      Positioned(
                        bottom: 80,
                        right: 70,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(78),
                          ),
                          width: 156,
                          height: 156,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      barrierColor: Colors.white,
                      backgroundColor: Colors.white,
                      builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.85,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Color(0xFFF4F4F4),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(right: 15, top: 15),
                                child: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                ),
                                alignment: Alignment.centerRight,
                              ),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                child: Text('매칭 목록',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                alignment: Alignment.center,
                              ),
                              for(int i = 0; i < 4; i++)
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: 350,
                                    child: Column(
                                      children: [
                                        matchingList(),

                                      ],
                                      mainAxisAlignment: MainAxisAlignment.center,
                                    ),
                                  ),
                                ),
                              Expanded(flex: 1, child: Container()),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Button(
                                   child: Text('채팅하기'),
                                    onPressed: (){
                                      Navigator.pop(context);
                                      Navigator.pop(context, true);
                                     }),
                              ),
                              Expanded(flex: 2, child: Container()),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(flex:2, child: Container()),
                        Expanded(
                          flex: 1,
                          child: Text(
                          '매칭 목록',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                            textAlign: TextAlign.start,
                        ),),
                        Expanded(flex:1, child: Container()),
                        Expanded(flex:1, child: Icon(Icons.keyboard_arrow_down_outlined),),
                        Expanded(flex:2, child: Container()),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget matchingList() {
    return Container(
      child: MaterialButton(
        minWidth: 350,
        height: 77,
        padding: EdgeInsets.symmetric(horizontal: 15),
        elevation: 3.0,
        highlightElevation: 1.0,
        onPressed: () {
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: Colors.white,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            Expanded(child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Mila',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),),
                      SizedBox(
                        width: 3,
                      ),
                      Container(
                        height: 18,
                        width: 18,
                        child: Icon(Icons.female, size: 18,),
                        decoration: BoxDecoration(
                          color: Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(9),
                        ),
                      )
                    ],
                  ),
                  Text('ISFP',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffA4A4A4),
                  ),),
                ],
              ),
            )),
            Container(
              height: 30,
              width: 50,
              decoration: BoxDecoration(
                color: Color(0xffD9D9D9),
              ),
            )
          ],
        ),
      ),
    );
  }
}
