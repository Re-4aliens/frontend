import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aliens/services/auth_service.dart';
import '../../components/appbar.dart';
import '../../components/button.dart';

class SettingEditPWPage extends StatefulWidget {
  const SettingEditPWPage({super.key});

  @override
  State<SettingEditPWPage> createState() => _SettingEditPWPageState();
}

class _SettingEditPWPageState extends State<SettingEditPWPage> {
  final GlobalKey<FormState> _formKeyFirst = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySecond = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordControllerSecond =
      TextEditingController();
  static const storage = FlutterSecureStorage();
  final FocusNode _passwordFocusfirst = FocusNode();
  final FocusNode _passwordFocussecond = FocusNode();

  bool _isButtonEnabled = false;
  String constraintsText = 'signup-pwd4'.tr();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          appBar: AppBar(),
          title: '',
          backgroundColor: Colors.transparent,
          infookay: false,
          infocontent: '',
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: SizedBox()),
              Text(
                'setting-newpas1'.tr(),
                style: TextStyle(
                    fontSize: isSmallScreen ? 22 : 24,
                    fontWeight: FontWeight.bold),
              ),
              const Expanded(child: SizedBox()),
              Form(
                key: _formKeyFirst,
                child: TextFormField(
                  onChanged: (value) {
                    _CheckValidate(value);
                  },
                  keyboardType: TextInputType.visiblePassword,
                  focusNode: _passwordFocusfirst,
                  validator: (value) => CheckValidate()
                      .validatePassword(_passwordFocusfirst, value!),
                  obscureText: true,
                  obscuringCharacter: '*',
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'setting-newpas2'.tr(),
                    hintStyle: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      color: const Color(0xffb8b8b8),
                    ),
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'signup-pwd4'.tr(),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: const Color(0xffB8B8B8),
                    ),
                  )),
              const Expanded(child: SizedBox()),
              Form(
                key: _formKeySecond,
                child: TextFormField(
                  onChanged: (value) {
                    _CheckValidate(value);
                  },
                  keyboardType: TextInputType.visiblePassword,
                  focusNode: _passwordFocussecond,
                  obscureText: true,
                  obscuringCharacter: '*',
                  controller: _passwordControllerSecond,
                  decoration: InputDecoration(
                    hintText: 'setting-newpas3'.tr(),
                    hintStyle: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      color: const Color(0xffb8b8b8),
                    ),
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'signup-pwd4'.tr(),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: const Color(0xffb8b8b8),
                    ),
                  )),
              const Expanded(child: SizedBox()),
              Container(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Button(
                        //수정
                        isEnabled: _isButtonEnabled &&
                            _passwordController.text ==
                                _passwordControllerSecond.text,
                        child: Text('setting-newpas4'.tr()),
                        onPressed: () async {
                          if (_formKeyFirst.currentState?.validate() == true &&
                              _formKeySecond.currentState?.validate() == true) {
                            //입력한 두 패스워드가 같으면
                            if (_passwordController.text ==
                                _passwordControllerSecond.text) {
                              late bool success;
                              try {
                                success = await AuthService.changePassword(
                                    _passwordController.text);
                              } catch (e) {
                                if (e == "AT-C-002") {
                                  try {
                                    await AuthService.getAccessToken();
                                  } catch (e) {
                                    if (e == "AT-C-005") {
                                      //토큰 및 정보 삭제
                                      await storage.delete(key: 'auth');
                                      await storage.delete(key: 'token');
                                      print('로그아웃, 정보 지움');

                                      //스택 비우고 화면 이동
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil('/',
                                              (Route<dynamic> route) => false);
                                    } else if (e == "AT-C-007") {
                                      //토큰 및 정보 삭제
                                      await AuthService.logOut(context);
                                    } else {
                                      success =
                                          await AuthService.changePassword(
                                              _passwordController.text);
                                    }
                                  }
                                } else if (e == "AT-C-007") {
                                  //토큰 및 정보 삭제
                                  await AuthService.logOut(context);
                                } else {
                                  success = await AuthService.changePassword(
                                      _passwordController.text);
                                }
                              }
                              //success
                              if (success) {
                                Navigator.pushNamed(
                                    context, '/setting/edit/PW/done');
                                //fail
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CupertinoAlertDialog(
                                          title: Text(
                                            'setting-settingcancel'.tr(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Text('setting-why'.tr()),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text('confirm'.tr(),
                                                  style: const TextStyle(
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
                                          'setting-newmis'.tr(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Text('setting-confirm'.tr()),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text('confirm'.tr(),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ));
                            }
                          }
                        })),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ));
  }

  void _CheckValidate(String value) {
    if (value.isEmpty) {
      setState(() {
        _isButtonEnabled = false;
        constraintsText = 'signup-pwd4'.tr();
      });
    } else {
      if (value.length > 9) {
        setState(() {
          constraintsText = "";
          _isButtonEnabled = true;
        });
      } else {
        setState(() {
          constraintsText = 'signup-pwd4'.tr();
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
      String pattern =
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{10,16}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '영문, 특수문자, 숫자를 포함 10자 이상, 16자 이하';
      } else {
        return null;
      }
    }
  }
}
