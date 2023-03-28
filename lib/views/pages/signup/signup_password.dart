import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class SignUpPassword extends StatefulWidget{
  const SignUpPassword({super.key});

  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _PasswordController = TextEditingController();

  Widget build(BuildContext context){

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: 50,bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('비밀번호를 설정하시면\n가입이 완료됩니다',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            SizedBox(height: 40),
             Form(
               key: _formKey,
               child: TextFormField(
                     validator : (value) => value!.isEmpty? "비밀번호를 입력해주세요" : null,
                     controller: _PasswordController,
                     decoration: new InputDecoration(
                         hintText: '비밀번호 입력',
                         hintStyle: TextStyle(fontSize: 20, color: Color(0xffD9D9D9))
                     ),
                   ),
               ),
            Text('영문,특수기호, 숫자를 포함 10자 이상', style: TextStyle(fontSize: 14, color: Color(0xffB8B8B8)),),
            Expanded(child: SizedBox()),
            Button(
                child: Text('가입하기'),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    Navigator.pushNamed(context,'/welcome', /*arguments: members*/);
                  }
                })

          ],
        ),
      ),
    );
  }
}