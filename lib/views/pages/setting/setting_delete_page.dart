import 'package:aliens/services/auth_service.dart';
import 'package:aliens/models/member_details_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/appbar.dart';
import '../../components/button.dart';

import 'dart:convert';

class SettingDeletePage extends StatefulWidget {
  const SettingDeletePage({super.key});

  @override
  State<SettingDeletePage> createState() => _SettingDeletePageState();
}

class _SettingDeletePageState extends State<SettingDeletePage> {
  final TextEditingController passwordController = TextEditingController();
  static const storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    var memberDetails =
        ModalRoute.of(context)!.settings.arguments as MemberDetails;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appBar: AppBar(),
        backgroundColor: Colors.transparent,
        infookay: false,
        infocontent: '',
        title: 'setting-memwithdrawal'.tr(),
      ),
      body: Container(
        padding: EdgeInsets.only(
          right: 24,
          left: 24,
          top: MediaQuery.of(context).size.height * 0.06,
          bottom: MediaQuery.of(context).size.height * 0.06,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'setting-withdrawal'.tr(),
              style: TextStyle(
                fontSize: isSmallScreen ? 22 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'setting-putpas'.tr(),
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: const Color(0xffb8b8b8),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _passwordCheck(memberDetails),
            const Expanded(child: SizedBox()),
            Button(
              //수정
              isEnabled: true,
              child: Text('setting-withdrawal'.tr()),
              onPressed: () async {
                Map<String, String> allValues = await storage.readAll();
                allValues.forEach((key, value) {
                  print('$key: $value');
                });

                var userInfo = await storage.read(key: 'auth');

                if (userInfo != null && userInfo.isNotEmpty) {
                  var decodedUserInfo = json.decode(userInfo);

                  if (passwordController.text.isNotEmpty) {
                    if (decodedUserInfo['password'] ==
                        passwordController.text) {
                      _showConfirmationDialog(context);
                    } else {
                      _showErrorDialog(
                          context, 'setting-fail'.tr(), 'setting-failwhy'.tr());
                    }
                  } else {
                    _showErrorDialog(
                        context, 'setting-fail'.tr(), 'setting-failwhy'.tr());
                  }
                } else {
                  _showErrorDialog(
                      context, 'setting-fail'.tr(), 'setting-failwhy'.tr());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 0,
          backgroundColor: const Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    'assets/character/withdraw.svg',
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ),
                Text(
                  'setting-real'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    'setting-delete5'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff888888),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (await AuthService.withdraw(passwordController.text)) {
                      Navigator.pushNamed(context, '/setting/delete/done');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color(0xff7898FF),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'setting-okay'.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'setting-cancel'.tr(),
                    style: const TextStyle(color: Color(0xffc1c1c1)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            content,
            style: const TextStyle(
              color: Color(0xff888888),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr(),
                  style: const TextStyle(
                    color: Color(0xff7898FF),
                  )),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'again'.tr(),
                style: const TextStyle(
                  color: Color(0xff7898FF),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _passwordCheck(memberDetails) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: passwordController,
        obscureText: true,
        obscuringCharacter: '*',
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
