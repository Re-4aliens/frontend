import 'dart:convert';
import 'package:aliens/apis/apis.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/views/pages/matching/matching_edit_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../components/appbar.dart';
import '../../components/button.dart';
import 'package:http/http.dart';
import 'package:flutter/animation.dart';
import 'package:http/http.dart' as http;
import 'package:blobs/blobs.dart';

class MatchingStatePage extends StatefulWidget {
  const MatchingStatePage({super.key});

  @override
  State<MatchingStatePage> createState() => _MatchingStatePageState();
}

class _MatchingStatePageState extends State<MatchingStatePage> {

  DateTime matchingDate = DateTime.now();
  DateTime nowDate = DateTime.now();

  late Duration diff;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      super.initState();
      diff = Duration(seconds: 0);
      fetchMatchingDate();
    });
  }


  Future<void> fetchMatchingDate() async {
    final url = Uri.parse('http://3.34.2.246:8079/api/v1/applicant/completion-date');

    final response = await http.post(
      url,
      body: {'matchingCompletionDate': 'YYYY-MM-DD HH:MM'},
    );

    if (response.statusCode == 200) {
      final matchingCompletionDate = response.body;

      // DateTime으로 변환
      final matchingDateResponse = DateTime.parse(matchingCompletionDate);

      setState(() {
        matchingDate = matchingDateResponse;
        if (matchingDate.difference(nowDate).inSeconds > 0)
          diff = matchingDate.difference(nowDate);
        else
          diff = Duration(seconds: 0);
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: SvgPicture.asset(
                'assets/icon/icon_back.svg',
                color: Color(0xff4D4D4D),
                width: 24,
                height: MediaQuery.of(context).size.height * 0.029,),
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/loading', (Route<dynamic> route) => false);
              },
            ),
            ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right:24,left:24),
              child: Column(
                children: [
                  Expanded(flex: 3, child: SizedBox()),
                  Text(
                    '${'matching-progress'.tr()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 22 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: double.infinity,
                  ),
                  TweenAnimationBuilder<Duration>(
                      duration: Duration(seconds: diff.inSeconds),
                      tween: Tween(
                          begin: Duration(seconds: diff.inSeconds),
                          end: Duration.zero),
                      onEnd: () {
                        print('Timer ended');
                      },
                      builder:
                          (BuildContext context, Duration value, Widget? child) {
                        final days = value.inDays.toString().padLeft(2, '0');
                        final hours = (value.inHours % 24).toString().padLeft(2, '0');
                        final minutes = (value.inMinutes % 60).toString().padLeft(2, '0');
                        final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');

                        final remainingPeriod = '$days:$hours:$minutes:$seconds';

                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffF9F9FF),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 3),
                                        color: Color(0xff4976FF).withOpacity(0.12),
                                        blurRadius: 10,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('$days',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xff7898FF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: isSmallScreen?18:20)
                                  ),
                                  padding: EdgeInsets.all(8),
                                ),
                                Padding(padding: EdgeInsets.all(10), child: Text(':',
                                    style: TextStyle(
                                        color: Color(0xff7898FF),
                                        fontWeight: FontWeight.bold,
                                        fontSize: isSmallScreen?18:20))),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffF9F9FF),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 3),
                                        color: Color(0xff4976FF).withOpacity(0.12),
                                        blurRadius: 10,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('$hours',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xff7898FF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: isSmallScreen?18:20)
                                  ),
                                  padding: EdgeInsets.all(8),
                                ),
                                Padding(padding: EdgeInsets.all(10), child: Text(':',
                                    style: TextStyle(
                                        color: Color(0xff7898FF),
                                        fontWeight: FontWeight.bold,
                                        fontSize: isSmallScreen?18:20))),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffF9F9FF),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 3),
                                        color: Color(0xff4976FF).withOpacity(0.12),
                                        blurRadius: 10,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('$minutes',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xff7898FF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: isSmallScreen?18:20)
                                  ),
                                  padding: EdgeInsets.all(8),
                                ),
                                Padding(padding: EdgeInsets.all(10), child: Text(':',
                                    style: TextStyle(
                                        color: Color(0xff7898FF),
                                        fontWeight: FontWeight.bold,
                                        fontSize: isSmallScreen?18:20))),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffF9F9FF),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 3),
                                        color: Color(0xff4976FF).withOpacity(0.12),
                                        blurRadius: 10,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('$seconds',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xff7898FF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: isSmallScreen?18:20)
                                  ),
                                  padding: EdgeInsets.all(8),
                                ),
                              ],
                            ));
                      }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.height * 0.16,
                      height: MediaQuery.of(context).size.height * 0.16,
                      child: Image(
                          image: AssetImage("assets/illustration/loading_03.gif"),
                      )),

                  Stack(
                    children: [

                      Blob.animatedRandom(
                        size: isSmallScreen ? 140 : 170,
                        edgesCount: 6,
                        //minGrowth:4,
                        duration: Duration(milliseconds: 1000),
                        loop: true,
                        styles: BlobStyles(color: Color(0xffFFB5B5)),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Blob.animatedRandom(
                          size: isSmallScreen ? 70 : 80,
                          edgesCount: 6,
                          //minGrowth:4,
                          duration: Duration(milliseconds: 1000),
                          loop: true,
                          styles: BlobStyles(color: Color(0xffD8E1FF)),
                        ),
                      ),
                    ],
                  ),


                  SizedBox(
                    height: isSmallScreen?15:40,
                  ),
                  Text(
                    '${'matching-wait'.tr()}',
                    style: TextStyle(
                      color: Color(0xff616161),
                      fontSize: isSmallScreen?14:16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(flex: 3, child: SizedBox()),
                ],
              ),
            ),
            Column(
              children: [
                Expanded(flex: isSmallScreen ? 6 : 5, child: Container()),
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24, left: 24),
                        child: Positioned(
                          child: Button(
                            //수정
                            isEnabled: true,
                            child: Text('${'matching-mine'.tr()}'),
                            onPressed: () {
                              Navigator.pushNamed(context, '/info/my',
                                  arguments: args);
                            },
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ));
  }
}
