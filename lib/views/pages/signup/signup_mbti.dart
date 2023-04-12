import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import '../../../models/members.dart';
import '../../components/button.dart';
import 'package:aliens/views/components/mbtibutton.dart';

int selectedStack = -1;
final List<Map<String, dynamic>> mbtiList = [
  {
    'mbti': 'INTJ',
    'text': '분석가형',
    'explain': '전락가',
    'step': '1',
  },
  {
    'mbti': 'INTP',
    'text': '분석가형',
    'explain': '전락가',
    'step': '2'
  },
  {
    'mbti': 'INFJ',
    'text': '분석가형',
    'explain': '전락가',
    'step': '3'
  },
  {
    'mbti': 'INFP',
    'text': '분석가형',
    'explain': '전락가',
    'step': '4'
  },
  {
    'mbti': 'ISTJ',
    'text': '분석가형',
    'explain': '전락가',
    'step': '5'
  },
  {
    'mbti': 'ISTP',
    'text': '분석가형',
    'explain': '전락가',
    'step': '6'
  },
  {
    'mbti': 'ISFJ',
    'text': '분석가형',
    'explain': '전락가',
    'step': '7'
  },
  {
    'mbti': 'ISFP',
    'text': '분석가형',
    'explain': '전락가',
    'step': '8'
  },
  {
    'mbti': 'ENTJ',
    'text': '분석가형',
    'explain': '전락가',
    'step': '9'
  },
  {
    'mbti': 'ENTP',
    'text': '분석가형',
    'explain': '전락가',
    'step': '10'
  },
  {
    'mbti': 'ENFJ',
    'text': '분석가형',
    'explain': '전락가',
    'step': '11'
  },
  {
    'mbti': 'ENFP',
    'text': '분석가형',
    'explain': '전락가',
    'step': '12'
  },
  {
    'mbti': 'ESTJ',
    'text': '분석가형',
    'explain': '전락가',
    'step': '13'
  },
  {
    'mbti': 'ESTP',
    'text': '분석가형',
    'explain': '전락가',
    'step': '14'
  },
  {
    'mbti': 'ESFJ',
    'text': '분석가형',
    'explain': '전락가',
    'step': '15'
  },
  {
    'mbti': 'ESFP',
    'text': '분석가형',
    'explain': '전락가',
    'step': '16'
  },
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
    dynamic member = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        onPressed: () {},
      ),
      body: SingleChildScrollView(
        
        padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ooo님의 MBTI가 궁금해요!',
              style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.04, fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
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
    );
  }
}
