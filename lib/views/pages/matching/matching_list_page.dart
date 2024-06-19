import 'package:aliens/models/countries.dart';
import 'package:aliens/models/partner_model.dart';
import 'package:dash_flags/dash_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

import '../../../models/screen_argument.dart';
import '../chatting/chatting_page.dart';

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height + 20, size.width, size.height - 100);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MatchingListPage extends StatefulWidget {
  final ScreenArguments screenArguments;

  const MatchingListPage({super.key, required this.screenArguments});

  @override
  State<MatchingListPage> createState() => _MatchingListPageState();
}

class _MatchingListPageState extends State<MatchingListPage> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff7898ff),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icon/icon_back.svg',
            height: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              height: MediaQuery.of(context).size.height * 3 / 5,
              decoration: const BoxDecoration(
                color: Color(0xff7898ff),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'matched4'.tr(),
                  style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'matched5'.tr(namedArgs: {
                    'num': '${widget.screenArguments.partners!.length}'
                  }),
                  style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18, color: Colors.white),
                ),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0;
                      i < widget.screenArguments.partners!.length;
                      i++)
                    MatchingList(
                      partner: widget.screenArguments.partners![i],
                      onPressed: () {
                        setState(() {
                          selectedIndex = i;
                        });
                      },
                      isClicked: selectedIndex == i,
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedIndex != -1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChattingPage(
                                      applicant:
                                          widget.screenArguments.applicant,
                                      partner: widget.screenArguments
                                          .partners![selectedIndex],
                                      memberDetails:
                                          widget.screenArguments.memberDetails!,
                                    )),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: selectedIndex == -1
                              ? const Color(0xffEBEBEB)
                              : const Color(0xff7898FF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40))),
                      child: Text(
                        'matched6'.tr(),
                        style: TextStyle(
                          color: selectedIndex == -1
                              ? const Color(0xff888888)
                              : Colors.white,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(
                flex: isSmallScreen ? 6 : 8,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MatchingList extends StatefulWidget {
  final Partner partner;
  final VoidCallback onPressed;
  final bool isClicked;

  const MatchingList(
      {super.key,
      required this.partner,
      required this.onPressed,
      required this.isClicked});

  @override
  State<MatchingList> createState() => _MatchingListState();
}

class _MatchingListState extends State<MatchingList> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    var flagSrc = '';
    for (Map<String, String> country in countries) {
      if (country['name'] == widget.partner.nationality.toString()) {
        flagSrc = country['code']!;
        break;
      }
    }

    return widget.partner.mbti != null
        ? Container(
            margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 4)),
              ],
              gradient: widget.isClicked
                  ? const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [0.45, 0.55],
                      transform: GradientRotation(math.pi / 2),
                      colors: [
                        Color(0xff95AEFF),
                        Color(0xff4976ff),
                      ])
                  : const LinearGradient(colors: [Colors.white, Colors.white]),
            ),
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: isSmallScreen ? 70 : 80,
                  width: isSmallScreen ? 300 : 350,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        //내부 그림자
                        BoxShadow(
                          color: widget.isClicked
                              ? Colors.transparent
                              : const Color(0xff7898FF).withOpacity(0.3),
                        ),

                        //버튼색

                        widget.isClicked
                            ? const BoxShadow(
                                color: Color(0xff7898ff),
                                spreadRadius: -5.0,
                                blurRadius: 10,
                              )
                            : const BoxShadow(
                                blurRadius: 10,
                                color: Colors.white,
                                offset: Offset(-5, -5),
                              )
                      ]),
                  padding: const EdgeInsets.only(left: 20, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          print(widget.partner.profileImage);
                          /*
                      Navigator.pushNamed(context, '/info/your',
                          arguments: widget.partner);

                       */
                          showDialog(
                              context: context,
                              builder: (_) => Center(
                                    child: SizedBox(
                                      width: 340,
                                      height: 275,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            bottom: 0,
                                            child: Container(
                                              width: 340,
                                              height: 225,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const SizedBox(
                                                    height: 50,
                                                  ),
                                                  Text(
                                                    '${widget.partner.name}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: isSmallScreen
                                                          ? 30
                                                          : 36,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Text(
                                                      '${widget.partner.selfIntroduction}',
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xff888888),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffF1F1F1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5,
                                                            bottom: 5,
                                                            left: 15,
                                                            right: 20),
                                                    child: Stack(
                                                      children: [
                                                        Text(
                                                          '       ${widget.partner.nationality}, ${widget.partner.mbti}',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  isSmallScreen
                                                                      ? 14
                                                                      : 16,
                                                              color: const Color(
                                                                  0xff616161)),
                                                        ),
                                                        Positioned(
                                                          left: 0,
                                                          top: 0,
                                                          bottom: 0,
                                                          child: Center(
                                                            child: SizedBox(
                                                              width: 21,
                                                              height: 14,
                                                              child:
                                                                  CountryFlag(
                                                                country: Country
                                                                    .fromCode(
                                                                        flagSrc),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 30,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 340,
                                            height: 105,
                                            child: Stack(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: widget.partner
                                                              .profileImage ==
                                                          ""
                                                      ? Container(
                                                          width: 100,
                                                          height: 100,
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.white,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/icon/icon_profile.svg',
                                                            color: const Color(
                                                                0xffEBEBEB),
                                                          ),
                                                        )
                                                      : Container(
                                                          width: 100,
                                                          height: 100,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white,
                                                              image: DecorationImage(
                                                                  image: NetworkImage(widget
                                                                      .partner
                                                                      .profileImage!))),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                        ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffebebeb),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Icon(
                                                      widget.partner.gender ==
                                                              'MALE'
                                                          ? Icons.male_rounded
                                                          : Icons
                                                              .female_rounded,
                                                      size: 15,
                                                      color: const Color(
                                                          0xff7898ff),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                        },
                        child: widget.partner.profileImage == null
                            ? SvgPicture.asset(
                                'assets/icon/icon_profile.svg',
                                width: 50,
                                color: const Color(0xffEBEBEB),
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            widget.partner.profileImage!))),
                                padding: const EdgeInsets.all(5),
                              ),
                      ),
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${widget.partner.name}',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 16 : 20,
                                    fontWeight: FontWeight.bold,
                                    color: widget.isClicked
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 18,
                                  width: 18,
                                  decoration: BoxDecoration(
                                    color: widget.partner.gender == 'MALE'
                                        ? const Color(0xffFFB5B5)
                                        : const Color(0xffFFF3C7),
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: widget.partner.gender == 'MALE'
                                      ? const Icon(
                                          Icons.male_rounded,
                                          size: 15,
                                          color: Colors.white,
                                        )
                                      : const Icon(
                                          Icons.female_rounded,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                )
                              ],
                            ),
                            Text(
                              '${widget.partner.mbti}',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                color: widget.isClicked
                                    ? Colors.white
                                    : const Color(0xffA4A4A4),
                              ),
                            ),
                          ],
                        ),
                      )),
                      Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            offset: const Offset(2, 3),
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.2),
                          )
                        ]),
                        child: CountryFlag(
                          country: Country.fromCode(flagSrc),
                          height: 30,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 4)),
              ],
              gradient:
                  const LinearGradient(colors: [Colors.white, Colors.white]),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: isSmallScreen ? 70 : 80,
                width: isSmallScreen ? 300 : 350,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      //내부 그림자
                      BoxShadow(color: Color(0xffCBCBCB)),

                      //버튼색
                      BoxShadow(
                        blurRadius: 10,
                        color: Color(0xffF8F8F8),
                        offset: Offset(-5, -5),
                      )
                    ]),
                padding: const EdgeInsets.only(left: 20, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icon/icon_profile.svg',
                      width: 50,
                      color: const Color(0xffEBEBEB),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '탈퇴한 사용자입니다.',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: widget.isClicked
                              ? Colors.white
                              : const Color(0xffc1c1c1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
