import 'dart:convert';


import '../../../apis/apis.dart';
import 'package:aliens/models/applicant_model.dart';
import 'package:aliens/models/memberDetails_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/appbar.dart';
import '../../components/button.dart';

class SettingDeletePage extends StatefulWidget {
  const SettingDeletePage({super.key});

  @override
  State<SettingDeletePage> createState() => _SettingDeletePageState();
}

class _SettingDeletePageState extends State<SettingDeletePage> {
  final TextEditingController passwordController = new  TextEditingController();
  static final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    var memberDetails = ModalRoute.of(context)!.settings.arguments as MemberDetails;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(appBar: AppBar(),backgroundColor: Colors.transparent, infookay: false, infocontent: '',title: '${'setting-memwithdrawal'.tr()}',),
        body: Container(
          padding: EdgeInsets.only(right: 24,left: 24,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${'setting-withdrawal'.tr()}',
                style: TextStyle(
                    fontSize: isSmallScreen?22:24,
                    fontWeight: FontWeight.bold
                ),),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('${'setting-putpas'.tr()}',

                    style: TextStyle(
                      fontSize: isSmallScreen?12:14,
                      color: Color(0xffb8b8b8),
                    ),)),
              SizedBox(
                height: 20,
              ),
              _passwordCheck(memberDetails),
              Expanded(child: SizedBox()),
              Button(
                //수정
                  isEnabled: true,
                  child: Text('${'setting-withdrawal'.tr()}'),
                  onPressed: () async {
                    var userInfo = await storage.read(key: 'auth');

                    if (passwordController.text ==
                        json.decode(userInfo!)['password']) {
                      showDialog(
                          context: context, builder: (BuildContext context) =>
                          CupertinoAlertDialog(
                            title: Text('${'setting-real'.tr()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,),),
                            content:Text(
                                '${'setting-delete5'.tr()}'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('${'cancel'.tr()}',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                              TextButton(
                                onPressed: () async {
                                  //탈퇴
                                  if (await APIs.withdraw(
                                      passwordController.text)){
                                    await APIs.deleteInfo(memberDetails.memberId);
                                    Navigator.pushNamed(context, '/setting/delete/done');
                                  }
                                },
                                child: Text('${'setting-withdrawal'.tr()}',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                            ],
                          ));
                    } else {
                      showDialog(
                          context: context, builder: (BuildContext context) =>
                          CupertinoAlertDialog(
                            title: Text('${'setting-fail'.tr()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                                '${'setting-delete5'.tr()}'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('${'cancel'.tr()}',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child:  Text('${'again'.tr()}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),),
                              ),
                            ],
                          ));
                    }
                  })
            ],
          ),
        )
    );
  }
  Widget _passwordCheck(memberDetails){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: passwordController,
        obscureText: true,
        obscuringCharacter: '*',
        onEditingComplete: (){
          FocusScope.of(context).unfocus();
          //auth에서 불러오기
          if(passwordController.text == memberDetails.member.password) {
            showDialog(context: context, builder: (BuildContext context) =>
                CupertinoAlertDialog(
                  title: Text('${'setting-real'.tr()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,),),
                  content: Text('${'setting-delete5'.tr()}'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('${'cancel'.tr()}',
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ),
                    TextButton(
                      onPressed: () async{
                    //탈퇴
                        if(await APIs.withdraw(passwordController.text)){
                          await APIs.deleteInfo(memberDetails.memberId);
                          Navigator.pushNamed(context, '/setting/delete/done');
                        }
                        },
                      child: Text('${'setting-withdrawal'.tr()}',
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ),
              ],
            ));
          } else {
            showDialog(context: context, builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('${'setting-fail'.tr()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              ),
              content: Text('${'setting-failwhy'.tr()}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('${'cancel'.tr()}',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('${'again'.tr()}',
                  style: TextStyle(
                    color: Colors.black,
                  ),),
                ),
              ],
            ));
          }
        },
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
