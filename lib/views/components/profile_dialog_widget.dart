import 'package:dash_flags/dash_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/countries.dart';
import '../../models/partner_model.dart';

class ProfileDialog extends StatefulWidget {
  const ProfileDialog({super.key, required this.partner});
  final Partner partner;

  @override
  State<StatefulWidget> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  @override
  Widget build(BuildContext context) {
    var flagSrc = '';
    for (Map<String, String> country in countries) {
      if (country['name'] == widget.partner.nationality.toString()) {
        flagSrc = country['code']!;
        break;
      }
    }
    return Center(
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
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Icon(Icons.close),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    Text(
                      '${widget.partner.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        '${widget.partner.selfIntroduction}',
                        style: const TextStyle(
                          color: Color(0xff888888),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffF1F1F1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 15, right: 20),
                      child: Stack(
                        children: [
                          Text(
                            '       ${widget.partner.nationality}, ${widget.partner.mbti}',
                            style: const TextStyle(
                                fontSize: 16, color: Color(0xff616161)),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: SizedBox(
                                width: 21,
                                height: 14,
                                child: CountryFlag(
                                  country: Country.fromCode(flagSrc),
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
                      alignment: Alignment.topCenter,
                      child: widget.partner.profileImage == null
                          ? Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white),
                              padding: const EdgeInsets.all(5),
                              child: SvgPicture.asset(
                                'assets/icon/icon_profile.svg',
                                color: const Color(0xffEBEBEB),
                              ),
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          widget.partner.profileImage!))),
                              padding: const EdgeInsets.all(5),
                            )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xffebebeb),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        widget.partner.gender == 'MALE'
                            ? Icons.male_rounded
                            : Icons.female_rounded,
                        size: 15,
                        color: const Color(0xff7898ff),
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
