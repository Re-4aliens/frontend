import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/appbar.dart';

class SettingDeletePage extends StatefulWidget {
  const SettingDeletePage({super.key});

  @override
  State<SettingDeletePage> createState() => _SettingDeletePageState();
}

class _SettingDeletePageState extends State<SettingDeletePage> {
  final TextEditingController passwordController = new  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    var memberDetails = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
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
        body: Container(
          padding: EdgeInsets.only(right: 20, left:20, top: MediaQuery.of(context).size.height * 0.06),
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
                  child: Text('비밀번호를 입력하여 주세요.',
                    style: TextStyle(
                      fontSize: isSmallScreen?12:14,
                      color: Color(0xffb8b8b8),
                    ),)),
              SizedBox(
                height: 20,
              ),
              _passwordCheck(memberDetails),
            ],
          ),
        )
    );
  }
  Widget _passwordCheck(memberDetails){
    return Container(
      width: 250,
      child: TextFormField(
        controller: passwordController,
        decoration: InputDecoration(

        ),

        onEditingComplete: (){
          FocusScope.of(context).unfocus();
          //auth에서 불러오기
          if(passwordController.text == memberDetails.member.password) {
            showDialog(context: context, builder: (BuildContext context) => CupertinoAlertDialog(

              title: Text('정말 탈퇴하시겠어요?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
              content: const Text('채팅내역, 매칭내역 등 이제까지 사용해주신\n데이터들은 복구되지 않아요.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                ),
                TextButton(
                  onPressed: () {
                    //탈퇴

                    Navigator.pushNamed(context, '/setting/delete/done');
                  },
                  child: const Text('탈퇴하기',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ],
            ));
          } else {
            showDialog(context: context, builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('탈퇴 실패',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              ),
              content: const Text('비밀번호 입력 미일치로 인해\n탈퇴에 실패하셨습니다.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('다시 입력하기',
                  style: TextStyle(
                    color: Colors.black,
                  ),),
                ),
              ],
            ));
          }
        },
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
