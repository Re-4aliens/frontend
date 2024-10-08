import 'package:aliens/models/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aliens/services/api_service.dart';
import 'package:aliens/services/token_validation_service.dart';
import 'package:aliens/views/components/button_big.dart';
import 'package:aliens/services/auth_service.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final TokenValidationService _authService = TokenValidationService();
  String selectedValue = 'English';

  Auth auth = Auth();

  @override
  void initState() {
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    String? email = await APIService.storage.read(key: 'email');
    String? password = await APIService.storage.read(key: 'password');

    if (email != null && password != null) {
      auth.email = email;
      auth.password = password;
      var loginSuccess = await AuthService.logIn(auth);

      if (loginSuccess) {
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/loading', (Route<dynamic> route) => false);
        }
      }
    }
  }

  Future<void> _checkTokenAndNavigate() async {
    bool isValid = await _authService.checkTokenValidity();
    if (mounted) {
      if (isValid) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/loading', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      body: Center(
        child: Column(
          children: <Widget>[
            const Expanded(
              flex: 6,
              child: SizedBox(),
            ),
            Expanded(
              flex: 5,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: SvgPicture.asset(
                          'assets/character/logoimage.svg',
                        )),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: SvgPicture.asset(
                        'assets/character/logotext.svg',
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Text(
                        '${'title1'.tr()}${'title2'.tr()}',
                        style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            color: const Color(0xff414141)),
                      ),
                    ),
                    DropdownButton<String>(
                      underline: const SizedBox(),
                      value: selectedValue,
                      items: <String>['English', '한국어']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: const Color(0xff616161)),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                          switch (selectedValue) {
                            case '한국어':
                              EasyLocalization.of(context)!
                                  .setLocale(const Locale('ko', 'KR'));
                              break;
                            case 'English':
                              EasyLocalization.of(context)!
                                  .setLocale(const Locale('en', 'US'));
                              break;
                          }
                        });
                      },
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SvgPicture.asset(
                          'assets/icon/icon_dropdown.svg',
                          height: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Column(
                      children: [
                        BigButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/name');
                            },
                            child: Text(
                              'start'.tr(),
                              style:
                                  TextStyle(fontSize: isSmallScreen ? 14 : 16),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'login2'.tr(),
                              style:
                                  TextStyle(fontSize: isSmallScreen ? 12 : 14),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                'login1'.tr(),
                                style: TextStyle(
                                  color: const Color(0xff000000),
                                  fontSize: isSmallScreen ? 12 : 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
