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

  //storage에 작성할 모델
  final Auth auth = new Auth();
  final AuthProvider authProvider = new AuthProvider();
  static final storage = FlutterSecureStorage();

  Widget build(BuildContext context){
    dynamic member = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: 50,bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('비밀번호를 설정하시면\n가입이 완료됩니다',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            SizedBox(height: 40),
             Form(
               key: _formKey,
               child: TextFormField(
                     validator : (value) => value!.isEmpty? "비밀번호를 입력해주세요" : null,
                     controller: _PasswordController,
                     decoration: new InputDecoration(
                         hintText: '비밀번호 입력'
                     ),
                   ),
               ),
            Text('영문,특수기호, 숫자를 포함 10자 이상', style: TextStyle(fontSize: 12),),
            Expanded(child: SizedBox()),
            Button(
                child: Text('가입하기'),
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    member.password = _PasswordController.text;
                    print(member.toJson());

                    //------ 회원가입 api 요청
                    authProvider.signUp(member, context);

                    //------ 로그인 api 요청
                    auth.email = member.email;
                    auth.password = member.password;

                    //로그인 정보 저장
                    await storage.write(
                      key: 'auth',
                      value: jsonEncode(auth),
                    );

                    //http 요청
                    authProvider.login(auth, context);


                    Navigator.pushNamed(context,'/welcome', arguments: member);
                  }
                })

          ],
        ),
      ),
    );
  }
}