import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileDialog extends StatefulWidget{
  const ProfileDialog({super.key, required this.partner});
  final partner;

  @override
  State<StatefulWidget> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog>{


  @override
  Widget build(BuildContext context) {

    var flagSrc = widget.partner.nationality.toString();
    flagSrc = flagSrc.substring(flagSrc.indexOf(' ') + 1, flagSrc.length);

    return Center(
      child: Container(
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
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Padding(
                            padding:
                            const EdgeInsets
                                .all(15.0),
                            child:
                            Icon(Icons.close),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pop();
                          },
                        ),
                      ],
                    ),
                    Text(
                      '${widget.partner.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.all(15),
                      child: Text(
                        '안녕하세요! 경영학과 23학번 입니다!',
                        style: TextStyle(
                          color: Color(0xff888888),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffF1F1F1),
                        borderRadius:
                        BorderRadius.circular(
                            20),
                      ),
                      padding: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: 15,
                          right: 20),
                      child: Stack(
                        children: [
                          Text(
                            '       ${widget.partner.nationality}, ${widget.partner.mbti}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(
                                    0xff616161)),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: SvgPicture.asset(
                              'assets/flag/${flagSrc}.svg',
                              width: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 340,
              height: 105,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              100),
                          color: Colors.white),
                      padding: EdgeInsets.all(5),
                      child: SvgPicture.asset(
                        'assets/icon/icon_profile.svg',
                        color: Color(0xffEBEBEB),
                      ),
                    ),
                  ),
                  Align(
                    alignment:
                    Alignment.bottomCenter,
                    child: Container(
                      height: 20,
                      width: 20,
                      child: Icon(
                        widget.partner.gender ==
                            'MALE'
                            ? Icons.male_rounded
                            : Icons.female_rounded,
                        size: 15,
                        color: Color(0xff7898ff),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffebebeb),
                        borderRadius:
                        BorderRadius.circular(
                            10),
                      ),
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