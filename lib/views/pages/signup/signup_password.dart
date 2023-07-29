import 'dart:convert';

import 'package:aliens/apis.dart';
import 'package:aliens/views/components/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
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

  bool _isButtonEnabled = false;
  String constraintsText = '${'signup-pwd4'.tr()}';


  //final AuthProvider authProvider = new AuthProvider();
  static final storage = FlutterSecureStorage();

  Widget build(BuildContext context){
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(appBar: AppBar(), title: '', backgroundColor: Colors.white, infookay: false, infocontent: '',),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'signup-pwd1'.tr()}\n${'signup-pwd2'.tr()}',
              style: TextStyle(fontSize: isSmallScreen?22:24, fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
             Form(
               key: _formKey,
               child: TextFormField(

                 onChanged: (value) {
                   _CheckValidate(value);
                 },
                 keyboardType: TextInputType.visiblePassword,
                 focusNode: _passwordFocus,
                     //validator : (value) => CheckValidate().validatePassword(_passwordFocus, value!),
                     controller: _PasswordController,
                     decoration: new InputDecoration(
                         hintText: '${'signup-pwd3'.tr()}',
                         hintStyle: TextStyle(fontSize: isSmallScreen?18:20, color: Color(0xffD9D9D9))
                     ),
                   ),
               ),
            Text(constraintsText, style: TextStyle(fontSize: isSmallScreen?12:14, color: Color(0xffB8B8B8)),),
            Expanded(child: SizedBox()),
            Button(
              //수정
                isEnabled: _isButtonEnabled,
                child: Text('${'signup-pwd5'.tr()}', style: TextStyle( color: _isButtonEnabled? Colors.white : Color(0xff888888)),),
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    member.password = _PasswordController.text;
                    print(member.toJson());

                    //------ 회원가입 api 요청
                    //authProvider.signUp(member, context);
                    if(await APIs.signUp(member))
                      Navigator.pushNamed(context,'/welcome', arguments: member);
                    else
                      print('회원가입실패');}
                    //회원가입 성공하면 로그인 요청

                })

          ],
        ),
      ),
    );
  }
  void _CheckValidate(String value) {
    if (value.isEmpty) {
      setState(() {
        _isButtonEnabled = false;
        constraintsText = "${'signup-pwd4'.tr()}";
      });
    } else {
      if (value.length > 10){
        setState(() {
          constraintsText = "";
          _isButtonEnabled = true;
        });
      }
      else {
        setState(() {
          constraintsText = "${'signup-pwd4'.tr()}";
          _isButtonEnabled = false;
        });
      }
    }
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