import 'package:aliens/views/components/appbar.dart';
import 'package:aliens/views/components/mbtibutton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../components/button.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

int selectedStack = -1;
final List<Map<String, dynamic>> mbtiList = [
  {
    'mbti': 'ENTJ',
    'text': 'signup-mbti.a'.tr(),
    'explain': 'signup-mbti.1'.tr(),
    'step': '9',
    'image': 'assets/mbti/ENTJ.svg'
  }, //ENTJ
  {
    'mbti': 'ENTP',
    'text': 'signup-mbti.a'.tr(),
    'explain': 'signup-mbti.2'.tr(),
    'step': '10',
    'image': 'assets/mbti/ENTP.svg'
  }, //ENTP

  {
    'mbti': 'ESTJ',
    'text': 'signup-mbti.b'.tr(),
    'explain': 'signup-mbti.3'.tr(),
    'step': '13',
    'image': 'assets/mbti/ESTJ.svg'
  }, //ESTJ
  {
    'mbti': 'ESFJ',
    'text': 'signup-mbti.b'.tr(),
    'explain': 'signup-mbti.4'.tr(),
    'step': '15',
    'image': 'assets/mbti/ESFJ.svg'
  }, //ESFJ

  {
    'mbti': 'ENFJ',
    'text': 'signup-mbti.c'.tr(),
    'explain': 'signup-mbti.5'.tr(),
    'step': '11',
    'image': 'assets/mbti/ENFJ.svg'
  }, //ENFJ
  {
    'mbti': 'ENFP',
    'text': 'signup-mbti.c'.tr(),
    'explain': 'signup-mbti.6'.tr(),
    'step': '12',
    'image': 'assets/mbti/ENFP.svg'
  }, //ENFP

  {
    'mbti': 'ESTP',
    'text': 'signup-mbti.d'.tr(),
    'explain': 'signup-mbti.7'.tr(),
    'step': '14',
    'image': 'assets/mbti/ESTP.svg'
  }, //ESTP
  {
    'mbti': 'ESFP',
    'text': 'signup-mbti.d'.tr(),
    'explain': 'signup-mbti.8'.tr(),
    'step': '16',
    'image': 'assets/mbti/ESFP.svg'
  }, //ESFP

  {
    'mbti': 'INTJ',
    'text': 'signup-mbti.a'.tr(),
    'explain': 'signup-mbti.9'.tr(),
    'step': '1',
    'image': 'assets/mbti/INTJ.svg'
  }, //INTJ
  {
    'mbti': 'INTP',
    'text': 'signup-mbti.a'.tr(),
    'explain': 'signup-mbti.10'.tr(),
    'step': '2',
    'image': 'assets/mbti/INTP.svg'
  }, //INTP

  {
    'mbti': 'ISTJ',
    'text': 'signup-mbti.b'.tr(),
    'explain': 'signup-mbti.11'.tr(),
    'step': '5',
    'image': 'assets/mbti/ISTJ.svg'
  }, //ISTJ
  {
    'mbti': 'ISFJ',
    'text': 'signup-mbti.b'.tr(),
    'explain': 'signup-mbti.12'.tr(),
    'step': '7',
    'image': 'assets/mbti/ISFJ.svg'
  }, //ISFJ

  {
    'mbti': 'INFJ',
    'text': 'signup-mbti.c'.tr(),
    'explain': 'signup-mbti.13'.tr(),
    'step': '3',
    'image': 'assets/mbti/INFJ.svg'
  }, //INFJ
  {
    'mbti': 'INFP',
    'text': 'signup-mbti.c'.tr(),
    'explain': 'signup-mbti.14'.tr(),
    'step': '4',
    'image': 'assets/mbti/INFP.svg'
  }, //INFP

  {
    'mbti': 'ISTP',
    'text': 'signup-mbti.d'.tr(),
    'explain': 'signup-mbti.15'.tr(),
    'step': '6',
    'image': 'assets/mbti/ISTP.svg'
  }, //ISTP
  {
    'mbti': 'ISFP',
    'text': 'signup-mbti.d'.tr(),
    'explain': 'signup-mbti.16'.tr(),
    'step': '8',
    'image': 'assets/mbti/ISFP.svg'
  }, //ISFP
];

class SignUpMbti extends StatefulWidget {
  const SignUpMbti({super.key});

  @override
  State<SignUpMbti> createState() => _SignUpMbtiState();
}

class _SignUpMbtiState extends State<SignUpMbti> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedStack = -1;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    dynamic member = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        backgroundColor: const Color(0xffF5F7FF),
        infookay: true,
        infocontent: 'signup-mbtiinfo'.tr(),
      ),
      body:
          //padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
          Container(
        padding: EdgeInsets.only(
            right: 12,
            left: 20,
            top: MediaQuery.of(context).size.height * 0.06,
            bottom: MediaQuery.of(context).size.height * 0.06),
        color: const Color(0xffF5F7FF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${member.name}${'signup-mbti'.tr()}',
              style: TextStyle(
                  fontSize: isSmallScreen ? 22 : 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.01),
                  child: Column(
                    children: [
                      for (int i = 0; i < 8; i++)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MbtiButton(
                                  text: mbtiList[2 * i]['text'],
                                  explain: mbtiList[2 * i]['explain'],
                                  mbti: (mbtiList[2 * i]['mbti']),
                                  selected: selectedStack == (2 * i),
                                  step: mbtiList[2 * i]['step'],
                                  onPressed: () =>
                                      setState(() => selectedStack = 2 * i),
                                  image: mbtiList[2 * i]['image'],
                                ),
                                MbtiButton(
                                    text: mbtiList[(2 * i + 1)]['text'],
                                    explain: mbtiList[(2 * i + 1)]['explain'],
                                    mbti: (mbtiList[(2 * i + 1)]['mbti']),
                                    selected: selectedStack == (2 * i + 1),
                                    step: mbtiList[(2 * i + 1)]['step'],
                                    onPressed: () => setState(
                                        () => selectedStack = (2 * i + 1)),
                                    image: mbtiList[(2 * i + 1)]['image']),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Button(
                //수정
                isEnabled: selectedStack != -1,
                child: Text('confirm'.tr(),
                    style: TextStyle(
                        color: selectedStack != -1
                            ? Colors.white
                            : const Color(0xff888888))),
                onPressed: () {
                  if (selectedStack != -1) {
                    member.mbti = mbtiList[selectedStack]['mbti'];
                    print(member.toJson());
                    Navigator.pushNamed(context, '/profile', arguments: member);
                  }
                })
          ],
        ),
      ),
    );
  }
}
