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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordControllerSecond = TextEditingController();
  static final storage = FlutterSecureStorage();


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
              TextFormField(
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
              TextFormField(
                obscureText: true,
                obscuringCharacter: '*',
                key: _formKey,
                controller: _passwordControllerSecond,
                decoration: InputDecoration(
                  hintText: '${'setting-newpas3'.tr()}',
                  hintStyle: TextStyle(
                    fontSize: isSmallScreen?18:20,
                    color: Color(0xffb8b8b8),
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
                        isEnabled: true,
                        child: Text('${'setting-newpas4'.tr()}'),
                        onPressed: () async {


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
                            }})
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
