import 'package:aliens/models/screen_argument.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:transition/transition.dart';

import 'matching_list_page.dart';

class MatchingDonePage extends StatefulWidget {
  const MatchingDonePage({super.key});

  @override
  State<MatchingDonePage> createState() => _MatchingDonePageState();
}

class _MatchingDonePageState extends State<MatchingDonePage> {
  @override
  Widget build(BuildContext context) {
    final screenArguments =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: const Color(0xff212121),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(flex: 1, child: Container()),
              Text(
                'matched1'.tr(),
                style: TextStyle(
                  fontSize: isSmallScreen ? 22 : 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'matched2'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/character/matchingCharacters.svg',
                    height: isSmallScreen ? 190 : 260,
                    width: isSmallScreen ? 190 : 260,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    /*
                    setState(() {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        barrierColor: Colors.white,
                        backgroundColor: Colors.white,
                        builder: (context) {
                          return BottomBar(
                            partners: partners,
                          );
                        },
                      );
                    });

                     */
                    Navigator.push(
                      context,
                      Transition(
                          child: MatchingListPage(
                            screenArguments: screenArguments,
                          ),
                          transitionEffect: TransitionEffect.BOTTOM_TO_TOP),
                    );
                  },
                  onVerticalDragStart: (DragStartDetail) {
                    Navigator.push(
                      context,
                      Transition(
                          child: MatchingListPage(
                            screenArguments: screenArguments,
                          ),
                          transitionEffect: TransitionEffect.BOTTOM_TO_TOP),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Color(0xff7898FF),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'matched3'.tr(),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Icon(Icons.keyboard_arrow_down_outlined,
                              color: Colors.white),
                        ),
                        Expanded(flex: 4, child: Container()),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
