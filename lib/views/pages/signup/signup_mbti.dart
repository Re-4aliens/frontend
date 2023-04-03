import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import '../../../models/members.dart';
import '../../components/button.dart';
import 'package:aliens/views/components/mbtibutton.dart';

class SignUpMbti extends StatefulWidget {
  const SignUpMbti({super.key});

  @override
  State<SignUpMbti> createState() => _SignUpMbtiState();
}

class _SignUpMbtiState extends State<SignUpMbti> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    var _selected = '';
    final List<Map<String, dynamic>> _mbtiList = [
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'},
      {'mbti': 'INTJ', 'mbtiType': '분석가형', 'mbtiType_2': '전락가'}
    ];

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
            for (int i = 0; i < 8; i++)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      mbtiButton(
                        text: (_mbtiList[2 * i]['mbtiType']),
                        explain: (_mbtiList[2 * i]['mbtiType_2']),
                        mbti: (_mbtiList[2 * i]['mbti']),
                        isSelected: _selected,
                      ),
                      mbtiButton(
                        text: (_mbtiList[2 * i + 1]['mbtiType']),
                        explain: (_mbtiList[2 * i + 1]['mbtiType_2']),
                        mbti: (_mbtiList[2 * i]['mbti']),
                        isSelected: _selected,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            Button(
                child: Text('확인'),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/profile', /*arguments: members*/
                  );
                })
          ],
        ),
      ),
    );
  }
}
