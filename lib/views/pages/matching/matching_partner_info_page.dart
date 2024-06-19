import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MatchingPartnerInfoPage extends StatefulWidget {
  const MatchingPartnerInfoPage({super.key});

  @override
  State<MatchingPartnerInfoPage> createState() =>
      _MatchingPartnerInfoPageState();
}

class _MatchingPartnerInfoPageState extends State<MatchingPartnerInfoPage> {
  @override
  Widget build(BuildContext context) {
    final info =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8F8F8),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                          color: Colors.black.withOpacity(0.1))
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: Colors.white,
                    width: 350,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xff4976FF),
                            ),
                            //버튼색
                            BoxShadow(
                              blurRadius: 10,
                              color: Color(0xff7898FF),
                              offset: Offset(-5, -5),
                            ),
                          ]),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -80,
                            left: -40,
                            child: Container(
                              width: 180,
                              height: 180,
                              margin: const EdgeInsetsDirectional.symmetric(
                                  vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: const Color(0xff94ADFF),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 100,
                            right: 60,
                            child: Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsetsDirectional.symmetric(
                                  vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: const Color(0xff6D90FF),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(flex: 5, child: Container()),
                              SvgPicture.asset(
                                'assets/icon/icon_profile.svg',
                                width: 100,
                                color: const Color(0xffEBEBEB),
                              ),
                              Expanded(flex: 1, child: Container()),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff557EFF),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 20, right: 20),
                                child: Stack(
                                  children: [
                                    Text(
                                      '${info['name']}      ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Center(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Icon(
                                            info['gender'] == 'FEMALE'
                                                ? Icons.female_rounded
                                                : Icons.male_rounded,
                                            color: const Color(0xff7898ff),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(flex: 2, child: Container()),
                              Container(
                                width: 350,
                                margin: const EdgeInsets.only(
                                    left: 40, right: 40, top: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          '국가',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '${info['nationality']}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 80,
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          'MBTI',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '${info['mbti']}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(flex: 4, child: Container()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    //color: Colors.blue.shade300,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
