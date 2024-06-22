import 'package:aliens/views/components/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aliens/services/email_service.dart';
import '../../components/button.dart';

class SignUpVerify extends StatefulWidget {
  const SignUpVerify({super.key});

  @override
  State<SignUpVerify> createState() => _SignUpVerifyState();
}

class _SignUpVerifyState extends State<SignUpVerify> {
  @override
  Widget build(BuildContext context) {
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                Container(
                  child: SvgPicture.asset(
                    'assets/icon/icon_mail.svg',
                    width: MediaQuery.of(context).size.width * 0.22,
                    height: MediaQuery.of(context).size.height * 0.10,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Text(
                  'signup-email8'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: isSmallScreen ? 22 : 24,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '\n${'signup-email9'.tr()}\n${'signup-email10'.tr()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: const Color(0xff888888)),
                ),
                const Expanded(child: SizedBox()),
                Text(
                  '${'signup-email12'.tr()}\n${'signup-email13'.tr()}\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 12,
                      color: const Color(0xff888888)),
                ),
                Button(
                  isEnabled: true,
                  child: Text('done'.tr()),
                  onPressed: () async {
                    String status = await EmailService.getAuthenticationStatus(
                        member.email);
                    if (status == 'AUTHENTICATED') {
                      Navigator.pushNamed(context, '/password',
                          arguments: member);
                    } else if (status == 'EMAIL_SENT_NOT_AUTHENTICATED') {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: Text('signup-email8'.tr()),
                              content: Text(
                                  '${'signup-email9'.tr()}\n${'signup-email10'.tr()}'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('confirm'.tr(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      )),
                                ),
                              ],
                            );
                          });
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
