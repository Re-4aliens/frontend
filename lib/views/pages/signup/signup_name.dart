import 'package:aliens/models/signup_model.dart';
import 'package:aliens/views/components/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  bool _isButtonEnabled = false;
  String constraintsText = "";


  Widget build(BuildContext context){
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    SignUpModel member = new SignUpModel(
      email: '',
      password: '',
      mbti: '',
      gender: '',
      nationality: '',
      birthday: '',
      name: '',
      profileImage: '',
      aboutMe: ''
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(appBar: AppBar(), title: '', backgroundColor: Colors.white, infookay: false, infocontent: '',),
      body: Padding(
        padding: EdgeInsets.only(right: 24,left: 24,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('signup-name'.tr(),
              style: TextStyle(fontSize: 24.spMin, fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
             Form(
               key: _formKey,
               child: TextFormField(
                 onChanged: (value) {
                   _CheckValidate(value);
                 },
                     //validator : (value) => value!.isEmpty? "Please enter some text" : null,
                     controller: _nameController,
                     decoration: new InputDecoration(
                         hintText: 'name'.tr(),
                       hintStyle: TextStyle(fontSize: isSmallScreen ?18:20, color: Color(0xffD9D9D9))
                     ),
                   ),
               ),
            Text(constraintsText),
            Expanded(child: SizedBox()),
            Button(
              isEnabled: _isButtonEnabled,
                child: Text('next'.tr(), style: TextStyle( color: _isButtonEnabled? Colors.white : Color(0xff888888))),
                onPressed: (){
                  if(_isButtonEnabled){
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
  void _CheckValidate(String value) {
    if (value.isEmpty) {
      setState(() {
        _isButtonEnabled = false;
        constraintsText = "";
      });
    } else {
      if(value.length < 2){
        setState(() {
          constraintsText = 'name-constraintsText2'.tr();
          _isButtonEnabled = false;
        });
      }else if(value.length > 10){
        setState(() {
          constraintsText = 'name-constraintsText3'.tr();
          _isButtonEnabled = false;
        });
      }else{
        String pattern = r"^[ㄱ-ㅎ가-힣0-9a-zA-Zぁ-ゔァ-ヴー々〆〤一-龥+]*$";
        RegExp regExp = new RegExp(pattern);
        if (!regExp.hasMatch(value)) {
          setState(() {
            constraintsText = 'name-constraintsText1'.tr();
            _isButtonEnabled = false;
          });
        } else {
          setState(() {
            constraintsText = "";
            _isButtonEnabled = true;
          });
        }
      }
    }
  }
}