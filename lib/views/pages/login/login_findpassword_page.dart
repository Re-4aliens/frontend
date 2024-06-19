import 'package:aliens/views/components/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:aliens/services/auth_service.dart';
import '../../components/button.dart';

class LoginFindPassword extends StatefulWidget {
  const LoginFindPassword({super.key});

  @override
  State<LoginFindPassword> createState() => _LoginFindPasswordState();
}

class _LoginFindPasswordState extends State<LoginFindPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth <= 600;
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        backgroundColor: Colors.transparent,
        infookay: false,
        infocontent: '',
      ),
      body: Padding(
        padding: EdgeInsets.only(
            right: 24,
            left: 24,
            top: MediaQuery.of(context).size.height * 0.06,
            bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'find-pwd1'.tr()}\n${'find-pwd2'.tr()}',
              style: TextStyle(
                  fontSize: isSmallScreen ? 22 : 24,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.0166,
            ),
            Text(
              '${'find-pwd3'.tr()}\n${'find-pwd4'.tr()}',
              style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: const Color(0xff888888)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? "Please enter some text" : null,
                    controller: _NameController,
                    decoration: InputDecoration(
                        hintText: 'name'.tr(),
                        hintStyle: TextStyle(
                            fontSize: isSmallScreen ? 18 : 20,
                            color: const Color(0xffD9D9D9))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? "Please enter some text" : null,
                    controller: _EmailController,
                    decoration: InputDecoration(
                        hintText: 'email'.tr(),
                        hintStyle: TextStyle(
                            fontSize: isSmallScreen ? 18 : 20,
                            color: const Color(0xffD9D9D9))),
                  )
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            Button(
                //수정
                isEnabled: true,
                child: Text('confirm'.tr()),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var email = _EmailController.text;
                    var name = _NameController.text;
                    //임시 비밀번호 발급 요청
                    showDialog(
                        context: context,
                        builder: (_) => FutureBuilder(
                            future: AuthService.temporaryPassword(email, name),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  snapshot.data == null) {
                                //받아오는 동안
                                return Container(
                                    child: const Image(
                                        image: AssetImage(
                                            "assets/illustration/loading_01.gif")));
                              } else {
                                if (snapshot.data == "M003") {
                                  //받아온 후
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.popAndPushNamed(
                                        context, '/login/checkemail');
                                  });
                                  return Container(
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/illustration/loading_01.gif")));
                                } else {
                                  return CupertinoAlertDialog(
                                    title: Text(
                                      'findpassword4'.tr(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text('findpassword3'.tr()),
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
                                  );
                                }
                              }
                            }));
                  }
                })
          ],
        ),
      ),
    );
  }
}
