import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Animation animation;

  bool isStart = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 5), () {
      setState(() {
        isStart = true;
      });
    });

    //5초 후에 넘어가기
    Timer(const Duration(milliseconds: 5000), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff7898FF),
      body: Stack(
        children: <Widget>[
          AnimatedPositioned(
            duration: const Duration(milliseconds: 3000),
            curve: Curves.elasticInOut,
            left: isStart ? -30 : -200,
            top: isStart ? -70 : -200,
            child: Container(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/character/splash_eightstar.svg',
                width: 200,
                height: 200,
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 3000),
            curve: Curves.elasticInOut,
            right: isStart ? -60 : -120,
            top: 150,
            child: Container(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/character/splash_fivestar.svg',
                width: 120,
                height: 120,
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 3000),
            curve: Curves.elasticInOut,
            right: isStart ? -200 : -500,
            bottom: isStart ? -150 : -400,
            child: SvgPicture.asset(
              'assets/character/splash_hi.svg',
            ),
          ),

          //title
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/character/splash_logo.svg'),
                RichText(
                  text: EasyLocalization.of(context)!.locale ==
                          const Locale.fromSubtags(
                              languageCode: "ko", countryCode: "KR")
                      ? TextSpan(children: [
                          TextSpan(
                            text: 'title1'.tr(),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                          TextSpan(
                              text: 'title2'.tr(),
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ])
                      : TextSpan(children: [
                          TextSpan(
                              text: 'title1'.tr(),
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: 'title2'.tr(),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                        ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
