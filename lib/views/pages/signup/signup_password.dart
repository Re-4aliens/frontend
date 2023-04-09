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
  FocusNode _passwordFocus = new FocusNode();

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
                 keyboardType: TextInputType.visiblePassword,
                 focusNode: _passwordFocus,
                     validator : (value) => CheckValidate().validatePassword(_passwordFocus, value!),
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

class CheckValidate {
  String? validatePassword(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '비밀번호를 입력하세요.';
    } else {
      String pattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{10,100}$';
      RegExp regExp = new RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '영문, 특수문자, 숫자를 포함 10자 이상';
      } else {
        return null;
      }
    }
  }
}