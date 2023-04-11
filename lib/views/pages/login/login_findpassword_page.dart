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
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();

  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('가입하신 이메일\n 이름 정보를 입력해주세요.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            SizedBox(height: 10),
            Text('비밀번호를 찾기위해 작성하신 메일로\n임시비밀번호를 발급해드려요.', style: TextStyle(fontSize: 14),),
            SizedBox(height: 40),
            Form(
              key: _formKey,
              child: TextFormField(
                validator : (value) => value!.isEmpty? "Please enter some text" : null,
                controller: _NameController,
                decoration: new InputDecoration(
                    hintText: '이름',
                    hintStyle: TextStyle(
                        fontSize: 20,
                        color: Color(0xffD9D9D9)
                    )
                ),
              ),
            ),
            SizedBox(height: 10,),
            Form(
               key: _formKey,
               child: TextFormField(
                     validator : (value) => value!.isEmpty? "Please enter some text" : null,
                     controller: _EmailController,
                     decoration: new InputDecoration(
                         hintText: '이메일',
                       hintStyle: TextStyle(
                         fontSize: 20,
                         color: Color(0xffD9D9D9)
                       )
                     ),
                   ),
               ),
            Expanded(child: SizedBox()),
            Button(
                child: Text('임시 비밀번호 발급'),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    Navigator.pushNamed(context,'/login/checkemail', /*arguments: members*/);
                  }
                })

          ],
        ),
      ),
    );
  }
}
