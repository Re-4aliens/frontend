import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class SignUpSchool extends StatefulWidget {
  const SignUpSchool({super.key});

  @override
  State<SignUpSchool> createState() => _SignUpSchoolState();
}

class _SignUpSchoolState extends State<SignUpSchool> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _SchoolController = TextEditingController();

  Widget build(BuildContext context) {
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(appBar: AppBar(), title: '',backgroundColor: Colors.transparent, infookay: false, infocontent: '',),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('부경대학교\n학생이신가요?',
              style: TextStyle(fontSize: isSmallScreen?22:24, fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.013),
            Text('부경대학교 코드를 입력해주세요', style: TextStyle(fontSize: isSmallScreen?12:14, color: Color(0xff888888)),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
             Form(
               key: _formKey,
               child: TextFormField(
                     validator : (value) => value!.isEmpty? "Please enter some text" : null,
                     controller: _SchoolController,
                     decoration: new InputDecoration(
                         hintText: '부경대학교 코드를 입력해주세요',
                         hintStyle: TextStyle(fontSize: isSmallScreen?18:20, color: Color(0xffD9D9D9))

               ),
                   ),
               ),
            Expanded(child: SizedBox()),
            Button(
              //수정
                isEnabled: true,
                child: Text('다음'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print(member.toJson());
                    Navigator.pushNamed(context, '/email', arguments: member);
                  }
                })
          ],
        ),
      ),
    );
  }
}
