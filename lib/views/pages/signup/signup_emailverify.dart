import 'dart:io';

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/members.dart';
import '../../components/button.dart';
import 'package:image_picker/image_picker.dart';

class SignUpVerify extends StatefulWidget{
  const SignUpVerify({super.key});

  @override
  State<SignUpVerify> createState() => _SignUpVerifyState();
}

class _SignUpVerifyState extends State<SignUpVerify>{

  Widget build(BuildContext context){
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {}, backgroundColor: Colors.transparent,),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height:MediaQuery.of(context).size.height * 0.1),
              Container(
                child: SvgPicture.asset(
                  'assets/icon/icon_mail.svg',
                  width: MediaQuery.of(context).size.width * 0.22,
                  height: MediaQuery.of(context).size.height * 0.10,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              Text(
                '메일함을 확인해주세요!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.039, fontWeight: FontWeight.bold),
              ),
              Text(
                '\n메일로 인증링크를 보내드렸어요!\n인증 후 아래 버튼을 통해 가입을 계속 진행해주세요!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.0226,color: Color(0xff888888)),
              ),
              Expanded(child: SizedBox()),
              Text('*메일을 받지 못했다면 스팸함 또는 이메일 설정을 확인해주세요.\n',
                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.019, color: Color(0xff888888)),
              ),
              Button(
                child: Text('본인인증 완료'),
                onPressed: () {
                  Navigator.pushNamed(context, '/password', arguments: member);
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}