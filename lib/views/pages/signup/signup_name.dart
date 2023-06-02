import 'package:aliens/models/signup_model.dart';
import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../../models/signup_model.dart';
import '../../components/button.dart';

class SignUpName extends StatefulWidget{
  const SignUpName({super.key});

  @override
  State<SignUpName> createState() => _SignUpNameState();
}

class _SignUpNameState extends State<SignUpName>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  Widget build(BuildContext context){
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    SignUpModel member = new SignUpModel(
      email: '',
      password: '',
      mbti: '',
      gender: '',
      nationality: 0,
      birthday: '',
      name: '',
      profileImage: '',
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(appBar: AppBar(), title: '', backgroundColor: Colors.white, infookay: false, infocontent: '',),
      body: Padding(
        padding: EdgeInsets.only(right: 24,left: 24,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이름을 알려주세요',
              style: TextStyle(fontSize: isSmallScreen ?22:24, fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
             Form(
               key: _formKey,
               child: TextFormField(
                     validator : (value) => value!.isEmpty? "Please enter some text" : null,
                     controller: _nameController,
                     decoration: new InputDecoration(
                         hintText: '이름',
                       hintStyle: TextStyle(fontSize: isSmallScreen ?18:20, color: Color(0xffD9D9D9))
                     ),
                   ),
               ),
            Expanded(child: SizedBox()),
            Button(
                child: Text('다음'),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    member.name = _nameController.text;
                    print(member.toJson());
                    Navigator.pushNamed(context,'/birthday', arguments: member);
                  }
                })

          ],
        ),
      ),
    );
  }
}