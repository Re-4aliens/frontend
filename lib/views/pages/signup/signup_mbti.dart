import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import '../../../models/members.dart';
import '../../components/button.dart';
import 'package:aliens/views/components/mbtibutton.dart';

class SignUpMbti extends StatefulWidget{
  const SignUpMbti({super.key});

  @override
  State<SignUpMbti> createState() => _SignUpMbtiState();
}

class _SignUpMbtiState extends State<SignUpMbti>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int selectedStack = 0;
  Widget build(BuildContext context){
    //Members members = new Members('','','','','','','','');

    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(right: 20,left: 20,top: 50,bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ooo님의 MBTI가 궁금해요!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 0,
                step: '1',
                onPressed: () => setState(() => selectedStack = 0),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 1,
                  step: '2',
                  onPressed: () => setState(() => selectedStack = 1),),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 2,
                  step: '3',
                  onPressed: () => setState(() => selectedStack = 2),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 3,
                  step: '4',
                  onPressed: () => setState(() => selectedStack = 3),),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 4,
                  step: '5',
                  onPressed: () => setState(() => selectedStack = 4),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 5,
                  step: '6',
                  onPressed: () => setState(() => selectedStack = 5),),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 6,
                  step: '7',
                  onPressed: () => setState(() => selectedStack = 6),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 7,
                  step: '8',
                  onPressed: () => setState(() => selectedStack = 7),),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 8,
                  step: '9',
                  onPressed: () => setState(() => selectedStack = 8),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 9,
                  step: '10',
                  onPressed: () => setState(() => selectedStack = 9),),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 10,
                  step: '11',
                  onPressed: () => setState(() => selectedStack = 10),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 11,
                  step: '12',
                  onPressed: () => setState(() => selectedStack = 11),),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 12,
                  step: '13',
                  onPressed: () => setState(() => selectedStack = 12),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 13,
                  step: '14',
                  onPressed: () => setState(() => selectedStack = 13),),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 14,
                  step: '15',
                  onPressed: () => setState(() => selectedStack = 14),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'), selected: selectedStack == 15,
                  step: '16',
                  onPressed: () => setState(() => selectedStack = 15),),
              ],
            ),
            SizedBox(height: 20),
            Button(
                child: Text('확인'),
                onPressed: (){
                  Navigator.pushNamed(context,'/profile', /*arguments: members*/);
                })
          ],
        ),
      ),
    );
  }
}

