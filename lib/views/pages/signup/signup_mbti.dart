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
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
                mbtiButton(text: ('분석가형'), explain: ('전략가'), mbti: ('INTJ'),),
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

