import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import '../../components/button.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';

class SignUpPassword extends StatefulWidget{
  const SignUpPassword({super.key});

  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _PasswordController = TextEditingController();
  FocusNode _passwordFocus = new FocusNode();


  final AuthProvider authProvider = new AuthProvider();
  static final storage = FlutterSecureStorage();

  Widget build(BuildContext context){
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {}, backgroundColor: Colors.white,),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('비밀번호를 설정하시면\n가입이 완료됩니다',
              style: TextStyle(fontSize: isSmallScreen?22:24, fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
             Form(
               key: _formKey,
               child: TextFormField(
                 keyboardType: TextInputType.visiblePassword,
                 focusNode: _passwordFocus,
                     validator : (value) => CheckValidate().validatePassword(_passwordFocus, value!),
                     controller: _PasswordController,
                     decoration: new InputDecoration(
                         hintText: '비밀번호 입력',
                         hintStyle: TextStyle(fontSize: isSmallScreen?18:20, color: Color(0xffD9D9D9))
                     ),
                   ),
               ),
            Text('영문,특수기호, 숫자를 포함 10자 이상', style: TextStyle(fontSize: isSmallScreen?12:14, color: Color(0xffB8B8B8)),),
            Expanded(child: SizedBox()),
            Button(
                child: Text('가입하기'),
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    member.password = _PasswordController.text;
                    print(member.toJson());

                    //------ 회원가입 api 요청
                    authProvider.signUp(member, context);

                    //회원가입 성공하면 로그인 요청


                    Navigator.pushNamed(context,'/welcome', arguments: member);
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