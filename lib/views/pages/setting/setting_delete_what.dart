import 'dart:convert';

import 'package:aliens/views/pages/matching/matching_edit_page.dart';
import 'package:flutter/cupertino.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';

import '../../../mockdatas/mockdata_model.dart';
import '../../components/appbar.dart';
import '../../components/button.dart';

class SettingDeleteWhatPage extends StatefulWidget {
  const SettingDeleteWhatPage({super.key});

  @override
  State<SettingDeleteWhatPage> createState() => _SettingDeleteWhatPageState();
}

class _SettingDeleteWhatPageState extends State<SettingDeleteWhatPage> {

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/icon/icon_back.svg',
              width: MediaQuery.of(context).size.width * 0.062,
              height: MediaQuery.of(context).size.height * 0.029,),
            color: Color(0xff7898FF),
          ),
          title: Text(
            '회원탈퇴',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(right: 20, left:20, top: MediaQuery.of(context).size.height * 0.06),
          child:
              Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('탈퇴하기',
                          style: TextStyle(
                              fontSize: isSmallScreen?22:24,
                              fontWeight: FontWeight.bold
                          ),),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text('잠깐! 탈퇴하게되면 아래의 기능들을 잃게 되요.',
                              style: TextStyle(
                                fontSize: isSmallScreen?12:14,
                                color: Color(0xff888888),
                              ),)),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.only(right: 20,left: 23),
                          width: MediaQuery.of(context).size.width* 0.9,
                          height: MediaQuery.of(context).size.height * 0.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color(0xffF5F7FF),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                //spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffD9D9D9),
                                ),
                              ),
                              SizedBox(width: 23),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('처음부터 다시 가입해야 해요.',
                                    style: TextStyle(
                                      fontSize: isSmallScreen?12:14,
                                      fontWeight: FontWeight.w700
                                    ),),
                                    SizedBox(height: 5),
                                    Text('탈퇴회원의 정보는 완벽히 삭제됩니다.\n탈퇴하시면 회원가입부터 다시 해야 해요',
                                    style: TextStyle(
                                      fontSize: isSmallScreen?10:12
                                    ),)
                                  ],
                                ),
                              )
                            ],
                          ),

                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.only(right: 20,left: 23),
                          width: MediaQuery.of(context).size.width* 0.9,
                          height: MediaQuery.of(context).size.height * 0.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color(0xffF5F7FF),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                //spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffD9D9D9),
                                ),
                              ),
                              SizedBox(width: 23),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('저장된 정보는 다시 복구되지 않아요.',
                                      style: TextStyle(
                                          fontSize: isSmallScreen?12:14,
                                          fontWeight: FontWeight.w700
                                      ),),
                                    SizedBox(height: 5),
                                    Text('회원정보 및 개인형 서비스(매칭, 대화 목록 등)\n데이터는 완전히 파기되어 복구되지 않아요.',
                                      style: TextStyle(
                                          fontSize: isSmallScreen?10:12
                                      ),)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.only(right: 20,left: 23),
                          width: MediaQuery.of(context).size.width* 0.9,
                          height: MediaQuery.of(context).size.height * 0.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color(0xffF5F7FF),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                //spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffD9D9D9),
                                ),
                              ),
                              SizedBox(width: 23),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('다양한 국적 및 배경을 가진 친구들과 \n교류할 수 있는 경험을 잃게돼요.',
                                      style: TextStyle(
                                          fontSize: isSmallScreen?12:14,
                                          fontWeight: FontWeight.w700
                                      ),),
                                    SizedBox(height: 5,),
                                    Text('더 다양한 친구들을 만나볼 기회를 잃게됩니다.',
                                      style: TextStyle(
                                          fontSize: isSmallScreen?10:12
                                      ),)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Container(
                          alignment: Alignment.center,
                          child: Text('다시 한번 생각해주세요.',
                              style: TextStyle(
                                  fontSize: isSmallScreen?12:14,
                                  color: Color(0xff888888)
                              )),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(bottom: 40),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Row(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height*0.06,
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: ElevatedButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('취소',
                                    style: TextStyle(color: Color(0xff888888),
                                        fontSize: isSmallScreen?14:16),),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xffEBEBEB),// 여기 색 넣으면됩니다
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40)
                                      )
                                  ),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Container(
                                height: MediaQuery.of(context).size.height*0.06,
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: ElevatedButton(
                                  onPressed: (){
                                    Navigator.pushNamed(context, '/setting/delete', arguments: memberDetails);
                                  },
                                  child: Text('탈퇴하기'),
                                    style: ElevatedButton.styleFrom(
                                        textStyle: TextStyle(fontSize: isSmallScreen?14:16),
                                        backgroundColor: Color(0xff7898FF),// 여기 색 넣으면됩니다
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40)
                                        )
                                    )
                                ),
                              )
                            ],
                    )
                    )
                      /*Row(
                      children: [
                        Button(child: Text('탈퇴하기'), onPressed: (){})
                      ],
                    )*/
                    /*Container(
                      width: double.maxFinite,
                      height: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil('/setting/delete', (Route<dynamic> route) => false
                          );
                        },
                        child: Text(
                          '탈퇴하기',
                          style: TextStyle(color: Color(0xffA7A7A7), fontSize: isSmallScreen?14:16),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffEBEBEB),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40))),
                      ),
                    ),*/
                    ),
            )],
              )


        )

    );

  }

}
