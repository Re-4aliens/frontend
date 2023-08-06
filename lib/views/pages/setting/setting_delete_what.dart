import 'dart:convert';

import 'package:aliens/views/pages/matching/matching_edit_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';

import '../../../mockdatas/mockdata_model.dart';
import '../../../models/screenArgument.dart';
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


    var screenArguments = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

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
            '${'setting-memwithdrawal'.tr()}',
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
                        Text('${'setting-withdrawal'.tr()}',
                          style: TextStyle(
                              fontSize: isSmallScreen?22:24,
                              fontWeight: FontWeight.bold
                          ),),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text('${'setting-deletewhat'.tr()}',
                              style: TextStyle(
                                fontSize: isSmallScreen?12:14,
                                color: Color(0xff888888),
                              ),)),
                        SizedBox(height: 10),
                        Container(

                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 11/35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 0.5,
                                  offset: const Offset(0, 4)),
                            ],
                            gradient: LinearGradient(colors: [Colors.white, Colors.white]),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.15,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      //내부 그림자
                                      BoxShadow(
                                        color: Color(0xff7898FF).withOpacity(0.3),
                                      ),

                                      BoxShadow(
                                        blurRadius: 10,
                                        color: Colors.white,
                                        offset: const Offset(-5, -5),
                                      )
                                    ]),
                                padding: EdgeInsets.only(left: 20, right: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${'setting-delete1'.tr()}',
                                      style: TextStyle(
                                          fontSize: isSmallScreen?12:14,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    SizedBox(height: 5),
                                    Text('${'setting-delete1.1'.tr()}',
                                      style: TextStyle(
                                          fontSize: isSmallScreen?10:12,
                                        color: Color(0xff888888)
                                      ),)
                                  ],
                                ),
                              ),
                            ),
                        ),
                        Container(

                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 11/35,
                          margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 0.5,
                                  offset: const Offset(0, 4)),
                            ],
                            gradient: LinearGradient(colors: [Colors.white, Colors.white]),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    //내부 그림자
                                    BoxShadow(
                                      color: Color(0xff7898FF).withOpacity(0.3),
                                    ),

                                    BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.white,
                                      offset: const Offset(-5, -5),
                                    )
                                  ]),
                              padding: EdgeInsets.only(left: 20, right: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${'setting-delete2'.tr()}',
                                    style: TextStyle(
                                        fontSize: isSmallScreen?12:14,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  SizedBox(height: 5),
                                  Text('${'setting-delete2.1'.tr()}',
                                    style: TextStyle(
                                        fontSize: isSmallScreen?10:12,
                                        color: Color(0xff888888)
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(

                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 11/35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 0.5,
                                  offset: const Offset(0, 4)),
                            ],
                            gradient: LinearGradient(colors: [Colors.white, Colors.white]),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),

                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.15,

                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    //내부 그림자
                                    BoxShadow(
                                      color: Color(0xff7898FF).withOpacity(0.3),
                                    ),

                                    BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.white,
                                      offset: const Offset(-5, -5),
                                    )
                                  ]),
                              padding: EdgeInsets.only(left: 20, right: 30),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${'setting-delete3'.tr()}',
                                    style: TextStyle(
                                        fontSize: isSmallScreen?12:14,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  SizedBox(height: 5),
                                  Text('${'setting-delete3.1'.tr()}',
                                    style: TextStyle(
                                        fontSize: isSmallScreen?10:12,
                                        color: Color(0xff888888)
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Container(
                          alignment: Alignment.center,
                          child: Text('${'setting-onemore'.tr()}',
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
                                  child: Text('${'cancel'.tr()}',
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
                                    Navigator.pushNamed(context, '/setting/delete', arguments: screenArguments.memberDetails);
                                  },
                                  child: Text('${'setting-withdrawal'.tr()}'),
                                    style: ElevatedButton.styleFrom(
                                        textStyle: TextStyle(fontSize: isSmallScreen?14:16),
                                        backgroundColor: Color(0xff7898FF),
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
