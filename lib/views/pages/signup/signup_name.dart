import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class SignUpName extends StatefulWidget{
  const SignUpName({super.key});

  @override
  State<SignUpName> createState() => _SignUpNameState();
}

class _SignUpNameState extends State<SignUpName>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _NameController = TextEditingController();

  Widget build(BuildContext context){
    //Members members = new Members('','','','','','','','');

    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이름을 알려주세요',
              style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.04, fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
             Form(
               key: _formKey,
               child: TextFormField(
                     validator : (value) => value!.isEmpty? "Please enter some text" : null,
                     controller: _NameController,
                     decoration: new InputDecoration(
                         hintText: '이름',
                       hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.032, color: Color(0xffD9D9D9))
                     ),
                   ),
               ),
            Expanded(child: SizedBox()),
            Button(
                child: Text('다음'),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    Navigator.pushNamed(context,'/birthday', /*arguments: members*/);
                  }
                })

          ],
        ),
      ),
    );
  }
}