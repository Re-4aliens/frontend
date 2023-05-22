import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/members.dart';
import '../../components/button.dart';
import 'package:aliens/views/components/mbtibutton.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

int selectedStack = -1;
final List<Map<String, dynamic>> mbtiList = [
  {
    'mbti': 'INTJ',
    'text': '분석가형',
    'explain': '전락가',
    'step': '1',
  },//INTJ
  {
    'mbti': 'INTP',
    'text': '분석가형',
    'explain': '논리술사',
    'step': '2'
  },//INTP
  {
    'mbti': 'INFJ',
    'text': '외교관형',
    'explain': '옹호자',
    'step': '3'
  },//INFJ
  {
    'mbti': 'INFP',
    'text': '외교관형',
    'explain': '중재자',
    'step': '4'
  },//INFP
  {
    'mbti': 'ISTJ',
    'text': '관리자형',
    'explain': '현실주의자',
    'step': '5'
  },//ISTJ
  {
    'mbti': 'ISTP',
    'text': '탐험가형',
    'explain': '장인',
    'step': '6'
  },//ISTP
  {
    'mbti': 'ISFJ',
    'text': '관리자형',
    'explain': '수호자',
    'step': '7'
  },//ISFJ
  {
    'mbti': 'ISFP',
    'text': '분석가형',
    'explain': '전락가',
    'step': '8'
  },//ISFP
  {
    'mbti': 'ENTJ',
    'text': '분석가형',
    'explain': '통솔가',
    'step': '9'
  },//ENTJ
  {
    'mbti': 'ENTP',
    'text': '분석가형',
    'explain': '변론가',
    'step': '10'
  },//ENTP
  {
    'mbti': 'ENFJ',
    'text': '외교관형',
    'explain': '선도자',
    'step': '11'
  },//ENFJ
  {
    'mbti': 'ENFP',
    'text': '외교관형',
    'explain': '활동가',
    'step': '12'
  },//ENFP
  {
    'mbti': 'ESTJ',
    'text': '관리자형',
    'explain': '경영자',
    'step': '13'
  },//ESTJ
  {
    'mbti': 'ESTP',
    'text': '탐험가형',
    'explain': '사업가',
    'step': '14'
  },//ESTP
  {
    'mbti': 'ESFJ',
    'text': '관리자형',
    'explain': '집정관',
    'step': '15'
  },//ESFJ
  {
    'mbti': 'ESFP',
    'text': '탐험가형',
    'explain': '연예인',
    'step': '16'
  },//ESFP
];

class SignUpMbti extends StatefulWidget {
  const SignUpMbti({super.key});

  @override
  State<SignUpMbti> createState() => _SignUpMbtiState();
}

class _SignUpMbtiState extends State<SignUpMbti> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedStack = -1;
  }

  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    dynamic member = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        backgroundColor: Color(0xffF5F7FF),
        infookay: true, infocontent: '\nMBTI를 선택해주세요.\n상대방이 보는 나의 프로필을 통해\nMBTI를 공유할 수 있어요!',
      ),
      body: SingleChildScrollView(
        //padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Container(
          padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
          color: Color(0xffF5F7FF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${member.name}님의 MBTI가 궁금해요!',
                style: TextStyle(fontSize: isSmallScreen?22:24, fontWeight: FontWeight.bold),),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
                child: Column(
                  children: [
                    for (int i = 0; i < 8; i++)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              mbtiButton(
                                text: mbtiList[2 * i]['text'],
                                explain: mbtiList[2 * i]['explain'],
                                mbti: (mbtiList[2 * i]['mbti']),
                                selected: selectedStack == (2 * i),
                                step: mbtiList[2 * i]['step'],
                                onPressed: () => setState(() => selectedStack = 2 * i),
                              ),
                              mbtiButton(
                                text: mbtiList[(2 * i + 1)]['text'],
                                explain: mbtiList[(2 * i + 1)]['explain'],
                                mbti: (mbtiList[(2 * i + 1)]['mbti']),
                                selected: selectedStack == (2 * i + 1),
                                step: mbtiList[(2 * i + 1)]['step'],
                                onPressed: () =>
                                    setState(() => selectedStack = (2 * i + 1)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Button(
                  child: Text('확인'),
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
      ),
    );
  }
}