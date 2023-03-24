import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class LoginChangeMail extends StatefulWidget{
  const LoginChangeMail({super.key});

  @override
  State<LoginChangeMail> createState() => _LoginChangeMailState();
}

class _LoginChangeMailState extends State<LoginChangeMail>{

  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: Padding(
        padding: const EdgeInsets.only(right: 20,left: 20, bottom: 50, top: 120),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.admin_panel_settings, size: 80,),
              SizedBox(height: 50),
              Text('비밀번호를 변경해주세요!',textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Text('현재 임시번호~~~~~\n~~~~해주세요', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),),
              Expanded(child: SizedBox()),
              Button(child: Text('비밀번호 변경하기'),
              onPressed: (){
              },),
              SizedBox(height: 10),
              Container(
                width : double.maxFinite,
                height: 50,
                child: ElevatedButton(
                  onPressed:(){
                  },
                  child: Text('다음에 변경하기', style: TextStyle(
                    color: Colors.black
                  ),),
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)
                  )
              ),
            ),
          )

            ],
          ),
        ),
      )
    );
  }
}