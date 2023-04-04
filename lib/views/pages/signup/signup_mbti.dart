import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import '../../../models/members.dart';
import '../../components/button.dart';
import 'package:aliens/views/components/mbtibutton.dart';

var selected = '';
dynamic btnColor = Colors.grey;
final List<Map<String, dynamic>> mbtiList = [
  {
    'mbti': 'INTJ',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'INTP',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'INFJ',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'INFP',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'ISTJ',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'ISTP',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'ISFJ',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'ISFP',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'ENTJ',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'ENTP',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'ENFJ',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'ENFP',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'ESTJ',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'ESTP',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'ESFJ',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
  {
    'mbti': 'ESFP',
    'mbtiType': '분석가형',
    'mbtiType_2': '전락가',
    'color': btnColor
  },
];

class SignUpMbti extends StatefulWidget {
  const SignUpMbti({super.key});

  @override
  State<SignUpMbti> createState() => _SignUpMbtiState();
}

class _SignUpMbtiState extends State<SignUpMbti> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Widget build(BuildContext context) {
    dynamic member = ModalRoute.of(context)!.settings.arguments;

    Widget makeButton (){
      setState(() {

      });
      return Column(
        children: [
          for (int i = 0; i < 8; i++)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    mbtiButton(
                      text: (mbtiList[2 * i]['mbtiType']),
                      explain: (mbtiList[2 * i]['mbtiType_2']),
                      mbti: (mbtiList[2 * i]['mbti']),
                      color: mbtiList[2 * i]['color'],
                    ),
                    mbtiButton(
                      text: (mbtiList[(2 * i + 1)]['mbtiType']),
                      explain: (mbtiList[(2 * i + 1)]['mbtiType_2']),
                      mbti: (mbtiList[(2 * i + 1)]['mbti']),
                      color: mbtiList[2 * i]['color'],
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
        ],
      );
    }
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        onPressed: () {},
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ooo님의 MBTI가 궁금해요!',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            makeButton(),
            Button(
                child: Text('확인'),
                onPressed: () {
                  if (selected != '') {
                    member.mbti = selected;
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
