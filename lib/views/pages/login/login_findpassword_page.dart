import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class LoginFindPassword extends StatefulWidget{
  const LoginFindPassword({super.key});

  @override
  State<LoginFindPassword> createState() => _LoginFindPasswordState();
}

class _LoginFindPasswordState extends State<LoginFindPassword>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _EmailController = TextEditingController();

  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: 50,bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('비밀번호를 찾기 위해\n가입하신 이메일을 입력해주세요.',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            SizedBox(height: 10),
            Text('작성하신 메일로 임시비밀번호를 발급해드려요.'),
            SizedBox(height: 40),
             Form(
               key: _formKey,
               child: TextFormField(
                     validator : (value) => value!.isEmpty? "Please enter some text" : null,
                     controller: _EmailController,
                     decoration: new InputDecoration(
                         hintText: '이메일'
                     ),
                   ),
               ),
            Expanded(child: SizedBox()),
            Button(
                child: Text('임비 비밀번호 발급'),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    Navigator.pushNamed(context,'/checkemail', /*arguments: members*/);
                  }
                })

          ],
        ),
      ),
    );
  }
}