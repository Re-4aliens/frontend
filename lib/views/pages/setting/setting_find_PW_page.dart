import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../components/appbar.dart';
import '../../components/button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingFindPWPage extends StatefulWidget {
  const SettingFindPWPage({super.key});

  @override
  State<SettingFindPWPage> createState() => _SettingFindPWPageState();
}

class _SettingFindPWPageState extends State<SettingFindPWPage> {
  static final storage = FlutterSecureStorage();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    var memberDetails = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(appBar: AppBar(), title: '',backgroundColor: Colors.transparent, infookay: false, infocontent: '',),

        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Text('${'setting-findpas'.tr()}',
                style: TextStyle(
                    fontSize: isSmallScreen?22:24,
                    fontWeight: FontWeight.bold
                ),),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                obscuringCharacter: '*',
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: '${'setting-enterpass'.tr()}',
                  hintStyle: TextStyle(
                    fontSize: isSmallScreen?18:20,
                    color: Color(0xffD9D9D9),
                  ),

                ),
              ),
             
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 50),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Button(
                      //수정
                        isEnabled: true,
                        child: Text('${'setting-authen'.tr()}'),
                        onPressed: () async {
                          //if 지금 비밀번호랑 입력한 거랑 같으면
                          var userInfo = await storage.read(key: 'auth');
                          if (_passwordController.text ==
                              json.decode(userInfo!)['password'])
                            Navigator.pushNamed(context, '/setting/edit/PW',
                                arguments: _passwordController.text);
                          else
                            showDialog(context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(

                                      title: Text('${'setting-wrongpass'.tr()}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text('${'setting-confirmpass'.tr()}'),
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
                        ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
