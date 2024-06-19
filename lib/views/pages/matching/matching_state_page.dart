import 'package:aliens/services/matching_service.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../components/button.dart';
import 'package:blobs/blobs.dart';

class MatchingStatePage extends StatefulWidget {
  const MatchingStatePage({super.key});

  @override
  State<MatchingStatePage> createState() => _MatchingStatePageState();
}

class _MatchingStatePageState extends State<MatchingStatePage> {
  DateTime nowDate = DateTime.now();

  late Duration diff;

  @override
  void initState() {
    super.initState();
    diff = const Duration(seconds: 0);
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
              color: const Color(0xff4D4D4D),
              width: 24,
              height: MediaQuery.of(context).size.height * 0.029,
            ),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/loading', (Route<dynamic> route) => false);
            },
          ),
        ),
        extendBodyBehindAppBar: true,
        body: FutureBuilder(
          future: MatchingService.matchingProfessData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              //받아오는 동안
              return Container(
                  alignment: Alignment.center,
                  child: const Image(
                      image: AssetImage("assets/illustration/loading_01.gif")));
            } else {
              DateTime matchingDate;
              matchingDate = snapshot.data == null
                  ? DateTime.now()
                  : DateTime.parse(snapshot.data!);
              if (matchingDate.difference(nowDate).inSeconds > 0) {
                diff = matchingDate.difference(nowDate);
              } else {
                diff = const Duration(seconds: 0);
              }

              return Padding(
                padding: const EdgeInsets.only(right: 24, left: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'matching-progress'.tr(),
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
                        builder: (BuildContext context, Duration value,
                            Widget? child) {
                          final days = value.inDays.toString().padLeft(2, '0');
                          final hours =
                              (value.inHours % 24).toString().padLeft(2, '0');
                          final minutes =
                              (value.inMinutes % 60).toString().padLeft(2, '0');
                          final seconds =
                              (value.inSeconds % 60).toString().padLeft(2, '0');

                          final remainingPeriod =
                              '$days:$hours:$minutes:$seconds';

                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF9F9FF),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 3),
                                          color: const Color(0xff4976FF)
                                              .withOpacity(0.12),
                                          blurRadius: 10,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Text(days,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: const Color(0xff7898FF),
                                            fontWeight: FontWeight.bold,
                                            fontSize: isSmallScreen ? 18 : 20)),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(':',
                                          style: TextStyle(
                                              color: const Color(0xff7898FF),
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  isSmallScreen ? 18 : 20))),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF9F9FF),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 3),
                                          color: const Color(0xff4976FF)
                                              .withOpacity(0.12),
                                          blurRadius: 10,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Text(hours,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: const Color(0xff7898FF),
                                            fontWeight: FontWeight.bold,
                                            fontSize: isSmallScreen ? 18 : 20)),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(':',
                                          style: TextStyle(
                                              color: const Color(0xff7898FF),
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  isSmallScreen ? 18 : 20))),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF9F9FF),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 3),
                                          color: const Color(0xff4976FF)
                                              .withOpacity(0.12),
                                          blurRadius: 10,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Text(minutes,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: const Color(0xff7898FF),
                                            fontWeight: FontWeight.bold,
                                            fontSize: isSmallScreen ? 18 : 20)),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(':',
                                          style: TextStyle(
                                              color: const Color(0xff7898FF),
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  isSmallScreen ? 18 : 20))),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF9F9FF),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 3),
                                          color: const Color(0xff4976FF)
                                              .withOpacity(0.12),
                                          blurRadius: 10,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Text(seconds,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: const Color(0xff7898FF),
                                            fontWeight: FontWeight.bold,
                                            fontSize: isSmallScreen ? 18 : 20)),
                                  ),
                                ],
                              ));
                        }),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    /*
                  Container(
                    width: MediaQuery.of(context).size.height * 0.16,
                      height: MediaQuery.of(context).size.height * 0.16,
                      child: Image(
                          image: AssetImage("assets/illustration/loading_03.gif"),
                      )),
*/
                    Blob.animatedRandom(
                      size: isSmallScreen ? 140 : 170,
                      edgesCount: 6,
                      //minGrowth:4,
                      duration: const Duration(milliseconds: 1000),
                      loop: true,
                      styles: BlobStyles(color: const Color(0xffFFB5B5)),
                    ),
                    /*
                  Positioned(
                    child: Blob.animatedRandom(
                      size: isSmallScreen ? 70 : 80,
                      edgesCount: 6,
                      //minGrowth:4,
                      duration: Duration(milliseconds: 1000),
                      loop: true,
                      styles: BlobStyles(color: Color(0xffD8E1FF)),
                    ),
                  ),

                   */
                    SizedBox(
                      height: 40.h,
                    ),
                    Text(
                      'matching-wait'.tr(),
                      style: TextStyle(
                        color: const Color(0xff616161),
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                    Button(
                      //수정
                      isEnabled: true,
                      child: Text('matching-mine'.tr()),
                      onPressed: () {
                        Navigator.pushNamed(context, '/info/my',
                            arguments: args);
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}
