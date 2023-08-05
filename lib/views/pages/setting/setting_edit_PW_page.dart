import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../apis/apis.dart';
import '../../components/appbar.dart';
import '../../components/button.dart';
import 'package:http/http.dart' as http;

class SettingEditPWPage extends StatefulWidget {
  const SettingEditPWPage({super.key});

  @override
  State<SettingEditPWPage> createState() => _SettingEditPWPageState();
}




class _SettingEditPWPageState extends State<SettingEditPWPage> {
  final GlobalKey<FormState> _formKeyFirst = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySecond = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordControllerSecond = TextEditingController();
  static final storage = FlutterSecureStorage();
  FocusNode _passwordFocusfirst = new FocusNode();
  FocusNode _passwordFocussecond = new FocusNode();

  bool _isButtonEnabled = false;
  String constraintsText = '${'signup-pwd4'.tr()}';

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(appBar: AppBar(), title: '', backgroundColor: Colors.transparent, infookay: false, infocontent: '',),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                '${'setting-newpas1'.tr()}',
                style: TextStyle(fontSize: isSmallScreen?22:24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKeyFirst,
                child: TextFormField(
                  onChanged: (value) {
                    _CheckValidate(value);
                  },
                  keyboardType: TextInputType.visiblePassword,
                  focusNode: _passwordFocusfirst,
                  validator : (value) => CheckValidate().validatePassword(_passwordFocusfirst, value!),
                  obscureText: true,
                  obscuringCharacter: '*',
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: '${'setting-newpas2'.tr()}',
                    hintStyle: TextStyle(
                      fontSize: isSmallScreen?18:20,
                      color: Color(0xffb8b8b8),
                    ),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                      '${'signup-pwd4'.tr()}',
                    style: TextStyle(
                      fontSize: isSmallScreen?12:14,
                      color: Color(0xffB8B8B8),
                    ),
                  )),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKeySecond,
                child: TextFormField(
                  onChanged: (value){
                    _CheckValidate(value);
                  },
                  keyboardType: TextInputType.visiblePassword,
                  focusNode: _passwordFocussecond,
                  obscureText: true,
                  obscuringCharacter: '*',
                  controller: _passwordControllerSecond,
                  decoration: InputDecoration(
                    hintText: '${'setting-newpas3'.tr()}',
                    hintStyle: TextStyle(
                      fontSize: isSmallScreen?18:20,
                      color: Color(0xffb8b8b8),
                    ),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '${'signup-pwd4'.tr()}',
                    style: TextStyle(
                      fontSize: isSmallScreen?12:14,
                      color: Color(0xffb8b8b8),
                    ),
                  )),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 50),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Button(
                      //수정
                        isEnabled: _isButtonEnabled,
                        child: Text('${'setting-newpas4'.tr()}'),
                        onPressed: () async {
    if (_formKeyFirst.currentState?.validate() == true &&_formKeySecond.currentState?.validate() == true) {
                            //입력한 두 패스워드가 같으면
                            if (_passwordController.text == _passwordControllerSecond.text) {

                              //success
                              if (await APIs.changePassword(_passwordController.text)) {
                                Navigator.pushNamed(context,'/setting/edit/PW/done');
                                //fail
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CupertinoAlertDialog(
                                          title: Text(
                                            '${'setting-settingcancel'.tr()}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content:  Text(
                                              '${'setting-why'.tr()}'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text('${'confirm'.tr()}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  )),
                                            ),
                                          ],
                                        ));
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CupertinoAlertDialog(
                                        title: Text(
                                          '${'setting-newmis'.tr()}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Text('${'setting-confirm'.tr()}'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text('${'confirm'.tr()}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ));
                            }}})
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void _CheckValidate(String value) {
    if (value.isEmpty) {
      setState(() {
        _isButtonEnabled = false;
        constraintsText = "${'signup-pwd4'.tr()}";
      });
    } else {
      if (value.length > 9){
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
      String pattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{10,16}$';
      RegExp regExp = new RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '영문, 특수문자, 숫자를 포함 10자 이상, 16자 이하';
      } else {
        return null;
      }
    }
  }
}