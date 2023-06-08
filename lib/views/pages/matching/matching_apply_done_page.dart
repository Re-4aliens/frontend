import 'dart:convert';

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aliens/providers/auth_provider.dart';
import 'package:aliens/models/auth_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../models/screenArgument.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/button.dart';

class MatchingApplyDonePage extends StatefulWidget {
  const MatchingApplyDonePage({super.key});

  @override
  State<MatchingApplyDonePage> createState() => _MatchingApplyDonePageState();
}

class _MatchingApplyDonePageState extends State<MatchingApplyDonePage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          appBar: AppBar(),backgroundColor: Colors.transparent, infookay: false, infocontent: '', title: '',
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Expanded(
              child: Column(children: [
                Expanded(flex: 3, child: SizedBox()),
                Container(
                  child: SvgPicture.asset('assets/character/apply_done.svg'),
                  ),
                Expanded(flex: 1, child: SizedBox()),
              ]),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '매칭 신청 완료!',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 22 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height* 0.022,
                  ),
                  Text(
                    '아래 버튼을 클릭하면\n매칭 진행 상황을 알 수 있어요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff616161),
                      fontSize: isSmallScreen?14:16,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24,left: 24),
                      child: Positioned(
                        child: Container(
                          width: double.maxFinite,
                          height: isSmallScreen?44:48,
                          child: ElevatedButton(
                            onPressed: () async {
                              //스택 비우고
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/main', (Route<dynamic> route) => false,
                                  arguments: args);
                              //state페이지를 push
                              Navigator.pushNamed(context, '/state', arguments: args);
                            },
                            child: Text(
                              '매칭 진행 상황',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 16),
                                backgroundColor: Color(0xff7898FF),
                                // 여기 색 넣으면됩니다
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                elevation: 0.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25, left: 25),
                      child: Positioned(
                        child: Container(
                          width: double.maxFinite,
                          height: isSmallScreen?44:48,
                          child: ElevatedButton(
                            onPressed: () {
                              /*
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);

                               */

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/loading', (Route<dynamic> route) => false);
                            },
                            child: Text(
                              '홈으로 돌아가기',
                              style: TextStyle(
                                color: Color(0xffA7A7A7),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 16),
                                backgroundColor: Color(0xffEBEBEB),
                                // 여기 색 넣으면됩니다
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                elevation: 0.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
