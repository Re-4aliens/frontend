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

    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        onPressed: () {},
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '부경대학교\n학생이신가요?',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('부경대학교 코드를 입력해주세요'),
            SizedBox(height: 40),
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) =>
                    value!.isEmpty ? "Please enter some text" : null,
                controller: _SchoolController,
                decoration: new InputDecoration(hintText: '부경대학교 코드를 입력해주세요'),
              ),
            ),
            Expanded(child: SizedBox()),
            Button(
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
